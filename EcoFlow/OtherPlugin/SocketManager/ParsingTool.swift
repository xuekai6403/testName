//
//  ParsingTool.swift
//  EcoFlow
//
//  Created by Curry on 2021/3/18.
//

import Foundation
@objcMembers
class ParsingTool:NSObject{
    var lcdStandbyTime:UInt16 = 0
    
    var statePD:EFHeartbeatPD = EFHeartbeatPD() //PD面板
    var stateINV = EFHeartbeatInv() //INV逆变器
    public var stateBMSMaster = EFHeartbeatBMS() //BMS电池包
    public var stateBMSSlave = EFHeartbeatBMSSlave()
    public let stateMppt = EFHeartbeatMppt() //MPPT太阳能板
    
    private let PROTOCOL_V2:UInt8 = 0x02
    private let FRAME_SIG:UInt8 = 0xAA
    private let NEED_ACK:UInt8 = 0x01
    private let IS_ACK:UInt8 = 0x0
    private let CHECK_TYPE:UInt8 = 0x03
    private let SERV_ADDR:UInt8 = 0x20
    private let BLUESERV_ADDR:UInt8 = 0x21
    
    private let CMD_SET_COMMON:UInt8 = 0x01
    private let CMD_ID_SYS_RESET:UInt8 = 0x03
    
    private let CMD_SET_IOT_SERVER:UInt8 = 0x20
    private let CMD_ID_GET_SN:UInt8 = 0x41
    private let CMD_ID_STATUS_PUSH:UInt8 = 0x02
    private let CMD_ID_LED_CONFIG:UInt8 = 0x23
    private let CMD_ID_SYS_EVENT_PUSH:UInt8 = 0x20
    private let CMD_ID_AMBIENT_LIGHT:UInt8 = 0x61
    private let CMD_ID_UPS_CONFIG:UInt8 = 0x31
    private let CMD_ID_SET_BEEP:UInt8 = 0x26
    private let CMD_ID_AC_OUT:UInt8 = 0x42
    private let CMD_ID_DC_CONFIG:UInt8 = 0x22
    private let CMD_ID_STAND_BY:UInt8 = 0x21
    private let CMD_ID_WORK_MODE:UInt8 = 0x41
    private let CMD_ID_GET_LCD_TIME:UInt8 = 0x28
    private let CMD_ID_GET_MPPT_MODE:UInt8 = 0x44
    private let CMD_ID_SET_LCD_TIME:UInt8 = 0x27
    private let CMD_ID_SET_MPPT_MODE:UInt8 = 0x43
    private let CMD_ID_SET_BATTERY:UInt8 = 0x62
    private let CMD_ID_GET_SYS_PARAMS:UInt8 = 0x01
    private let CMD_ID_GET_SYS_LOGS:UInt8 = 0x24
    
    private let ADDR_PD:UInt8 = 0x2
    private let ADDR_BMS_M:UInt8 = 0x3
    private let ADDR_BMS_S:UInt8 = 0x6
    private let ADDR_INV:UInt8 = 0x4
    private let ADDR_MPPT:UInt8 = 0x5
    private let ADDR_BLUE:UInt8 = 0x32
    
    private let HEADER_SIZE:Int = 16
    private let DEVICE_SN_LEN:Int = 16
    
    private var buffer = [UInt8]()
    private var lock: Int = 0
    
    static let shared = ParsingTool()
    
    private override init() {
        
    }

    @objc open class func sharedInstance() -> ParsingTool
    {
        return self.shared
    }
    @objc public func parsingData(data: Data) {
        let bytes = [UInt8](data)
        if let package = decode(data: bytes) {
            parseTCP(package: package)
        }
    }
    
    // MARK: - 返回EFFrame
    func decode(data: [UInt8]) -> EFFrame? {
        objc_sync_enter(lock)
        let package = EFFrame()
        var foundHeaderTag = false
        for d in data { buffer.append(d) }
        for i in 0 ..< buffer.count {
            guard i+4 < buffer.count else {
                
                    //删除掉i之前的没用数据
                    var temp = [UInt8]()
                    for item in i..<buffer.count {
                        temp.append(buffer[item])
                    }
                    buffer.removeAll()
                    buffer = temp
                    
                
                objc_sync_exit(lock)
                return nil
            } //包括hdr_chk总共5字节的头校验
            if buffer[i] == FRAME_SIG {
                Debug.shared.println("debug: global buff count:\(buffer.count)", tag: "AC的值")
                foundHeaderTag = true
                if buffer[i+4] == CRCCheck.shareInstance.checkCRC8(buf: [buffer[i], buffer[i+1], buffer[i+2], buffer[i+3]]) {
                    //找到了header
                    guard i+15 < buffer.count else { //不完整包，等待下次接收
                        objc_sync_exit(lock)
                        return nil
                    }
                    package.sig = buffer[i]
                    package.version = buffer[i+1]
                    package.dataLen = UInt16(Int(buffer[i+2])+Int(buffer[i+3])*256)
                    package.hdrChk = buffer[i+4]
                    package.args = buffer[i+5]
                    package.frameSeq = UInt32(buffer[i+6])
                    package.frameSeq += (UInt32(buffer[i+7]) << 8)
                    package.frameSeq += (UInt32(buffer[i+8]) << 16)
                    package.frameSeq += (UInt32(buffer[i+9]) << 24)
                    package.product = UInt16(buffer[i+10])
                    package.product += (UInt16(buffer[i+11]) << 8)
                    package.srcAddr = buffer[i+12]
                    package.destAddr = buffer[i+13]
                    package.cmdSet = buffer[i+14]
                    package.cmdID = buffer[i+15]
                    
                    if package.version == PROTOCOL_V2 { //version check
                        let packLen: Int = HEADER_SIZE+Int(package.dataLen)+2 //2是CRC16长度
                        let remainLen: Int = buffer.count-i-2 //减去2是减去最后CRC16长度
                        if Int(package.dataLen) > remainLen {
                            objc_sync_exit(lock)
                            return nil //不是一个完整的包，等下次decode
                        } else {
                            var packBuff = [UInt8]()
                            for j in i ..< i+packLen {
                                guard j < buffer.count else {
                                    objc_sync_exit(lock)
                                    return nil //不是一个完整的包，等下次decode
                                }
                                packBuff.append(buffer[j])
                            }
                            if verifyFrame(data: packBuff) { //frame CRC16，得到一个正确包
                                //Debug.shared.println("EFProtocol.buffer.count=\(EFProtocol.buffer.count)")
                                for j in i+HEADER_SIZE ..< i+HEADER_SIZE+Int(package.dataLen) {
                                    if j < buffer.count {
                                        package.payload.append(buffer[j])
                                    }
                                }
                                //删除这个包
                                var tempBuf = [UInt8]()
                                //Debug.shared.println("保存数据 \(i+packLen) to \(EFProtocol.buffer.count)")
                                //Debug.shared.println("保存数据 删除bytes：0~\(i+packLen-1)")
                                if i+packLen < buffer.count {
                                    for j in i+packLen ..< buffer.count {
                                        tempBuf.append(buffer[j])
                                    }
                                }
                                buffer.removeAll()
                                //Debug.shared.println("保存数据: remove \(EFProtocol.buffer.count)")
                                for d in tempBuf { buffer.append(d) }
                                //Debug.shared.println("保存数据: save \(EFProtocol.buffer.count)")
                                break
                            }
                        }
                    }
                }
            }
        }
        objc_sync_exit(lock)
        if !foundHeaderTag { //没找到0xAA标记
            return nil
        }
        return package
    }

    func parseTCP(package: EFFrame) {
        let payload = EFProtocol.shareInstance.decrypt(frame: package)

        if package.cmdSet == CMD_SET_COMMON {
            //通用命令集
            switch package.cmdID {
            case EFProtocol.CMD_ID_GET_SN: //获取SN
                let snModel = DeviceSN(data: payload)
                break
            default:
                break
            }
        }else if package.cmdSet == EFProtocol.CMD_SET_IOT_SERVER {
            //SERVER命令集
            switch package.cmdID {
            case EFProtocol.CMD_ID_STATUS_PUSH: //状态
                if let type = EFHeartbeatType(rawValue: package.srcAddr) {
                    switch type {
                    case .pd:
                        statePD.updateArray(with: payload)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HeartBeatNotification"), object: nil)
                        break
                    case .bmsMaster:
                        Debug.shared.println("更新模块：bms_m  电池上限：\(stateBMSMaster.maxChgSoc)", tag: "batteryVal")
                        stateBMSMaster.update(with: payload)
                        break
                    case .bmsSlave:
                        Debug.shared.println("更新模块：bms_s")
                        stateBMSSlave.update(with: payload)
                        break
                    case .inv:
                        stateINV.update(with: payload)
                        Debug.shared.println("更新模块：Inv, cfgOutFreq:\(stateINV.cfgOutFreq), AC的值：\(stateINV.invSwitch)", tag: "decoded")
                        break
                    case .mppt:
                        stateMppt.update(with: payload)
                        break
                    }
                }
                break
            case CMD_ID_SYS_EVENT_PUSH: //系统消息推送
//                Debug.shared.println("设备连接：\(getDeviceName())收到event命令 CMD_ID_SYS_EVENT_PUSH")
//                Debug.shared.printHex(data: payload, tag: getDeviceName())
                break
            case CMD_ID_GET_LCD_TIME: //获取无操作息屏时间
                guard package.payload.count >= 3 else { break }
                self.lcdStandbyTime = UInt16(package.payload[1])
                self.lcdStandbyTime += (UInt16(package.payload[2]) << 8)
                Debug.shared.println("获取LCD standby命令0:\(package.cmdID), \(payload.count), :\(payload[0]), \(payload[1]), \(payload[2])")
                guard payload.count >= 3 else { break }
                let t:UInt16 = UInt16(payload[1])+(UInt16(payload[2])<<8)
                NotificationCenter.default.post(name:  NSNotification.Name(rawValue: Constants.NOTIF_NAME_REFRESH_LCD_MPPT), object: nil, userInfo: ["time": t])
                break
            case EFProtocol.CMD_ID_GET_SYS_PARAMS: //获取系统参数
                Debug.shared.println("sysParams返回命令:\(package.cmdID)")
                Debug.shared.printHex(data: payload, tag: "sysParams返回命令")
                let paramsModels = parseSystemParams(data: payload)
                break
            case EFProtocol.CMD_ID_GET_SYS_LOGS: //获取最近的日志记录
                Debug.shared.println("返回日志数据: \(package.cmdID)")
                Debug.shared.printHex(data: payload, tag: "日志数据")
                let paramsModels = parseDeviceLogs(data: payload)
                break
            case EFProtocol.CMD_ID_GET_MPPT_MODE: //获取太阳能面板模式
                Debug.shared.println("获取MPPT数据: \(package.cmdID)")
                Debug.shared.printHex(data: payload, tag: "MPPT数据:")
                guard payload.count > 1 else { break }
                let model = Int(payload[1])
                break
            case EFProtocol.CMD_ID_SYS_RESET:
                
                break
            default:
                Debug.shared.println("未知TCP返回命令:\(package.cmdID)")
                break
            }
        }
    }
    
    private func verifyFrame(data: [UInt8]) -> Bool {
        let len = data.count
        guard len >= 3 else { return false }
        let chkNum:UInt16 = UInt16(Int(data[len-2])+Int(data[len-1])*256)
        var tempBuf = [UInt8]()
        for i in 0 ..< data.count-2 { tempBuf.append(data[i]) }
        if chkNum == CRCCheck.shareInstance.checkCRC16(buf: tempBuf) {
            return true
        }
        
        return false
    }
    
    private func parseSystemParams(data: [UInt8]) -> [SystemParamsModel] {
        var res = [SystemParamsModel]()
        guard data.count > 2 else {
            return res
        }
        let num:UInt16 = UInt16(data[0]) + (UInt16(data[1]) << 8)
        var index:Int = 2 //index指向name_length
        for _ in 0 ..< num {
            let nameLen:Int = Int(data[index])
            guard index+1+4+nameLen < data.count else {
                return res
            }
            var array = [UInt8]()
            for j in index+1+4+1 ..< index+1+4+nameLen+1 { array.append(data[j]) }
            let name: String = String(bytes: array, encoding: .utf8) ?? "Unknown"
            var typeName = "Unknown"
            var val:Any = 0
            switch data[index+1] {
            case 1:
                typeName = "uint8"
                val = UInt32(data[index+2]) + (UInt32(data[index+3])<<8) + (UInt32(data[index+4])<<16) + (UInt32(data[index+5])<<24)
                break
            case 2:
                typeName = "int8"
                //val = Int8(data[index+2])
                val = UInt32(data[index+2]) + (UInt32(data[index+3])<<8) + (UInt32(data[index+4])<<16) + (UInt32(data[index+5])<<24)
                break
            case 3:
                typeName = "uint16"
                //val = UInt16(data[index+2]) + (UInt16(data[index+3])<<8)
                val = UInt32(data[index+2]) + (UInt32(data[index+3])<<8) + (UInt32(data[index+4])<<16) + (UInt32(data[index+5])<<24)
                break
            case 4:
                typeName = "int16"
                //val = Int16(UInt16(data[index+2]) + (UInt16(data[index+3])<<8))
                val = UInt32(data[index+2]) + (UInt32(data[index+3])<<8) + (UInt32(data[index+4])<<16) + (UInt32(data[index+5])<<24)
                break
            case 5:
                typeName = "uint32"
                val = UInt32(data[index+2]) + (UInt32(data[index+3])<<8) + (UInt32(data[index+4])<<16) + (UInt32(data[index+5])<<24)
                break
            case 6:
                typeName = "int32"
                //val = Int(UInt32(data[index+2]) + (UInt32(data[index+3])<<8) + (UInt32(data[index+4])<<16) + (UInt32(data[index+5])<<24))
                val = UInt32(data[index+2]) + (UInt32(data[index+3])<<8) + (UInt32(data[index+4])<<16) + (UInt32(data[index+5])<<24)
                break
            case 8:
                typeName = "float"
                var f:Float = 0.0
                memcpy(&f, [data[index+2],data[index+3],data[index+4],data[index+5]], 4)
                val = f
                break
            default:
                Debug.shared.println("sysParams未知数据类型")
                break
            }
            let model = SystemParamsModel(name: name, type: typeName, value: val)
            res.append(model)
            index = index+5+Int(data[index])+1
        }
        return res
    }
    
    private func parseDeviceLogs(data: [UInt8]) -> [DeviceEventModel] {
        var res = [DeviceEventModel]()
        guard data.count > 2 else {
            return res
        }
        let packageLen = 10
        let num:UInt16 = UInt16(data[0]) + (UInt16(data[1]) << 8)
        var index:Int = 2
        for _ in 0 ..< num {
            let timestamp:UInt32 = UInt32(data[index])+(UInt32(data[index+1])<<8)+(UInt32(data[index+2])<<16)+(UInt32(data[index+3])<<24)
            let level = data[index+4]
            //TCP返回结构中level与msg_type合并作为msgId(UInt16)，level在低8位
            let msgId:UInt16 = UInt16(level)+(UInt16(data[index+5])<<8)
            let errCode:UInt32 = UInt32(data[index+6])+(UInt32(data[index+7])<<8)+(UInt32(data[index+8])<<16)+(UInt32(data[index+9])<<24)
            let model = DeviceEventModel(with: NSDictionary(dictionaryLiteral: ("errCode", errCode), ("timestamp", timestamp), ("msgId", msgId)))
            model.eventType = 1
            res.append(model)
            index += packageLen
        }
        return res
    }
}
