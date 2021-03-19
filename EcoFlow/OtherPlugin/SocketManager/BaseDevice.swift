//
//  BaseDevice.swift
//  EcoFlow
//
//  Created by apple on 2020/5/23.
//  Copyright © 2020 wangwei. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol DeviceBasicMethod {
    func getChargerIconName(with type: UInt8) -> String
    func resetDevice(success:@escaping () -> Void, failed:@escaping (_ msg: String) -> Void)
    func restoreDevice(success:@escaping () -> Void, failed:@escaping (_ msg: String) -> Void)
    func setLED(state: Int, success:@escaping () -> Void, failed:@escaping (_ msg: String) -> Void)
    func setMaxChgSoc(percent: UInt8, success: (() -> Void)?, failed: ((_ msg: String) -> Void)?)
    func setBeep(state: UInt8, success: (() -> Void)?, failed: ((_ msg: String) -> Void)?)
    func setAC(state: UInt8, success: (() -> Void)?, failed: ((_ msg: String) -> Void)?)
    func setDC(state: UInt8, success: (() -> Void)?, failed: ((_ msg: String) -> Void)?)
    //输出频率，state=1是50Hz，2是60Hz
    func setOutFreq(state: UInt8, success: (() -> Void)?, failed: ((_ msg: String) -> Void)?)
    func setXboost(state: UInt8, success: (() -> Void)?, failed: ((_ msg: String) -> Void)?)
    func setStandbyTime(time: UInt16, success: (() -> Void)?, failed: ((_ msg: String) -> Void)?)
    func setChargingMode(mode: UInt8, success: (() -> Void)?, failed: ((_ msg: String) -> Void)?)
    func getLcdStandbyTime(completion:@escaping (_ time: Int) -> Void)
    func getMPPT(completion:@escaping (_ value: Int) -> Void)
    func setLcdStandbyTime(seconds: UInt16, failed: ((_ msg: String) -> Void)?)
    func setMPPT(mode: Int, failed: ((_ msg: String) -> Void)?)
    func getDeviceLogs()
    func unbindDevice(success:@escaping () -> Void, failed:@escaping (_ msg: String) -> Void)
    func createTcpConnect()
    func closeTcpConnect()
}


class BaseDevice: NSObject, DeviceBasicMethod {
    private let deviceModel: DeviceModel
    var resetDeviceMySelf: Bool = false
    var staIP: String?
    var staMAC: String = "00:00:00:00:00:00"
    var devType: String = "Unknown"
    var espVer: String = "0.0.0" //ESP wifi firmware version
    var devHost: String = "- - -"
    var devID: String = "000000000000" //wifi ID
    var product: UInt16?
    var isRemoteDevice = true
    var moduleUpdated:[Bool] = [false, false, true,false]
    private var isModuleInit:[Bool] = [false, false, false, false]
    var isUpgradingFW = false
    var isUpgradeResult = false
    var pd_inLoader = false
    var inv_inLoader = false
    var bms_m_inLoader = false
    var bms_s_inLoader = false
    var mppt_inloader = false
    var lcdStandbyTime:UInt16 = 0
    var apConnectSendTimer: Timer?
    var apConnectSendCount = 0
    var pd_curVer: String?
    var pd_newVer: String?
    var pd_result: Int?
    var inv_curVer: String?
    var inv_newVer: String?
    var inv_result: Int?
    var bms_m_curVer: String?
    var bms_m_newVer: String?
    var bms_m_result: Int?
    var bms_s_curVer: String?
    var bms_s_newVer: String?
    var bms_s_result: Int?
    var mppt_curVer: String?
    var mppt_newVer: String?
    var mppt_result: Int?
    var upgradeStartTime: String?
    var upgradeEndTime: String?
    var networkError:String {
        LanguageHelper.shareInstance.getAppStr("NoNetwork", comment: "")
    }
    private var testDecodeCount = 0
    
    fileprivate let statePD = EFHeartbeatPD()
    fileprivate var stateINV = EFHeartbeatInv()
    fileprivate let stateBMSMaster = EFHeartbeatBMS()
    fileprivate let stateBMSSlave = EFHeartbeatBMSSlave()
    fileprivate let stateMppt = EFHeartbeatMppt()
    
    
    var onModelChanged: ((_ device: BaseDevice) -> Void)?
    var getSNFromTcp: (() -> Void)?
    var didReceiveSysParams: ((_ type: SysParamsType, _ params: [SystemParamsModel]) -> Void)?
    var didReceiveLogs: ((_ type: SysParamsType, _ params: [DeviceEventModel]) -> Void)?
    var didReceiveWorkMode: ((_ value: Int) -> Void)?
    var tcpDisconnectHandler: (() -> Void)?
    
    private var tcpConn: TcpHelper?
    
    var deviceInLoader: Bool {
        return  pd_inLoader || inv_inLoader || bms_m_inLoader || bms_s_inLoader || mppt_inloader
    }
    
    var isExsitModule: Bool {
        if (deviceModel.productType == 5 && deviceModel.model == 2) || (deviceModel.productType == 7 && deviceModel.model == 5){
            return true
        }
        return false
    }
    var isMR310: Bool {
        if deviceModel.productType == 13 && deviceModel.model == 1 {
            return true
        }
        return false
    }
    var isSNRight: Bool  {
        if getSN() == "x" {
            return false
        }
        let reg = "^[a-zA-Z0-9]+$"
        let pre = NSPredicate(format: "SELF MATCHES %@", reg)
        if pre.evaluate(with: getSN()) {
            return true
        }
        return false
    }
    var deviceImageName: String {
        let productType = "\(getProductType())"
        let model = "\(getHardwareModel())"
        guard let img = Constants.EF_MODEL_LIST[productType]?[model]?["img"] else {
            return "question_mark"
        }
        return img
    }
    
    var modelName: String {
        let productType = "\(getProductType())"
        let model = "\(getHardwareModel())"
        guard let name = Constants.EF_MODEL_LIST[productType]?[model]?["name"] else {
            return "R600 -"
        }
        return name
    }
    
    init(with model: DeviceModel) {
        self.deviceModel = model
    }
    
    
    // getters
    func getDeviceModel() -> DeviceModel {
        return deviceModel
    }
    
    func getDeviceName() -> String {
        return getDeviceModel().devName
    }
    
    func getSN() -> String {
        return getDeviceModel().devSN
    }
    
    func getHardwareModel() -> Int {
        return getDeviceModel().model
    }
    
    func getProductType() -> Int {
        return getDeviceModel().productType
    }
    
    func getConnected() -> Bool {
        return getDeviceModel().connected
    }
    
    func getTcpConnection() -> TcpHelper? {
        return tcpConn
    }
    
    func getPD() -> EFHeartbeatPD {

        return statePD
    }
    
    func getINV() -> EFHeartbeatInv {

        return stateINV
    }
    
    func getBMSMaster() -> EFHeartbeatBMS {

        return stateBMSMaster
    }
    
    func getBMSSlave() -> EFHeartbeatBMSSlave {

        return stateBMSSlave
    }
    func getMppt() -> EFHeartbeatMppt {
        return stateMppt
    }
    //some setters
    func setCfgOutFreq(val: UInt8) {
        stateINV.cfgOutFreq = val
    }
    
    
    //protocols
    func getChargerIconName(with type: UInt8) -> String {
        if type == 0x1 {
            return "acpower"
        } else if type == 0x2 {
            return "dcpower"
        } else if type == 0x3 {
            return "sunpower"
        } else {
            return "blank"
        }
        
    }
    
    func resetDevice(success: @escaping () -> Void, failed: @escaping (String) -> Void) {
        if isRemoteDevice {
            let params = [ "sn": getSN() ]
            Debug.shared.println("复位设备过程::\(params)")
//            NetworkTools.shareInstance.request(Constants.GET_API_URL(type: .resetDevice), method: .get, parameters: params, encoding: URLEncoding.default) {[weak self]  (response) in
//                var errMsg = self?.networkError ?? ""
//                if response.error == nil {
//                    if let strDat = response.value {
//                        Debug.shared.println("复位设备过程:: \(strDat)")
//                        do {
//                            let jsonDat = try JSON(data: strDat.data(using: String.Encoding.utf8)!)
//                            if strDat.contains("success") {
//                                success()
//                                return
//                            } else {
//                                if let msg = jsonDat["message"].string {
//                                    errMsg = msg
//                                }
//                            }
//                        } catch {
//                            Debug.shared.println("json parse exception")
//                            errMsg = "json parse exception"
//                        }
//                    } else {
//                        //return nil string
//                        errMsg = "HTTP echo nil string"
//                    }
//                }
//                Debug.shared.println("复位设备失败: \(String(describing: response.error)), \(errMsg)")
//                failed(errMsg)
//            }
        } else {
            resetDeviceMySelf = true
            let package = EFProtocol.shareInstance.generateCommand(type: .resetDevice, cmdData: [], product: (self.product ?? 0xFFFF))
            tcpConn?.tcpSend(buff: package)
        }
    }
    
    func restoreDevice(success:@escaping () -> Void, failed:@escaping (_ msg: String) -> Void) {
        guard let ip = self.staIP else {
            failed(LanguageHelper.shareInstance.getAppStr("ActionFailed", comment: ""))
            return
        }
        
        let params = [
            "action": "resetAP",
        ]
        
//        AF.request("http://\(ip)", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseString { [weak self] (response) in
//            if response.error == nil {
//                if let strDat = response.value {
//                    Debug.shared.println("restore过程:: \(strDat)")
//                    if let weakSelf = self, strDat.contains("Msg\":\"success") {
//                       // Globals.removeDevice(for: weakSelf.getSN(), from: false)
//                        success()
//                        return
//                    } else {
//                        //设置router失败？
//                    }
//                } else {
//                    //return nil string
//                }
//            }
//
//            Debug.shared.println("restore过程::\(String(describing: response.error))")
//            failed(LanguageHelper.shareInstance.getAppStr("ActionFailed", comment: ""))
//        }
    }
    
    // MARK: - 蓝牙测试
    @objc class func testBlueTooth(state: Int) -> (Data) {
        let pack = EFProtocol.shareInstance.generateBlueToothCommand(type: .getStatus)
        let data = Data(pack)
        return data
    }
    
    @objc class func testBlueToothSN(state: Int) -> (Data) {
        let pack = EFProtocol.shareInstance.generateBlueToothCommand(type: .getSN)
        let data = Data(pack)
        return data
    }
    // MARK: - 设备操作
    @objc class func configLEDByLan(state: Int) -> (Data) {
        Debug.shared.println("设备SN命令：sn= 发送getSN命令")
//        let pack = EFProtocol.shareInstance.generateCommand(type: .getStatus, product: (0xFFFF))
//        let pack = EFProtocol.shareInstance.generateCommand(type: .getSystemLogs, cmdData: [], product: 0)
//        Debug.shared.printHex(data: pack)
//        Debug.shared.println("~~~~~~~~~~~")

        let pack = EFProtocol.shareInstance.generateCommand(type: .setLED, cmdData: [UInt8(state)], product: (0xFFFF))
        let data = Data(pack)
        
//        let str = String.init(data: data, encoding: .utf8)!
        return data
    }
    
    func setLED(state: Int, success:@escaping () -> Void, failed:@escaping (_ msg: String) -> Void) {
        if isRemoteDevice {
            let params = [
                "sn": getSN(),
                "cfg": ["id": 35, "state": state]
            ] as [String : Any]
            Debug.shared.println("设置设备过程::\(params)")
            remoteHTTPRequest(params: params, success: success, failed: failed)
        } else { //局域网tcp发送
            let package = EFProtocol.shareInstance.generateCommand(type: .setLED, cmdData: [UInt8(state)], product: (self.product ?? 0xFFFF)) //encode(cmdSet: EFProtocol.CMD_SET_COMMON, cmdID: EFProtocol.CMD_ID_LED_CONFIG, product: (self.product ?? 0xFFFF), data: dat, destAddr: EFProtocol.ADDR_PD)
            tcpConn?.tcpSend(buff: package)
        }
    }
    
    func setMaxChgSoc(percent: UInt8, success: (() -> Void)?, failed: ((String) -> Void)?) {
        if isRemoteDevice {
            let params = [
                "sn": getSN(),
                "cfg": ["id": Int(EFProtocol.CMD_ID_UPS_CONFIG), "max_chg_soc": Int(percent)]
            ] as [String : Any]
            Debug.shared.println("设置UPS过程::\(params)")
            remoteHTTPRequest(params: params, success: success, failed: failed)
        } else {
            let package = EFProtocol.shareInstance.generateCommand(type: .setMaxChgSoc, cmdData: [percent], product: (self.product ?? 0xFFFF))
            tcpConn?.tcpSend(buff: package)
        }
    }
    
    func setBeep(state: UInt8, success: (() -> Void)?, failed: ((String) -> Void)?) {
        if isRemoteDevice {
            let params = [
                "sn": getSN(),
                "cfg": ["id": Int(EFProtocol.CMD_ID_SET_BEEP), "enable": Int(state)]
            ] as [String : Any]
            Debug.shared.println("设置设备过程::\(params)")
            remoteHTTPRequest(params: params, success: success, failed: failed)
        } else {
            let package = EFProtocol.shareInstance.generateCommand(type: .setBeep, cmdData: [state], product: (self.product ?? 0xFFFF))
            tcpConn?.tcpSend(buff: package)
        }
    }
    
    func setAC(state: UInt8, success: (() -> Void)?, failed: ((String) -> Void)?) {
        if isRemoteDevice {
            let params = [
                "sn": getSN(),
                "cfg": ["id": Int(EFProtocol.CMD_ID_AC_OUT), "enabled": Int(state)]
            ] as [String : Any]
            Debug.shared.println("设置AC::\(params)")
            remoteHTTPRequest(params: params, success: success, failed: failed)
        } else {
            
          let package  = EFProtocol.shareInstance.generateCommand(type: .setAC, cmdData: [state,0xff,0xff,0xff,0xff,0xff,0xff], product: (self.product ?? 0xFFFF))
            tcpConn?.tcpSend(buff: package)
        }
    }
    
    func setDC(state: UInt8, success: (() -> Void)?, failed: ((String) -> Void)?) {
        if isRemoteDevice {
            let params = [
                "sn": getSN(),
                "cfg": ["id": Int(EFProtocol.CMD_ID_DC_CONFIG), "enabled": Int(state)]
            ] as [String : Any]
            Debug.shared.println("设置DC::\(params)")
            remoteHTTPRequest(params: params, success: success, failed: failed)
        } else {
            let package = EFProtocol.shareInstance.generateCommand(type: .setDC, cmdData: [state], product: (self.product ?? 0xFFFF))
            tcpConn?.tcpSend(buff: package)
        }
    }
    
    func setOutFreq(state: UInt8, success: (() -> Void)?, failed: ((String) -> Void)?) {
        if isRemoteDevice {
            let params = [
                "sn": getSN(),
                "cfg": ["id": Int(EFProtocol.CMD_ID_AC_OUT), "out_freq": Int(state)]
            ] as [String : Any]
            Debug.shared.println("设置out Freq::\(params)")
            remoteHTTPRequest(params: params, success: success, failed: failed)
        } else {
            let package = EFProtocol.shareInstance.generateCommand(type: .setOutFreq, cmdData: [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, state], product: (self.product ?? 0xFFFF))
            tcpConn?.tcpSend(buff: package)
        }
    }
    
    func setXboost(state: UInt8, success: (() -> Void)?, failed: ((String) -> Void)?) {
        if isRemoteDevice {
            let params = [
                "sn": getSN(),
                "cfg": ["id": Int(EFProtocol.CMD_ID_AC_OUT), "xboost": Int(state)]
            ] as [String : Any]
            Debug.shared.println("设置xboost::\(params)")
            remoteHTTPRequest(params: params, success: success, failed: failed)
        } else {
            let package = EFProtocol.shareInstance.generateCommand(type: .setXboost, cmdData: [0xFF, state, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF], product: (self.product ?? 0xFFFF))
            tcpConn?.tcpSend(buff: package)
        }
    }
    
    func setStandbyTime(time: UInt16, success: (() -> Void)?, failed: ((String) -> Void)?) {
        if isRemoteDevice {
            let params = [
                "sn": getSN(),
                "cfg": ["id": Int(EFProtocol.CMD_ID_STAND_BY), "standby_mode": Int(time)]
            ] as [String : Any]
            Debug.shared.println("设置standbyTime过程::\(params)")
            
            remoteHTTPRequest(params: params, success: success, failed: failed)
        } else {
            let package = EFProtocol.shareInstance.generateCommand(type: .setStandby, cmdData: [UInt8(time & 0x00FF), UInt8((time & 0xFF00) >> 8)], product: (self.product ?? 0xFFFF))
            getTcpConnection()?.tcpSend(buff: package)
        }
    }
    
    func setChargingMode(mode: UInt8, success: (() -> Void)?, failed: ((String) -> Void)?) {
        if isRemoteDevice {
            let params = [
                "sn": getSN(),
                "cfg": ["id": Int(EFProtocol.CMD_ID_WORK_MODE), "work_mode": Int(mode)]
            ] as [String : Any]
            Debug.shared.println("设置workMode过程::\(params)")
            
            remoteHTTPRequest(params: params, success: success, failed: failed)
        } else {
            let package = EFProtocol.shareInstance.generateCommand(type: .setWorkMode, cmdData: [mode], product: (self.product ?? 0xFFFF))
            getTcpConnection()?.tcpSend(buff: package)
        }
    }
    
    // MARK: - 设备获取信息
    func getLcdStandbyTime(completion: @escaping (Int) -> Void) {
        if isRemoteDevice {
            let params = [
                "sn": getSN(),
                "cfg": ["id": Int(EFProtocol.CMD_ID_GET_LCD_TIME)]
            ] as [String : Any]
            Debug.shared.println("获取LCD standby过程::\(params)")
//            NetworkTools.shareInstance.request(Constants.GET_API_URL(type: .configDevice), method: .post, parameters: params, encoding: JSONEncoding.default) {[weak self]  (response) in
//                var errMsg = self?.networkError ?? ""
//                if response.error == nil {
//                    if let strDat = response.value {
//                        Debug.shared.println("获取LCD standby过程:: \(strDat)")
//                        do {
//                            let jsonDat = try JSON(data: strDat.data(using: String.Encoding.utf8)!)
//                            if strDat.contains("code") {
//                                let code = jsonDat["code"].int
//                                if code == 0 {
//                                    if let data = jsonDat["data"].int {
//                                        completion(data)
//                                        return
//                                    }
//                                    errMsg = "No data found"
//                                } else {
//                                    errMsg = "code is not 0"
//                                    if let err = jsonDat["message"].string { errMsg = err }
//                                }
//                            }
//                        } catch {
//                            Debug.shared.println("json parse exception")
//                            errMsg = "json parse exception"
//                        }
//                    } else {
//                        //return nil string
//                        errMsg = "HTTP echo nil string"
//                    }
//                }
//                Debug.shared.println("获取LCD standby失败: \(String(describing: response.error)), \(errMsg)")
//                completion(0)
//            }
        } else {
            guard isMR310 else { //MR310不用单独发送命令获取LCDStandByTime（在PD里可以获取到）
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) { [weak self] in
                    let package = EFProtocol.shareInstance.generateCommand(type: .getLcdStandbyTime, cmdData: [0x0], product: (self?.product ?? 0xFFFF))
                    EFProtocol.shareInstance.cleanBuffer()
                    self?.getTcpConnection()?.tcpSend(buff: package)
                    Debug.shared.println("Tcp发送获取standby命令")
                }
                return
            }

        }
    }
    
    func getMPPT(completion: @escaping (Int) -> Void) {
        if isRemoteDevice {
            let params = [
                "sn": getSN(),
                "cfg": ["id": Int(EFProtocol.CMD_ID_GET_MPPT_MODE)]
            ] as [String : Any]
            Debug.shared.println("获取MPPT过程::\(params)")
//            NetworkTools.shareInstance.request(Constants.GET_API_URL(type: .configDevice), method: .post, parameters: params, encoding: JSONEncoding.default) {[weak self]  (response) in
//                var errMsg = self?.networkError ?? ""
//                if response.error == nil {
//                    if let strDat = response.value {
//                        Debug.shared.println("获取MPPT过程:: \(strDat)")
//                        do {
//                            let jsonDat = try JSON(data: strDat.data(using: String.Encoding.utf8)!)
//                            if strDat.contains("code") {
//                                let code = jsonDat["code"].int
//                                if code == 0 {
//                                    if let data = jsonDat["data"].int {
//                                        completion(data)
//                                        return
//                                    }
//                                    errMsg = "No data found"
//                                } else {
//                                    errMsg = "code is not 0"
//                                    if let err = jsonDat["message"].string { errMsg = err }
//                                }
//                            }
//                        } catch {
//                            Debug.shared.println("json parse exception")
//                            errMsg = "json parse exception"
//                        }
//                    } else {
//                        //return nil string
//                        errMsg = "HTTP echo nil string"
//                    }
//                }
//                Debug.shared.println("获取MPPT失败: \(String(describing: response.error)), \(errMsg)")
//                completion(0)
//            }
        } else {
            self.didReceiveWorkMode = completion
            let package = EFProtocol.shareInstance.generateCommand(type: .getWorkMode, cmdData: [0x0], product: (self.product ?? 0xFFFF))
            EFProtocol.shareInstance.cleanBuffer()
            getTcpConnection()?.tcpSend(buff: package)
            Debug.shared.println("发送获取mppt命令")
        }
    }
    
    func setLcdStandbyTime(seconds: UInt16, failed: ((_ msg: String) -> Void)?) {
        if isRemoteDevice {
            let params = [
                "sn": getSN(),
                "cfg": ["id": Int(EFProtocol.CMD_ID_SET_LCD_TIME), "lcd_time": seconds]
            ] as [String : Any]
            Debug.shared.println("设置LCD standby过程::\(params)")
            remoteHTTPRequest(params: params, success: nil, failed: failed)
        } else {
            let package = EFProtocol.shareInstance.generateCommand(type: .setLcdStandbyTime, cmdData: [UInt8(seconds & 0x00FF), UInt8((seconds & 0xFF00) >> 8)], product: (self.product ?? 0xFFFF))
            getTcpConnection()?.tcpSend(buff: package)
        }
    }
    
    func setMPPT(mode: Int, failed: ((String) -> Void)?) {
        if isRemoteDevice {
            let params = [
                "sn": getSN(),
                "cfg": ["id": Int(EFProtocol.CMD_ID_SET_MPPT_MODE), "mppt_mode": mode]
            ] as [String : Any]
            Debug.shared.println("设置MPPT过程::\(params)")
            remoteHTTPRequest(params: params, success: nil, failed: failed)
        } else {
            let package = EFProtocol.shareInstance.generateCommand(type: .setMPPT, cmdData: [UInt8(mode)], product: (self.product ?? 0xFFFF))
            getTcpConnection()?.tcpSend(buff: package)
        }
    }
    
    func getLocalSysParams(type: SysParamsType) {
        var pack:[UInt8]?
        switch type {
        case .pd:
            pack = EFProtocol.shareInstance.generateCommand(type: .getPDSysParams, cmdData: [0], product: (self.product ?? 0xFFFF))
            break
        case .inv:
            pack = EFProtocol.shareInstance.generateCommand(type: .getInvSysParams, cmdData: [0], product: (self.product ?? 0xFFFF))
            break
        case .bmsSlave:
            pack = EFProtocol.shareInstance.generateCommand(type: .getBmsSlaveSysParams, cmdData: [0], product: (self.product ?? 0xFFFF))
            break
        case .bmsMaster:
            pack = EFProtocol.shareInstance.generateCommand(type: .getBmsMasterSysParams, cmdData: [0], product: (self.product ?? 0xFFFF))
            break
        }
        guard let package = pack else {
            return
        }
        getTcpConnection()?.tcpSend(buff: package)
    }
    
    func getDeviceLogs() {
        //EFProtocol.shareInstance.cleanBuffer()
        let pack = EFProtocol.shareInstance.generateCommand(type: .getSystemLogs, cmdData: [], product: 0)
        getTcpConnection()?.tcpSend(buff: pack)
    }
    
    func unbindDevice(success:@escaping () -> Void, failed:@escaping (_ msg: String) -> Void) {
        let params = ["sn": getSN()]
//        NetworkTools.shareInstance.request(Constants.GET_API_URL(type: .unbindDevice), method: .post, parameters: params, encoding: URLEncoding.default) { [weak self] (response) in
//            var errMsg = self?.networkError ?? ""
//            if response.error == nil {
//                if let strDat = response.value {
//                    Debug.shared.println("解绑设备过程:: \(strDat)")
//                    do {
//                        let jsonDat = try JSON(data: strDat.data(using: String.Encoding.utf8)!)
//                        if strDat.contains("code") {
//                            let code = jsonDat["code"].int
//                            if code == 0 {
//                                if let _ = self {
//                                    Globals.removeDevice(for: self!.getSN(), from: true)
//                                }
//                                success()
//                                return
//                            } else {
//                                errMsg = "code is not 0"
//                                if let err = jsonDat["message"].string { errMsg = err }
//                            }
//                        }
//                    } catch {
//                        Debug.shared.println("json parse exception")
//                        errMsg = "json parse exception"
//                    }
//                } else {
//                    //return nil string
//                    errMsg = "HTTP echo nil string"
//                }
//            }
//            Debug.shared.println("查询设备失败: \(String(describing: response.error)), \(errMsg)")
//            failed(errMsg)
//        }
    }
    
    // MARK: - 建立TCP
    @objc func createTcpConnect() {
        var ip:String!
        if Networking.ipAddress.contains("192.168.4.") { //Ap直连控制，要把IP设置为192.168.4.1
            ip = "192.168.4.1"
        } else { //局域网TCP连接控制
            guard let staip = self.staIP else { return }
            ip = staip
        }
        if self.tcpConn == nil { //连接不存在
            self.tcpConn = TcpHelper.init(device_id: getSN(), ip: ip, port: Constants.TCP_PORT)
            self.tcpConn?.connDelegate = self
        } else {
            self.tcpConn?.connDelegate = self
        }
    }
    
    private func parseTCP(package: EFFrame) {
        let payload = EFProtocol.shareInstance.decrypt(frame: package)

        if package.cmdSet == EFProtocol.CMD_SET_COMMON {
            switch package.cmdID {
            case EFProtocol.CMD_ID_GET_SN:
                let snModel = DeviceSN(data: payload)
                Debug.shared.println("设备SN命令：sn=\(snModel.snToString()), product=\(package.product)")
                self.product = EFProtocol.shareInstance.productTypeToProduct(type: snModel.productType)
                self.deviceModel.productType = Int(snModel.productType)
                self.deviceModel.devSN = snModel.snToString().replacingOccurrences(of: "\0", with: "") //去掉末尾\0
                self.deviceModel.model = Int(snModel.model)
//                if self.deviceModel.model == 0 { //修正model值，udp扫描返回的model值可能为0
//                    if snModel.productType == 5 {
//                        self.deviceModel.model = 2
//                        onModelChanged?(self) //通知更新model
//                    } else if snModel.productType == 7 {
//                        self.deviceModel.model = 3
//                        onModelChanged?(self) //通知更新model
//                    }
//                }

                self.getSNFromTcp?()
                break
            default:
                break
            }
        } else if package.cmdSet == EFProtocol.CMD_SET_IOT_SERVER {
            switch package.cmdID {
            case EFProtocol.CMD_ID_STATUS_PUSH:
                Debug.shared.println("设备连接：\(getDeviceName())收到命令 CMD_ID_STATUS_PUSH, src=\(package.srcAddr), dest=\(package.destAddr), count=\(package.payload.count)")
                //Debug.shared.printHex(data: payload, tag: getDeviceName())
                //Debug.shared.printHex(data: package.payload, tag: "原始"+getDeviceName())
                if let type = EFHeartbeatType(rawValue: package.srcAddr) {
                    switch type {
                    case .pd:
                        statePD.updateArray(with: payload)
                        Debug.shared.println("更新模块：PD 设备LED: \(getDeviceName()), \(self.statePD.ledState)")
                        moduleUpdated[0] = true
                        if !isModuleInit[0] { isModuleInit[0] = true }
                        break
                    case .bmsMaster:
                        Debug.shared.println("更新模块：bms_m  电池上限：\(stateBMSMaster.maxChgSoc)", tag: "batteryVal")
                        stateBMSMaster.update(with: payload)
                        moduleUpdated[1] = true
                        if !isModuleInit[1] { isModuleInit[1] = true }
                        break
                    case .bmsSlave:
                        Debug.shared.println("更新模块：bms_s")
                        stateBMSSlave.update(with: payload)
                        moduleUpdated[2] = true
                        if !isModuleInit[2] { isModuleInit[2] = true }
                        break
                    case .inv:
                        stateINV.update(with: payload)
                        moduleUpdated[3] = true
                        if !isModuleInit[3] { isModuleInit[3] = true }
                        Debug.shared.println("更新模块：Inv, cfgOutFreq:\(stateINV.cfgOutFreq), AC的值：\(stateINV.invSwitch)", tag: "decoded")
                        break
                    case .mppt:
                        stateMppt.update(with: payload)
                        break
                    }
                }
                NotificationCenter.default.post(name:  NSNotification.Name(rawValue: Constants.NOTIF_NAME_DEVICE_STAT_CHANGED), object: nil, userInfo: ["stat":"0", "msg":"OK"])
                if  !moduleUpdated.contains(false) {
//                    for i in 0 ..< moduleUpdated.count { moduleUpdated[i] = false }
                      moduleUpdated = [false, false, true, false]
                }
                break
            case EFProtocol.CMD_ID_SYS_EVENT_PUSH:
                Debug.shared.println("设备连接：\(getDeviceName())收到event命令 CMD_ID_SYS_EVENT_PUSH")
                Debug.shared.printHex(data: payload, tag: getDeviceName())
                break
            case EFProtocol.CMD_ID_GET_LCD_TIME:
                guard package.payload.count >= 3 else { break }
                self.lcdStandbyTime = UInt16(package.payload[1])
                self.lcdStandbyTime += (UInt16(package.payload[2]) << 8)
                Debug.shared.println("获取LCD standby命令0:\(package.cmdID), \(payload.count), :\(payload[0]), \(payload[1]), \(payload[2])")
                guard payload.count >= 3 else { break }
                let t:UInt16 = UInt16(payload[1])+(UInt16(payload[2])<<8)
                NotificationCenter.default.post(name:  NSNotification.Name(rawValue: Constants.NOTIF_NAME_REFRESH_LCD_MPPT), object: nil, userInfo: ["time": t])
                break
            case EFProtocol.CMD_ID_GET_SYS_PARAMS:
                Debug.shared.println("sysParams返回命令:\(package.cmdID)")
                Debug.shared.printHex(data: payload, tag: "sysParams返回命令")
                let paramsModels = EFProtocol.shareInstance.parseSystemParams(data: payload)
                didReceiveSysParams?(whichPart(models: paramsModels), paramsModels)
                break
            case EFProtocol.CMD_ID_GET_SYS_LOGS:
                Debug.shared.println("返回日志数据: \(package.cmdID)")
                Debug.shared.printHex(data: payload, tag: "日志数据")
                didReceiveLogs?(.pd, EFProtocol.shareInstance.parseDeviceLogs(data: payload))
                break
            case EFProtocol.CMD_ID_GET_MPPT_MODE:
                Debug.shared.println("获取MPPT数据: \(package.cmdID)")
                Debug.shared.printHex(data: payload, tag: "MPPT数据:")
                guard payload.count > 1 else { break }
                didReceiveWorkMode?(Int(payload[1]))
                break
            case EFProtocol.CMD_ID_SYS_RESET:
                if resetDeviceMySelf {
                    DispatchQueue.main.async {
//                        UIApplication.shared.keyWindow?.makeToast(LanguageHelper.shareInstance.getAppStr("ActionOK", comment: ""), duration: 1, position: .center)
                    }
                }
                resetDeviceMySelf = false
                break
            default:
                Debug.shared.println("未知TCP返回命令:\(package.cmdID)")
                break
            }
        }
    }
    
    private func parseUpgradingData(data: JSON) {
        
        if  let _ = data["data"]["upgradeState"].null {
            isUpgradingFW = false
        }else {isUpgradingFW = true}
        
        if let  _ = data["data"]["upgradeResult"].null{
            isUpgradeResult = false
        }else {isUpgradeResult = true}
        
        pd_inLoader = data["data"]["status"]["pd"]["inLoader"].boolValue
        inv_inLoader = data["data"]["status"]["inv"]["inLoader"].boolValue
        bms_m_inLoader = data["data"]["status"]["bms_m"]["inLoader"].boolValue
        bms_s_inLoader = data["data"]["status"]["bms_s"]["inLoader"].boolValue
        mppt_inloader = data["data"]["status"]["mppt"]["inLoader"].boolValue
    }
    
    private func parseRemoteDeviceData(dataStr: String, dataJson: JSON) {
        
        parseUpgradingData(data: dataJson)
        
        self.statePD.updateString(with: dataStr)
       // self.stateMR310PD.update(with: dataStr)
        Debug.shared.println("当前inv地址3: \(stateINV.invSwitch)")
        self.stateINV.update(with: dataStr)
        Debug.shared.println("当前inv地址4: \(stateINV.invSwitch)")
        self.stateBMSMaster.update(with: dataStr)
        self.stateBMSSlave.update(with: dataStr)
        self.stateMppt.update(with: dataStr)
    }
    
    //主动发请求，获取设备状态数据（远程设备或者直连设备会调用，定时5秒调用一次）
    @discardableResult
    func requestStatus(forceReqOfflineDev: Bool=false, upgradeResult: (()->())? = nil, completion: ((_ res: Bool) -> Void)?=nil) -> Void? {
        if isRemoteDevice { //远程设备
            /**
             远程离线设备就不用再发请求查询设备状态了
             forceReqOfflineDev是强制查询离线设备状态，DeviceViewController中点击设备时，
             强制查询设备状态
             */
            //if !getConnected() && !forceReqOfflineDev { return nil }
            
//            guard let token = Globals.httpToken else { return nil }
//            let header: HTTPHeaders = ["Authorization": "\(token)"]
//            let params = [ "sn": getSN()]
//
//            let req:DataRequest = AF.request(Constants.GET_API_URL(type: .getDeviceData), method: .get, parameters: params, encoding: URLEncoding.default, headers: header, requestModifier: {$0.timeoutInterval=10}).responseString { [weak self] (response) in
//                if response.error == nil {
//                    if let strDat = response.value {
//                        if strDat.contains("\"code\":0") { //成功收到数据
//                            Debug.shared.println("收到远程设备数据了：\(self?.getDeviceName() ?? "Noname")")
//
//                            guard let json = try? JSON(data: strDat.data(using: String.Encoding.utf8)!) else {
//                                return
//                            }
//
//                            self?.getDeviceModel().connected = json["data"]["connected"].boolValue
//                            //如果设备在线或者强制查询
//                            guard (self?.getConnected() ?? false) || forceReqOfflineDev else {
//                                return
//                            }
//                            self?.getUpgradeResult(json: json)
//                            self?.parseRemoteDeviceData(dataStr: strDat, dataJson: json)
//                            //stat=1表示超时
//                            NotificationCenter.default.post(name:  NSNotification.Name(rawValue: Constants.NOTIF_NAME_DEVICE_STAT_CHANGED), object: nil, userInfo: ["stat":"0", "msg":"OK"])
//                            completion?(true)
//                            return
//                        } else {
//                            //收到数据失败？
//                        }
//                    } else {
//                        //return nil string
//                    }
//                }
//
//                NotificationCenter.default.post(name:  NSNotification.Name(rawValue: Constants.NOTIF_NAME_DEVICE_STAT_CHANGED), object: nil, userInfo: ["stat":"1", "msg":"\(response.error?.localizedDescription ?? "Unknown network error")"])
//                completion?(false)
//            }
//            return req
        } else { //TCP连接设备(AP直连的设备，TCP连接的不进入这里)，发TCP请求获取数据
            onCommandSend()
        }
        return nil
    }
    
    @objc private func onCommandSend() {
      
        let packPD = EFProtocol.shareInstance.generateCommand(type: .getStatus)
        tcpConn?.tcpSend(buff: packPD)
            //Debug.shared.println("更新模块：请求PD")

        let packInv = EFProtocol.shareInstance.generateCommand(type: .getInvStatus)
        tcpConn?.tcpSend(buff: packInv)
            //Debug.shared.println("更新模块：请求inv")

        let packBmsS = EFProtocol.shareInstance.generateCommand(type: .getBMSSlaveStatus)
        tcpConn?.tcpSend(buff: packBmsS)
            //Debug.shared.println("更新模块：请求bms_s")

        let packBmsM = EFProtocol.shareInstance.generateCommand(type: .getBMSMasterStatus)
        tcpConn?.tcpSend(buff: packBmsM)
            //Debug.shared.println("更新模块：请求bms_m")
        let packMppt = EFProtocol.shareInstance.generateCommand(type: .getMpptStatus)
        tcpConn?.tcpSend(buff: packMppt)
    }
    
    func onGetStatCommandSend() {

    }
    
    func closeTcpConnect() {
        tcpConn?.disconnect()
        tcpConn = nil
        EFProtocol.shareInstance.cleanBuffer() //清除缓存，防止留有未解析的包，让sn的包下次无法及时解析
    }
    
    private func onSendGetSNCmd() {
        Debug.shared.println("设备SN命令：sn= 发送getSN命令")
        let pack = EFProtocol.shareInstance.generateCommand(type: .getSN, product: (self.product ?? 0xFFFF))
        Debug.shared.printHex(data: pack)
        Debug.shared.println("~~~~~~~~~~~")
        if let conn = tcpConn {
            conn.tcpSend(buff: pack) //为了获取product值
        } else {
            Debug.shared.println("Tcp链接没有了？")
        }
    }
    //获取升级结果数据
    func getUpgradeResult(json: JSON) {
        self.upgradeStartTime = json["data"]["upgradeResult"]["startTime"].string
        self.upgradeEndTime = json["data"]["upgradeResult"]["endTime"].string
        self.pd_curVer =  json["data"]["upgradeResult"]["pd"]["curVer"].string
        self.pd_newVer =  json["data"]["upgradeResult"]["pd"]["newVer"].string
        self.pd_result = json["data"]["upgradeResult"]["pd"]["result"].int
        self.inv_curVer = json["data"]["upgradeResult"]["inv"]["curVer"].string
        self.inv_newVer = json["data"]["upgradeResult"]["inv"]["newVer"].string
        self.inv_result = json["data"]["upgradeResult"]["inv"]["result"].int
        self.bms_m_curVer = json["data"]["upgradeResult"]["bms_m"]["curVer"].string
        self.bms_m_newVer = json["data"]["upgradeResult"]["bms_m"]["newVer"].string
        self.bms_m_result = json["data"]["upgradeResult"]["bms_m"]["result"].int
        self.bms_s_curVer = json["data"]["upgradeResult"]["bms_s"]["curVer"].string
        self.bms_s_newVer = json["data"]["upgradeResult"]["bms_s"]["newVer"].string
        self.bms_s_result = json["data"]["upgradeResult"]["bms_s"]["result"].int
        self.mppt_curVer = json["data"]["upgradeResult"]["mppt"]["curVer"].string
        self.mppt_newVer = json["data"]["upgradeResult"]["mppt"]["newVer"].string
        self.mppt_result = json["data"]["upgradeResult"]["mppt"]["result"].int
    }
    private func whichPart(models: [SystemParamsModel]) -> SysParamsType {
        for mod in models {
            if mod.name.lowercased().contains("bus") || mod.name.lowercased().contains("dsg") {
                return .inv
            }
            if mod.name.lowercased().contains("allow") || mod.name.lowercased().contains("plug") {
                return .bmsMaster
            }
            if mod.name.lowercased().contains("car") || mod.name.lowercased().contains("typec") {
                return .pd
            }
        }
        return .bmsSlave
    }
    
    func isAllModInit() -> Bool {
        
        if isExsitModule {
            return !isModuleInit.contains(false)
        }
        
        return isModuleInit[0] && isModuleInit[1] && isModuleInit[3]
    }
}

//MARK: - R600MAX Method
extension BaseDevice {
    
    //下面是Module相关功能，只有MAX，PRO才有，LITE没有
      func setMoodLight(state: UInt8, success: (() -> Void)?, failed: ((String) -> Void)?) {
          if isRemoteDevice {
              let params = [
                  "sn": getSN(),
                  "cfg": ["id": Int(EFProtocol.CMD_ID_AMBIENT_LIGHT), "mode": Int(state)]
              ] as [String : Any]
              Debug.shared.println("设置mood::\(params)")
              remoteHTTPRequest(params: params, success: success, failed: failed)
          } else {
              let package = EFProtocol.shareInstance.generateCommand(type: .setMoodLight, cmdData: [state, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF], product: (self.product ?? 0xFFFF))
              getTcpConnection()?.tcpSend(buff: package)
          }
      }
      
      func setLEDColor(index: Int, success: (() -> Void)?, failed: ((String) -> Void)?) {
          if isRemoteDevice {
              let params = [
                  "sn": getSN(),
                  "cfg": ["id": Int(EFProtocol.CMD_ID_AMBIENT_LIGHT), "color": Int(Constants.COLOR_HEX[index])]
              ] as [String : Any]
              Debug.shared.println("设置color::\(params)")
            remoteHTTPRequest(params: params, success: success, failed: failed)
          } else {
              let package = EFProtocol.shareInstance.generateCommand(type: .setLEDColor, cmdData: [0xFF, 0xFF, UInt8(Constants.COLOR_HEX[index] & 0x000000FF), UInt8((Constants.COLOR_HEX[index] & 0x0000FF00) >> 8), UInt8((Constants.COLOR_HEX[index] & 0x00FF0000) >> 16), 0x0, 0xFF], product: (self.product ?? 0xFFFF))
              getTcpConnection()?.tcpSend(buff: package)
          }
      }
      
      func setBrightness(value: UInt8, success: (() -> Void)?, failed: ((String) -> Void)?) {
          if isRemoteDevice {
              let params = [
                  "sn": getSN(),
                  "cfg": ["id": Int(EFProtocol.CMD_ID_AMBIENT_LIGHT), "brightness": Int(value)]
              ] as [String : Any]
              Debug.shared.println("设置brightness::\(params)")
            remoteHTTPRequest(params: params, success: success, failed: failed)
          } else {
              let package = EFProtocol.shareInstance.generateCommand(type: .setBrightness, cmdData: [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, value], product: (self.product ?? 0xFFFF))
              getTcpConnection()?.tcpSend(buff: package)
          }
      }
      
      func setLEDMode(presetMode: UInt8, success: (() -> Void)?, failed: ((String) -> Void)?) {
          if isRemoteDevice {
              let params = [
                  "sn": getSN(),
                  "cfg": ["id": Int(EFProtocol.CMD_ID_AMBIENT_LIGHT), "animateMode": Int(presetMode)]
              ] as [String : Any]
              Debug.shared.println("设置LED Mode过程::\(params)")
            remoteHTTPRequest(params: params, success: success, failed: failed)
          } else {
              let package = EFProtocol.shareInstance.generateCommand(type: .setLEDMode, cmdData: [0xFF, presetMode, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF], product: (self.product ?? 0xFFFF))
              getTcpConnection()?.tcpSend(buff: package)
          }
      }
}

//MARK: - R600PROKit Method
extension BaseDevice {
    func setBattery(type: UInt8, maxVol: Int?=nil, minVol: Int?=nil, maxCap: Int?=nil, failed: ((String) -> Void)?) { //battery=1
           if isRemoteDevice {
               var cfgParams = [String: Any]()
               cfgParams["id"] = Int(EFProtocol.CMD_ID_SET_BATTERY)
               cfgParams["batteryType"] = type
               if let maxV = maxVol { cfgParams["maxVoltage"] = maxV }
               if let minV = minVol { cfgParams["minVoltage"] = minV }
               if let maxC = maxCap { cfgParams["maxCapacity"] = maxC }
               let params = [
                   "sn": getSN(),
                   "cfg": cfgParams
               ] as [String : Any]
               Debug.shared.println("设置battery过程::\(params)")
            remoteHTTPRequest(params: params, success: nil, failed: failed)
           } else {
               //let package = EFProtocol.shareInstance.generateCommand(type: .setMPPT, cmdData: [UInt8(mode)], product: (self.product ?? 0xFFFF))
               //getTcpConnection()?.tcpSend(buff: package)
           }
       }
}
//MARK: - Remote设备HTTP请求
extension BaseDevice {
    private func remoteHTTPRequest(params: [String: Any], success: (() -> Void)?, failed: ((String) -> Void)?) {
//        NetworkTools.shareInstance.request(Constants.GET_API_URL(type: .configDevice), method: .post, parameters: params, encoding: JSONEncoding.default) {[weak self]  (response) in
//            var errMsg = self?.networkError ?? ""
//            if response.error == nil {
//                if let strDat = response.value {
//                    Debug.shared.println("设置out Freq:: \(strDat)")
//                    do {
//                        let jsonDat = try JSON(data: strDat.data(using: String.Encoding.utf8)!)
//                        if strDat.contains("code") {
//                            let code = jsonDat["code"].int
//                            if code == 0 {
//                                success?()
//                                return
//                            } else {
//                                errMsg = "code is not 0"
//                                if let err = jsonDat["message"].string { errMsg = err }
//                            }
//                        }
//                    } catch {
//                        Debug.shared.println("json parse exception")
//                        errMsg = "json parse exception"
//                    }
//                } else {
//                    //return nil string
//                    errMsg = "HTTP echo nil string"
//                }
//            }
//            Debug.shared.println("设置out Freq失败: \(String(describing: response.error)), \(errMsg)")
//            failed?(errMsg)
//        }
    }
}
//MARK: - tcp delegate
extension BaseDevice: TcpClientDelegate {
    func tcpReceivedRawData(devId: String, data: Data) {
        let bytes = [UInt8](data)
        Debug.shared.println("设备连接：收到数据 AC的值：")
        Debug.shared.printHex(data: bytes, tag: "数据：")
        if let package = EFProtocol.shareInstance.decode(data: bytes) { //decode package
            parseTCP(package: package)
        } /*else {
            Debug.shared.println("疑似错误包", tag: "batteryVal")
            EFProtocol.shareInstance.cleanBuffer()
        }*/
        
        //buff里面是否有剩余的一个或多个包需要再继续解析
        while let package = EFProtocol.shareInstance.decode(data: []) {
            parseTCP(package: package)
            testDecodeCount += 1
            Debug.shared.println("testDecodeCount=\(testDecodeCount)", tag: "batteryVal")
        }
        testDecodeCount = 0
    }
    
    func tcpReceivedData(devId: String, recvData: String) {
        //do nothing
    }
    
    func tcpDidConnected(devId: String) {
        Debug.shared.println("设备连接：连上设备")
        onSendGetSNCmd()
        //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+4) { [weak self] in
        //    self?.getSNFromTcp?()
        //}
    }
    
    func tcpDidDisconnected(devId: String) {
        Debug.shared.println("设备连接：设备断开")
        //tcpDisconnectHandler?()
    }
    
    func tcpSendHook(id: String, content: String) {
        
    }
    
}
