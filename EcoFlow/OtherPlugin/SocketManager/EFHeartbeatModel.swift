//
//  HeartbeatModel.swift
//  EcoFlow
//
//  Created by apple on 2020/5/28.
//  Copyright © 2020 wangwei. All rights reserved.
//

import Foundation
import SwiftyJSON

enum EFHeartbeatType: UInt8 {
    case pd = 0x2
    case bmsMaster = 0x3
    case inv = 0x4
    case bmsSlave = 0x6
    case mppt = 0x5
}

//MARK: - 心跳包类型
@objcMembers
class EFHeartbeatPD:NSObject{ //heartbeat_pd_t, ADDR_PD=2, 78bytes  系统待机时间 提示音
    static let LENGTH:Int = 78
    static let LENGTH_BEEP:Int = 79 //新增加beep字段，一个UInt8
    static let MR310_LENGTH: Int = 80 //MR310
    
    var model:UInt8 = 0
    var errorCode:UInt32 = 0
    var sysVersion:UInt32 = 0
    var socSum:UInt8 = 0

    var wattsOutSum:UInt16 = 0
    var wattsInSum:UInt16 = 0
    var remainTime:UInt32 = 0
    var carSwitch:UInt8 = 0
    var ledState:UInt8 = 0
    var beep:UInt8 = 0

    var typecWatts:UInt8 = 0
    var usb1Watts:UInt8 = 0
    var usb2Watts:UInt8 = 0
    var usb3Watts:UInt8 = 0

    var carWatts:UInt8 = 0
    var ledWatts:UInt8 = 0
    var typecTemp:Int8 = 0
    var carTemp:Int8 = 0

    var standbyMode:UInt16 = 0

    var chgPowerDC:UInt32 = 0
    var chgSunPower:UInt32 = 0
    var chgPowerAC:UInt32 = 0
    var dsgPowerDC:UInt32 = 0
    var dsgPowerAC:UInt32 = 0

    var usbUsedTime:UInt32 = 0
    var usbqcUsedTime:UInt32 = 0
    var typecUsedTime:UInt32 = 0
    var carUsedTime:UInt32 = 0
    var invUsedTime:UInt32 = 0
    var dcInUsedTime:UInt32 = 0
    var mpptUsedTime:UInt32 = 0
    
    //MR310新增
    
    var qc_usb1Watts:UInt8 = 0   //qc_usb1输出功率w
    var qc_usb2Watts:UInt8 = 0   //qc_usb2输出功率w                                                   6
    var typec1Watts:UInt8 = 0    //typec1输出功率w
    var typec2Watts:UInt8 = 0    //typec2输出功率w
    
    var typec1Temp:UInt8 = 0     //typec1温度
    var typec2Temp:UInt8 = 0     //typec2温度                                                        2
    
    var lcdOff:UInt16 = 0        //LCD息屏时间 0:永不息屏
    
    override init() {
        
    }
    
    init(array: [UInt8]) {
        super.init()
        updateArray(with: array)
    }
    
    func updateArray(with array: [UInt8]) {
        guard (array.count == EFHeartbeatPD.LENGTH || array.count == EFHeartbeatPD.LENGTH_BEEP || array.count == EFHeartbeatPD.MR310_LENGTH) else { return }
        if array.count == EFHeartbeatPD.LENGTH || array.count == EFHeartbeatPD.LENGTH_BEEP {
            let arrayOffset:Int = (array.count == EFHeartbeatPD.LENGTH_BEEP ? 1 : 0)
            
            self.model = array[0]
            self.errorCode = UInt32(array[1])
            self.errorCode += (UInt32(array[2]) << 8)
            self.errorCode += (UInt32(array[3]) << 16)
            self.errorCode += (UInt32(array[4]) << 24)
            self.sysVersion = UInt32(array[5])
            self.sysVersion += (UInt32(array[6]) << 8)
            self.sysVersion += (UInt32(array[7]) << 16)
            self.sysVersion += (UInt32(array[8]) << 24)
            self.socSum = array[9]
            self.wattsOutSum = UInt16(array[10])
            self.wattsOutSum += (UInt16(array[11]) << 8)
            self.wattsInSum = UInt16(array[12])
            self.wattsInSum += (UInt16(array[13]) << 8)
            self.remainTime = UInt32(array[14])
            self.remainTime += (UInt32(array[15]) << 8)
            self.remainTime += (UInt32(array[16]) << 16)
            self.remainTime += (UInt32(array[17]) << 24)
            self.carSwitch = array[18]
            self.ledState = array[19]
            
            if array.count == EFHeartbeatPD.LENGTH_BEEP {
                self.beep = array[20]
            }
            self.typecWatts = array[20+arrayOffset]
            self.usb1Watts = array[21+arrayOffset]
            self.usb2Watts = array[22+arrayOffset]
            self.usb3Watts = array[23+arrayOffset]
            self.carWatts = array[24+arrayOffset]
            self.ledWatts = array[25+arrayOffset]
            self.typecTemp = Int8(array[26+arrayOffset])
            self.carTemp = Int8(array[27+arrayOffset])
            self.standbyMode = UInt16(array[28+arrayOffset])
            self.standbyMode += (UInt16(array[29+arrayOffset]) << 8)
            self.chgPowerDC = UInt32(array[30+arrayOffset])
            self.chgPowerDC += (UInt32(array[31+arrayOffset]) << 8)
            self.chgPowerDC += (UInt32(array[32+arrayOffset]) << 16)
            self.chgPowerDC += (UInt32(array[33+arrayOffset]) << 24)
            self.chgSunPower = UInt32(array[34+arrayOffset])
            self.chgSunPower += (UInt32(array[35+arrayOffset]) << 8)
            self.chgSunPower += (UInt32(array[36+arrayOffset]) << 16)
            self.chgSunPower += (UInt32(array[37+arrayOffset]) << 24)
            self.chgPowerAC = UInt32(array[38+arrayOffset])
            self.chgPowerAC += (UInt32(array[39+arrayOffset]) << 8)
            self.chgPowerAC += (UInt32(array[40+arrayOffset]) << 16)
            self.chgPowerAC += (UInt32(array[41+arrayOffset]) << 24)
            self.dsgPowerDC = UInt32(array[42+arrayOffset])
            self.dsgPowerDC += (UInt32(array[43+arrayOffset]) << 8)
            self.dsgPowerDC += (UInt32(array[44+arrayOffset]) << 16)
            self.dsgPowerDC += (UInt32(array[45+arrayOffset]) << 24)
            self.dsgPowerAC = UInt32(array[46+arrayOffset])
            self.dsgPowerAC += (UInt32(array[47+arrayOffset]) << 8)
            self.dsgPowerAC += (UInt32(array[48+arrayOffset]) << 16)
            self.dsgPowerAC += (UInt32(array[49+arrayOffset]) << 24)
            self.usbUsedTime = UInt32(array[50+arrayOffset])
            self.usbUsedTime += (UInt32(array[51+arrayOffset]) << 8)
            self.usbUsedTime += (UInt32(array[52+arrayOffset]) << 16)
            self.usbUsedTime += (UInt32(array[53+arrayOffset]) << 24)
            self.usbqcUsedTime = UInt32(array[54+arrayOffset])
            self.usbqcUsedTime += (UInt32(array[55+arrayOffset]) << 8)
            self.usbqcUsedTime += (UInt32(array[56+arrayOffset]) << 16)
            self.usbqcUsedTime += (UInt32(array[57+arrayOffset]) << 24)
            self.typecUsedTime = UInt32(array[58+arrayOffset])
            self.typecUsedTime += (UInt32(array[59+arrayOffset]) << 8)
            self.typecUsedTime += (UInt32(array[60+arrayOffset]) << 16)
            self.typecUsedTime += (UInt32(array[61+arrayOffset]) << 24)
            self.carUsedTime = UInt32(array[62+arrayOffset])
            self.carUsedTime += (UInt32(array[63+arrayOffset]) << 8)
            self.carUsedTime += (UInt32(array[64+arrayOffset]) << 16)
            self.carUsedTime += (UInt32(array[65+arrayOffset]) << 24)
            self.invUsedTime = UInt32(array[66+arrayOffset])
            self.invUsedTime += (UInt32(array[67+arrayOffset]) << 8)
            self.invUsedTime += (UInt32(array[68+arrayOffset]) << 16)
            self.invUsedTime += (UInt32(array[69+arrayOffset]) << 24)
            self.dcInUsedTime = UInt32(array[70+arrayOffset])
            self.dcInUsedTime += (UInt32(array[71+arrayOffset]) << 8)
            self.dcInUsedTime += (UInt32(array[72+arrayOffset]) << 16)
            self.dcInUsedTime += (UInt32(array[73+arrayOffset]) << 24)
            self.mpptUsedTime = UInt32(array[74+arrayOffset])
            self.mpptUsedTime += (UInt32(array[75+arrayOffset]) << 8)
            self.mpptUsedTime += (UInt32(array[76+arrayOffset]) << 16)
            self.mpptUsedTime += (UInt32(array[77+arrayOffset]) << 24)
        }
        
        if array.count == EFHeartbeatPD.MR310_LENGTH {//MR310设备
            self.model = array[0]
            self.errorCode = UInt32(array[1])
            self.errorCode += (UInt32(array[2]) << 8)
            self.errorCode += (UInt32(array[3]) << 16)
            self.errorCode += (UInt32(array[4]) << 24)
            self.sysVersion = UInt32(array[5])
            self.sysVersion += (UInt32(array[6]) << 8)
            self.sysVersion += (UInt32(array[7]) << 16)
            self.sysVersion += (UInt32(array[8]) << 24)
            self.socSum = array[9]
            self.wattsOutSum = UInt16(array[10])
            self.wattsOutSum += (UInt16(array[11]) << 8)
            self.wattsInSum = UInt16(array[12])
            self.wattsInSum += (UInt16(array[13]) << 8)
            self.remainTime = UInt32(array[14])
            self.remainTime += (UInt32(array[15]) << 8)
            self.remainTime += (UInt32(array[16]) << 16)
            self.remainTime += (UInt32(array[17]) << 24)
            self.beep  = array[18]
            self.carSwitch = array[19]
            
            

        
            self.usb1Watts = array[20]
            self.usb2Watts = array[21]
            self.qc_usb1Watts = array[22]
            self.qc_usb2Watts = array[23]
            self.typec1Watts = array[24]
            self.typec2Watts = array[25]
            
            self.typec1Temp = array[26]
            self.typec2Temp = array[27]
            
            self.standbyMode = UInt16(array[28])
            self.standbyMode += (UInt16(array[29]) << 8)
            self.lcdOff = UInt16(array[30])
            self.lcdOff += (UInt16(array[31]) << 8)
            
            self.chgPowerDC = UInt32(array[32])
            self.chgPowerDC += (UInt32(array[33]) << 8)
            self.chgPowerDC += (UInt32(array[34]) << 16)
            self.chgPowerDC += (UInt32(array[35]) << 24)
            
            self.chgSunPower = UInt32(array[36])
            self.chgSunPower += (UInt32(array[37]) << 8)
            self.chgSunPower += (UInt32(array[38]) << 16)
            self.chgSunPower += (UInt32(array[39]) << 24)
            
            self.chgPowerAC = UInt32(array[40])
            self.chgPowerAC += (UInt32(array[41]) << 8)
            self.chgPowerAC += (UInt32(array[42]) << 16)
            self.chgPowerAC += (UInt32(array[43]) << 24)
            
            self.dsgPowerDC = UInt32(array[44])
            self.dsgPowerDC += (UInt32(array[45]) << 8)
            self.dsgPowerDC += (UInt32(array[46]) << 16)
            self.dsgPowerDC += (UInt32(array[47]) << 24)
            
            self.dsgPowerAC = UInt32(array[48])
            self.dsgPowerAC += (UInt32(array[49]) << 8)
            self.dsgPowerAC += (UInt32(array[50]) << 16)
            self.dsgPowerAC += (UInt32(array[51]) << 24)
            
            self.usbUsedTime = UInt32(array[52])
            self.usbUsedTime += (UInt32(array[53]) << 8)
            self.usbUsedTime += (UInt32(array[54]) << 16)
            self.usbUsedTime += (UInt32(array[55]) << 24)
            
            self.usbqcUsedTime = UInt32(array[56])
            self.usbqcUsedTime += (UInt32(array[57]) << 8)
            self.usbqcUsedTime += (UInt32(array[58]) << 16)
            self.usbqcUsedTime += (UInt32(array[59]) << 24)
            
            self.typecUsedTime = UInt32(array[60])
            self.typecUsedTime += (UInt32(array[61]) << 8)
            self.typecUsedTime += (UInt32(array[62]) << 16)
            self.typecUsedTime += (UInt32(array[63]) << 24)
            
            self.carUsedTime = UInt32(array[64])
            self.carUsedTime += (UInt32(array[65]) << 8)
            self.carUsedTime += (UInt32(array[66]) << 16)
            self.carUsedTime += (UInt32(array[67]) << 24)
            
            self.invUsedTime = UInt32(array[68])
            self.invUsedTime += (UInt32(array[69]) << 8)
            self.invUsedTime += (UInt32(array[70]) << 16)
            self.invUsedTime += (UInt32(array[71]) << 24)
            
            self.dcInUsedTime = UInt32(array[72])
            self.dcInUsedTime += (UInt32(array[73]) << 8)
            self.dcInUsedTime += (UInt32(array[74]) << 16)
            self.dcInUsedTime += (UInt32(array[75]) << 24)
            
            self.mpptUsedTime = UInt32(array[76])
            self.mpptUsedTime += (UInt32(array[77]) << 8)
            self.mpptUsedTime += (UInt32(array[78]) << 16)
            self.mpptUsedTime += (UInt32(array[79]) << 24)
        }

    }
    
    func updateString(with jsonStr: String) {
        do {
            let jsonDat = try JSON(data: jsonStr.data(using: String.Encoding.utf8)!)
            //PD
            if let model = jsonDat["data"]["status"]["pd"]["model"].uInt8 { self.model = model }
            if let errorCode = jsonDat["data"]["status"]["pd"]["error_code"].uInt32 { self.errorCode = errorCode }
            if let sysVersion = jsonDat["data"]["status"]["pd"]["sys_ver"].uInt32 { self.sysVersion = sysVersion }
            if let socSum = jsonDat["data"]["status"]["pd"]["soc_sum"].uInt8 { self.socSum = socSum }
            if let wattsOutSum = jsonDat["data"]["status"]["pd"]["watts_out_sum"].uInt16 { self.wattsOutSum = wattsOutSum }
            if let wattsInSum = jsonDat["data"]["status"]["pd"]["watts_in_sum"].uInt16 { self.wattsInSum = wattsInSum }
            if let remainTime = jsonDat["data"]["status"]["pd"]["remain_time"].uInt32 { self.remainTime = remainTime }
            if let carSwitch = jsonDat["data"]["status"]["pd"]["car_switch"].uInt8 { self.carSwitch = carSwitch }
            if let ledState = jsonDat["data"]["status"]["pd"]["led_state"].uInt8 { self.ledState = ledState }
            //新增加的beep字段
            if let beep = jsonDat["data"]["status"]["pd"]["beep"].uInt8 { self.beep = beep }
            if let typecWatts = jsonDat["data"]["status"]["pd"]["typec_watts"].uInt8 { self.typecWatts = typecWatts }
            if let usb1Watts = jsonDat["data"]["status"]["pd"]["usb1_watts"].uInt8 { self.usb1Watts = usb1Watts }
            if let usb2Watts = jsonDat["data"]["status"]["pd"]["usb2_watts"].uInt8 { self.usb2Watts = usb2Watts }
            if let usb3Watts = jsonDat["data"]["status"]["pd"]["usb3_watts"].uInt8 { self.usb3Watts = usb3Watts }
            if let carWatts = jsonDat["data"]["status"]["pd"]["car_watts"].uInt8 { self.carWatts = carWatts }
            if let ledWatts = jsonDat["data"]["status"]["pd"]["led_watts"].uInt8 { self.ledWatts = ledWatts }
            if let typecTemp = jsonDat["data"]["status"]["pd"]["typec_temp"].int8 { self.typecTemp = typecTemp }
            if let carTemp = jsonDat["data"]["status"]["pd"]["car_temp"].int8 { self.carTemp = carTemp }
            if let standbyMode = jsonDat["data"]["status"]["pd"]["standby_mode"].uInt16 { self.standbyMode = standbyMode }
            if let chgPowerDC = jsonDat["data"]["status"]["pd"]["chgPowerDC"].uInt32 { self.chgPowerDC = chgPowerDC }
            if let chgSunPower = jsonDat["data"]["status"]["pd"]["chgSunPower"].uInt32 { self.chgSunPower = chgSunPower }
            if let chgPowerAC = jsonDat["data"]["status"]["pd"]["chgPowerAC"].uInt32 { self.chgPowerAC = chgPowerAC }
            if let dsgPowerDC = jsonDat["data"]["status"]["pd"]["dsgPowerDC"].uInt32 { self.dsgPowerDC = dsgPowerDC }
            if let dsgPowerAC = jsonDat["data"]["status"]["pd"]["dsgPowerAC"].uInt32 { self.dsgPowerAC = dsgPowerAC }
            if let usbUsedTime = jsonDat["data"]["status"]["pd"]["usb_used_time"].uInt32 { self.usbUsedTime = usbUsedTime }
            if let usbqcUsedTime = jsonDat["data"]["status"]["pd"]["usbqc_used_time"].uInt32 { self.usbqcUsedTime = usbqcUsedTime }
            if let typecUsedTime = jsonDat["data"]["status"]["pd"]["typec_used_time"].uInt32 { self.typecUsedTime = typecUsedTime }
            if let carUsedTime = jsonDat["data"]["status"]["pd"]["car_used_time"].uInt32 { self.carUsedTime = carUsedTime }
            if let invUsedTime = jsonDat["data"]["status"]["pd"]["inv_used_time"].uInt32 { self.invUsedTime = invUsedTime }
            if let dcInUsedTime = jsonDat["data"]["status"]["pd"]["dc_in_used_time"].uInt32 { self.dcInUsedTime = dcInUsedTime }
            if let mpptUsedTime = jsonDat["data"]["status"]["pd"]["mppt_used_time"].uInt32 { self.mpptUsedTime = mpptUsedTime }
            
            //MR310新增
            if let lcdOffTime =  jsonDat["data"]["status"]["pd"]["lcd_off_sec"].uInt16 { self.lcdOff = lcdOffTime }
            if let typec1_temp =  jsonDat["data"]["status"]["pd"]["typec1_temp"].uInt8 { self.typec1Temp = typec1_temp }
            if let typec2_temp =  jsonDat["data"]["status"]["pd"]["typec2_temp"].uInt8 { self.typec2Temp = typec2_temp }
            if let typec1_watts =  jsonDat["data"]["status"]["pd"]["typec1_watts"].uInt8 { self.typec1Watts = typec1_watts }
            if let typec2_watts =  jsonDat["data"]["status"]["pd"]["typec2_watts"].uInt8 { self.typec2Watts = typec2_watts }
            if let qc_usb1_watts =  jsonDat["data"]["status"]["pd"]["qc_usb1_watts"].uInt8 { self.qc_usb1Watts = qc_usb1_watts }
            if let qc_usb2_watts =  jsonDat["data"]["status"]["pd"]["qc_usb2_watts"].uInt8 { self.qc_usb2Watts = qc_usb2_watts }
            if let dc_out_state =  jsonDat["data"]["status"]["pd"]["dc_out_state"].uInt8 { self.carSwitch = dc_out_state }
            
            
        } catch {
            Debug.shared.println("解析远程数据异常")
        }
    }
    
    func getVersion() -> String {
        let ver0 = Int(self.sysVersion & 0x000000FF)
        let ver1 = Int((self.sysVersion >> 8) & 0x000000FF)
        let ver2 = Int((self.sysVersion >> 16) & 0x000000FF)
        let ver3 = Int((self.sysVersion >> 24) & 0x000000FF)
        return "\(ver3).\(ver2).\(ver1).\(ver0)"
    }
}


//MARK: - BMS master 电池模块
class EFHeartbeatBMS { //heartbeat_bms_master_t, ADDR_BMS_M=3, 32bytes
    static let LENGTH:Int = 32
    
    var errorCode:UInt32 = 0
    var sysVersion:UInt32 = 0
    var soc:UInt8 = 0
    var vol:UInt32 = 0
    var amp:Int32 = 0
    var temp:Int8 = 0
    var state:UInt8 = 0
    var remainCap:UInt32 = 0
    var fullCap:UInt32 = 0
    var cycles:UInt32 = 0
    var maxChgSoc:UInt8 = 0
    
    //MR310新增
    var design_cap:UInt32 = 0 //设计容量
    var max_cell_vol:UInt16 = 0 //最大电芯电压
    var min_cell_vol:UInt16 = 0 //最小电芯电压
    var max_cell_temp:Int8 = 0 //最大电芯温度
    var min_cell_temp:Int8 = 0 //最小电芯温度
    var max_mos_temp:Int8 = 0 //最大MOS温度
    var min_mos_temp:Int8 = 0 //最小MOS温度
    var bms_fault:UInt8 = 0 //BMS永久故障
    var bq_sys_stat_reg:UInt8 = 0 //BQ的硬件保护寄存器
    
    var bms_chg_flag:UInt8 = 0 //bms充电标志
    var bms_chg_vol:UInt32 = 0 //bms充电电压
    var bms_chg_amp:UInt32 = 0 //bms充电电流
    
    
    var inv_chg_flag:UInt8 = 0 //inv充电开关
    var inv_chg_vol:UInt32 = 0 //inv充电电压
    var inv_chg_amp:UInt32 = 0 //inv充电电流
    var inv_fan_level:UInt8 = 0 //风扇等级
    var inv_chg_type:UInt8 = 0 //充电类型
    
    var slave_is_connt_state:UInt8 = 0 //从包连接状态
    var bms_model:UInt8 = 0 //BMS型号
    var lcd_show_soc:UInt8 = 0 //LCD显示的soc值
    var open_ups_flag:UInt8 = 0 //UPS模式启用标志
    var bms_warning_state:UInt8 = 0 //BMS报警显示  bit0:hi_temp,bit1:low_temp,bit2:overload,bit3:chg_flag
    var chg_remain_time:UInt32 = 0 //充电剩余时间mins
    var dsg_remain_time:UInt32 = 0 //放电剩余时间mins
    
    init() {
    }
    
    init(array: [UInt8]) {
        update(with: array)
    }
    
    func update(with array: [UInt8]) {
        guard array.count == EFHeartbeatBMS.LENGTH else { return }
        self.errorCode = UInt32(array[0])
        self.errorCode += (UInt32(array[1]) << 8)
        self.errorCode += (UInt32(array[2]) << 16)
        self.errorCode += (UInt32(array[3]) << 24)
        self.sysVersion = UInt32(array[4])
        self.sysVersion += (UInt32(array[5]) << 8)
        self.sysVersion += (UInt32(array[6]) << 16)
        self.sysVersion += (UInt32(array[7]) << 24)
        self.soc = array[8]
        self.vol = UInt32(array[9])
        self.vol += (UInt32(array[10]) << 8)
        self.vol += (UInt32(array[11]) << 16)
        self.vol += (UInt32(array[12]) << 24)
        self.amp = Int32(array[13])
        self.amp += (Int32(array[14]) << 8)
        self.amp += (Int32(array[15]) << 16)
        self.amp += (Int32(array[16]) << 24)
        self.temp = Int8(array[17])
        self.state = array[18]
        self.remainCap = UInt32(array[19])
        self.remainCap += (UInt32(array[20]) << 8)
        self.remainCap += (UInt32(array[21]) << 16)
        self.remainCap += (UInt32(array[22]) << 24)
        self.fullCap = UInt32(array[23])
        self.fullCap += (UInt32(array[24]) << 8)
        self.fullCap += (UInt32(array[25]) << 16)
        self.fullCap += (UInt32(array[26]) << 24)
        self.cycles = UInt32(array[27])
        self.cycles += (UInt32(array[28]) << 8)
        self.cycles += (UInt32(array[29]) << 16)
        self.cycles += (UInt32(array[30]) << 24)
        self.maxChgSoc = array[31]
    }
    
    func update(with jsonStr: String) {
        do {
            let jsonDat = try JSON(data: jsonStr.data(using: String.Encoding.utf8)!)
            //bms_m
            if let errorCode = jsonDat["data"]["status"]["bms_m"]["error_code"].uInt32 {
                self.errorCode = errorCode
            }
            if let sysVersion = jsonDat["data"]["status"]["bms_m"]["sys_ver"].uInt32 {
                self.sysVersion = sysVersion
            }
            if let soc = jsonDat["data"]["status"]["bms_m"]["soc"].uInt8 {
                self.soc = soc
            }
            if let vol = jsonDat["data"]["status"]["bms_m"]["vol"].uInt32 {
                self.vol = vol
            }
            if let amp = jsonDat["data"]["status"]["bms_m"]["amp"].int32 {
                self.amp = amp
            }
            if let temp = jsonDat["data"]["status"]["bms_m"]["temp"].int8 {
                self.temp = temp
            }
            if let state = jsonDat["data"]["status"]["bms_m"]["state"].uInt8 {
                self.state = state
            }
            if let remainCap = jsonDat["data"]["status"]["bms_m"]["remain_cap"].uInt32 {
                self.remainCap = remainCap
            }
            if let cycles = jsonDat["data"]["status"]["bms_m"]["cycles"].uInt32 {
                self.cycles = cycles
            }
            if let maxChgSoc = jsonDat["data"]["status"]["bms_m"]["max_chg_soc"].uInt8 {
                self.maxChgSoc = maxChgSoc
            }
        } catch {
            Debug.shared.println("解析远程数据异常")
        }
    }
    
    func getVersion() -> String {
        let ver0 = Int(self.sysVersion & 0x000000FF)
        let ver1 = Int((self.sysVersion >> 8) & 0x000000FF)
        let ver2 = Int((self.sysVersion >> 16) & 0x000000FF)
        let ver3 = Int((self.sysVersion >> 24) & 0x000000FF)
        return "\(ver3).\(ver2).\(ver1).\(ver0)"
    }
}


//MARK: - INV 交流电模块
class EFHeartbeatInv { //heartbeat_inv_t, ADDR_INV=4, 51bytes
    static let LENGTH:Int = 51
    
    var errorCode:UInt32 = 0
    var sysVersion:UInt32 = 0
    var chargerType:UInt8 = 0
    var inputWatts:UInt16 = 0
    var outputWatts:UInt16 = 0
    var invType:UInt8 = 0
    var outVol:UInt32 = 0
    var outAmp:UInt32 = 0
    var outFreq:UInt8 = 0
    var inVol:UInt32 = 0
    var inAmp:UInt32 = 0
    var inFreq:UInt8 = 0
    var outTemp:Int8 = 0

    var dcInVol:UInt32 = 0
    var dcInAmp:UInt32 = 0
    var inTemp:Int8 = 0
    var fanState:UInt8 = 0

    var invSwitch:UInt8 = 0
    var xboost:UInt8 = 0
    var cfgOutVol:UInt32 = 0
    var cfgOutFreq:UInt8 = 0 //1:50hz 2:60hz
    var workMode:UInt8 = 0
    
    init() {
    }
    
    init(array: [UInt8]) {
        update(with: array)
    }
    
    func update(with array: [UInt8]) {
        guard array.count == EFHeartbeatInv.LENGTH else { return }
        self.errorCode = UInt32(array[0])
        self.errorCode += (UInt32(array[1]) << 8)
        self.errorCode += (UInt32(array[2]) << 16)
        self.errorCode += (UInt32(array[3]) << 24)
        self.sysVersion = UInt32(array[4])
        self.sysVersion += (UInt32(array[5]) << 8)
        self.sysVersion += (UInt32(array[6]) << 16)
        self.sysVersion += (UInt32(array[7]) << 24)
        self.chargerType = array[8]
        self.inputWatts = UInt16(array[9])
        self.inputWatts += (UInt16(array[10]) << 8)
        self.outputWatts = UInt16(array[11])
        self.outputWatts += (UInt16(array[12]) << 8)
        self.invType = array[13]
        self.outVol = UInt32(array[14])
        self.outVol += (UInt32(array[15]) << 8)
        self.outVol += (UInt32(array[16]) << 16)
        self.outVol += (UInt32(array[17]) << 24)
        self.outAmp = UInt32(array[18])
        self.outAmp += (UInt32(array[19]) << 8)
        self.outAmp += (UInt32(array[20]) << 16)
        self.outAmp += (UInt32(array[21]) << 24)
        self.outFreq = array[22]
        self.inVol = UInt32(array[23])
        self.inVol += (UInt32(array[24]) << 8)
        self.inVol += (UInt32(array[26]) << 16)
        self.inVol += (UInt32(array[26]) << 24)
        self.inAmp = UInt32(array[27])
        self.inAmp += (UInt32(array[28]) << 8)
        self.inAmp += (UInt32(array[29]) << 16)
        self.inAmp += (UInt32(array[30]) << 24)
        self.inFreq = array[31]
        self.outTemp = Int8(array[32])
        self.dcInVol = UInt32(array[33])
        self.dcInVol += (UInt32(array[34]) << 8)
        self.dcInVol += (UInt32(array[35]) << 16)
        self.dcInVol += (UInt32(array[36]) << 24)
        self.dcInAmp = UInt32(array[37])
        self.dcInAmp += (UInt32(array[38]) << 8)
        self.dcInAmp += (UInt32(array[39]) << 16)
        self.dcInAmp += (UInt32(array[40]) << 24)
        self.inTemp = Int8(array[41])
        self.fanState = array[42]
        self.invSwitch = array[43]
        self.xboost = array[44]
        self.cfgOutVol = UInt32(array[45])
        self.cfgOutVol += (UInt32(array[46]) << 8)
        self.cfgOutVol += (UInt32(array[47]) << 16)
        self.cfgOutVol += (UInt32(array[48]) << 24)
        self.cfgOutFreq = array[49]
        self.workMode = array[50]
    }
    
    func update(with jsonStr: String) {
        do {
            let jsonDat = try JSON(data: jsonStr.data(using: String.Encoding.utf8)!)
            //inv
            if let errorCode = jsonDat["data"]["status"]["inv"]["error_code"].uInt32 { self.errorCode = errorCode }
            if let sysVersion = jsonDat["data"]["status"]["inv"]["sys_ver"].uInt32 { self.sysVersion = sysVersion }
            if let chargerType = jsonDat["data"]["status"]["inv"]["charger_type"].uInt8 { self.chargerType = chargerType }
            if let inputWatts = jsonDat["data"]["status"]["inv"]["input_watts"].uInt16 { self.inputWatts = inputWatts }
            if let outputWatts = jsonDat["data"]["status"]["inv"]["output_watts"].uInt16 { self.outputWatts = outputWatts }
            if let invType = jsonDat["data"]["status"]["inv"]["inv_type"].uInt8 { self.invType = invType }
            if let outVol = jsonDat["data"]["status"]["inv"]["inv_out_vol"].uInt32 { self.outVol = outVol }
            if let outTemp = jsonDat["data"]["status"]["inv"]["inv_out_amp"].int8 { self.outTemp = outTemp }
            if let outFreq = jsonDat["data"]["status"]["inv"]["inv_out_freq"].uInt8 { self.outFreq = outFreq }
            if let inVol = jsonDat["data"]["status"]["inv"]["inv_in_vol"].uInt32 { self.inVol = inVol }
            if let inAmp = jsonDat["data"]["status"]["inv"]["inv_in_amp"].uInt32 { self.inAmp = inAmp }
            if let inFreq = jsonDat["data"]["status"]["inv"]["inv_in_freq"].uInt8 { self.inFreq = inFreq }
            if let outTemp = jsonDat["data"]["status"]["inv"]["out_temp"].int8 { self.outTemp = outTemp }
            if let dcInVol = jsonDat["data"]["status"]["inv"]["dc_in_vol"].uInt32 { self.dcInVol = dcInVol }
            if let dcInAmp = jsonDat["data"]["status"]["inv"]["dc_in_amp"].uInt32 { self.dcInAmp = dcInAmp }
            if let inTemp = jsonDat["data"]["status"]["inv"]["in_temp"].int8 { self.inTemp = inTemp }
            if let fanState = jsonDat["data"]["status"]["inv"]["fan_state"].uInt8 { self.fanState = fanState }
            if let invSwitch = jsonDat["data"]["status"]["inv"]["inv_switch"].uInt8 {
                self.invSwitch = invSwitch
                Debug.shared.println("当前inv地址：\(self.invSwitch)")
            }
            if let xboost = jsonDat["data"]["status"]["inv"]["xboost"].uInt8 { self.xboost = xboost }
            if let cfgOutVol = jsonDat["data"]["status"]["inv"]["inv_cfg_out_vol"].uInt32 { self.cfgOutVol = cfgOutVol }
            if let cfgOutFreq = jsonDat["data"]["status"]["inv"]["inv_cfg_out_freq"].uInt8 { self.cfgOutFreq = cfgOutFreq }
            if let workMode = jsonDat["data"]["status"]["inv"]["work_mode"].uInt8 { self.workMode = workMode }
        } catch {
            Debug.shared.println("解析远程数据异常")
        }
    }
    
    func getVersion() -> String {
        let ver0 = Int(self.sysVersion & 0x000000FF)
        let ver1 = Int((self.sysVersion >> 8) & 0x000000FF)
        let ver2 = Int((self.sysVersion >> 16) & 0x000000FF)
        let ver3 = Int((self.sysVersion >> 24) & 0x000000FF)
        return "\(ver3).\(ver2).\(ver1).\(ver0)"
    }
}


//MARK: - BMS slave 模块模块
class EFHeartbeatBMSSlave { //heartbeat_bms_slave_t, ADDR_BMS_S=6, 37bytes
    static let LENGTH:Int = 37
    static let PRO_LENGTH:Int = 39
    
    var errorCode:UInt32 = 0
    var sysVersion:UInt32 = 0
    var soc:UInt8 = 0
    var vol:UInt32 = 0
    var amp:Int32 = 0
    var temp:Int8 = 0
    var remainCap:UInt32 = 0
    var fullCap:UInt32 = 0
    var cycles:UInt32 = 0

    var ambientLightMode:UInt8 = 0
    var ambientLightAnimate:UInt8 = 0
    var ambientLightColor:UInt32 = 0
    var ambientLightBrightness:UInt8 = 0
    
    //PRO
    var batteryType:UInt8 = 0
    var minVoltage:UInt16 = 0
    var maxVoltage:UInt16 = 0
    var maxCapacity:UInt32 = 0
    
    
    func update(with array: [UInt8]) {
        guard array.count == EFHeartbeatBMSSlave.LENGTH || array.count == EFHeartbeatBMSSlave.PRO_LENGTH else {
            return
        }
        self.errorCode = UInt32(array[0])
        self.errorCode += (UInt32(array[1]) << 8)
        self.errorCode += (UInt32(array[2]) << 16)
        self.errorCode += (UInt32(array[3]) << 24)
        self.sysVersion = UInt32(array[4])
        self.sysVersion += (UInt32(array[5]) << 8)
        self.sysVersion += (UInt32(array[6]) << 16)
        self.sysVersion += (UInt32(array[7]) << 24)
        self.soc = array[8]
        self.vol = UInt32(array[9])
        self.vol += (UInt32(array[10]) << 8)
        self.vol += (UInt32(array[11]) << 16)
        self.vol += (UInt32(array[12]) << 24)
        self.amp = Int32(array[13])
        self.amp += (Int32(array[14]) << 8)
        self.amp += (Int32(array[15]) << 16)
        self.amp += (Int32(array[16]) << 24)
        self.temp = Int8(array[17])
        self.remainCap = UInt32(array[18])
        self.remainCap += (UInt32(array[19]) << 8)
        self.remainCap += (UInt32(array[20]) << 16)
        self.remainCap += (UInt32(array[21]) << 24)
        self.fullCap = UInt32(array[22])
        self.fullCap += (UInt32(array[23]) << 8)
        self.fullCap += (UInt32(array[24]) << 16)
        self.fullCap += (UInt32(array[25]) << 24)
        self.cycles = UInt32(array[26])
        self.cycles += (UInt32(array[27]) << 8)
        self.cycles += (UInt32(array[28]) << 16)
        self.cycles += (UInt32(array[29]) << 24)
        
        if array.count == EFHeartbeatBMSSlave.LENGTH {
            self.ambientLightMode = array[30]
            self.ambientLightAnimate = array[31]
            self.ambientLightColor = UInt32(array[32])
            self.ambientLightColor += (UInt32(array[33]) << 8)
            self.ambientLightColor += (UInt32(array[34]) << 16)
            self.ambientLightColor += (UInt32(array[35]) << 24)
            self.ambientLightBrightness = array[36]
        } else if array.count == EFHeartbeatBMSSlave.PRO_LENGTH { //pro设备的
            self.batteryType = array[30]
            self.minVoltage = UInt16(array[31])
            self.minVoltage += (UInt16(array[32]) << 8)
            self.maxVoltage = UInt16(array[33])
            self.maxVoltage += (UInt16(array[34]) << 8)
            self.maxCapacity = UInt32(array[35])
            self.maxCapacity += (UInt32(array[36]) << 8)
            self.maxCapacity += (UInt32(array[37]) << 16)
            self.maxCapacity += (UInt32(array[38]) << 24)
        }
    }
    
    func update(with jsonStr: String) {
        do {
            let jsonDat = try JSON(data: jsonStr.data(using: String.Encoding.utf8)!)
            //bms_s
            if let errorCode = jsonDat["data"]["status"]["bms_s"]["error_code"].uInt32 {
                self.errorCode = errorCode
            }
            if let sysVersion = jsonDat["data"]["status"]["bms_s"]["sys_ver"].uInt32 {
                self.sysVersion = sysVersion
            }
            if let soc = jsonDat["data"]["status"]["bms_s"]["soc"].uInt8 {
                self.soc = soc
            }
            if let vol = jsonDat["data"]["status"]["bms_s"]["vol"].uInt32 {
                self.vol = vol
            }
            if let amp = jsonDat["data"]["status"]["bms_s"]["amp"].int32 {
                self.amp = amp
            }
            if let temp = jsonDat["data"]["status"]["bms_s"]["temp"].int8 {
                self.temp = temp
            }
            if let remainCap = jsonDat["data"]["status"]["bms_s"]["remain_cap"].uInt32 {
                self.remainCap = remainCap
            }
            if let fullCap = jsonDat["data"]["status"]["bms_s"]["full_cap"].uInt32 {
                self.fullCap = fullCap
            }
            if let cycles = jsonDat["data"]["status"]["bms_s"]["cycles"].uInt32 {
                self.cycles = cycles
            }
            if let ambientLightMode = jsonDat["data"]["status"]["bms_s"]["ambientLightMode"].uInt8 {
                self.ambientLightMode = ambientLightMode
            }
            if let ambientLightAnimate = jsonDat["data"]["status"]["bms_s"]["ambientLightAnimate"].uInt8 {
                self.ambientLightAnimate = ambientLightAnimate
            }
            if let ambientLightColor = jsonDat["data"]["status"]["bms_s"]["ambientLightColor"].uInt32 {
                self.ambientLightColor = ambientLightColor
            }
            if let ambientLightBrightness = jsonDat["data"]["status"]["bms_s"]["ambientLightBrightness"].uInt8 {
                self.ambientLightBrightness = ambientLightBrightness
            }
            if let batteryType = jsonDat["data"]["status"]["bms_s"]["batteryType"].uInt8 {
                self.batteryType = batteryType
            }
            if let minVoltage = jsonDat["data"]["status"]["bms_s"]["minVoltage"].uInt16 {
                self.minVoltage = minVoltage
            }
            if let maxVoltage = jsonDat["data"]["status"]["bms_s"]["maxVoltage"].uInt16 {
                self.maxVoltage = maxVoltage
            }
            if let maxCapacity = jsonDat["data"]["status"]["bms_s"]["maxCapacity"].uInt32 {
                self.maxCapacity = maxCapacity
            }
        } catch {
            Debug.shared.println("解析远程数据异常")
        }
    }
    
    func getVersion() -> String {
        let ver0 = Int(self.sysVersion & 0x000000FF)
        let ver1 = Int((self.sysVersion >> 8) & 0x000000FF)
        let ver2 = Int((self.sysVersion >> 16) & 0x000000FF)
        let ver3 = Int((self.sysVersion >> 24) & 0x000000FF)
        return "\(ver3).\(ver2).\(ver1).\(ver0)"
    }
}

/*
class EFHeartbeatModel {
    static let shared = EFHeartbeatModel()
    
    func format(_ array: [UInt8], to type: EFHeartbeatType) -> Any? {
        switch type {
        case .pd:
            return EFHeartbeatPD.create(with: array)
        case .bmsMaster:
            return EFHeartbeatBMS.create(with: array)
        case .bmsSlave:
            return EFHeartbeatBMSSlave.create(with: array)
        case .inv:
            return EFHeartbeatInv.create(with: array)
        }
    }
    
    func format(_ array: [UInt8], to type: UInt8) -> Any? {
        var hbType = EFHeartbeatType.pd
        switch type {
        case 0x3:
            hbType = EFHeartbeatType.bmsMaster
        case 0x4:
            hbType = EFHeartbeatType.inv
        case 0x6:
            hbType = EFHeartbeatType.bmsSlave
        default: //0x2 PD
            break
        }
        return format(array, to: hbType)
    }
    
    func create(type: EFHeartbeatType) -> Any {
        switch type {
        case .pd:
            return EFHeartbeatPD()
        case .bmsSlave:
            return EFHeartbeatBMSSlave()
        case .bmsMaster:
            return EFHeartbeatBMS()
        case .inv:
            return EFHeartbeatInv()
        }
    }
}*/
class EFHeartbeatMppt {
    
    static let MPPT_LENGTH = 34
    
    //mppt
    var    fault_code: UInt32 = 0         //错误码，byte0：mppt_fault, byte1:car_fault;byte2:dc24v_fault
    var    sw_ver: UInt32 = 0        //mppt   版本号
    var    in_vol: UInt16 = 0          //实际电压放大10倍，如10V，用100表示
    var    in_amp: UInt16 = 0          //实际电流放大100倍，如1A，用100表示
    var    in_watts: UInt16 = 0        //实际功率放大10倍，如1W，用10表示
    var    out_vol: UInt16 = 0         //实际电压放大10倍，如10V，用100表示
    var    out_amp: UInt16 = 0         //实际电流放大100倍，如1A，用100表示
    var    out_watts: UInt16 = 0       //实际功率放大10倍，如1W，用10表示
    var    mppt_temp: Int8 = 0       //温度精确到度，如25，表示25度
    var    chg_type_cfg: UInt8 = 0    //0： Auto, 1：Adapter, 2：MPPT
    var    chg_type: UInt8 = 0        //0:  null, 1：Adapter, 2：MPPT
    var    chg_state: UInt8 = 0      //0:  关,1,  正在充电，2：待机（输入正常如AC充电时，DC暂停充电）
    
    //car
    var    car_vol: UInt16 = 0    //实际电压放大10倍，如10V，用100表示
    var    car_amp: UInt16 = 0    //实际电流放大100倍，如1A，用100表示
    var    car_watts: UInt16 = 0    //实际功率放大10倍，如1W，用10表示
    var    car_temp: Int8 = 0    //温度精确到度，如25，表示25度
    var    car_state: UInt8 = 0    //"0：关 1：开"
    
    //dc24v
    var    dc24v_temp: Int8 = 0       //温度精确到度，如25，表示25度
  
    var    dc24v_state: UInt8 = 0        //"0：关 1：开"
    
    func update(with array: [UInt8]) {
        
        guard array.count >= EFHeartbeatMppt.MPPT_LENGTH else {
            return
        }
        
        self.fault_code =  UInt32(array[0])
        self.fault_code += (UInt32(array[1]) << 8)
        self.fault_code += (UInt32(array[2]) << 16)
        self.fault_code += (UInt32(array[3]) << 24)
        
        self.sw_ver = UInt32(array[4])
        self.sw_ver += (UInt32(array[5]) << 8)
        self.sw_ver += (UInt32(array[6]) << 16)
        self.sw_ver += (UInt32(array[7]) << 24)
        
        self.in_vol = UInt16(array[8])
        self.in_vol += (UInt16(array[9]) << 8)
        
        self.in_amp = UInt16(array[10])
        self.in_amp += (UInt16(array[11]) << 8)
        
        self.in_watts = UInt16(array[12])
        self.in_watts += (UInt16(array[13]) << 8)
        
        self.out_vol = UInt16(array[14])
        self.out_vol += (UInt16(array[15]) << 8)
        
        self.out_amp = UInt16(array[16])
        self.out_amp += (UInt16(array[17]) << 8)
        
        self.out_watts = UInt16(array[18])
        self.out_watts += (UInt16(array[19]) << 8)
        
        self.mppt_temp = Int8(array[20])
        
        self.chg_type_cfg = UInt8(array[21])
        
        self.chg_type = UInt8(array[22])
        
        self.chg_state = UInt8(array[23])
        
        //car
        
        self.car_vol = UInt16(array[24])
        self.car_vol += (UInt16(array[25]) << 8)
        
        self.car_amp = UInt16(array[26])
        self.car_amp += (UInt16(array[27]) << 8)
        
        self.car_watts = UInt16(array[28])
        self.car_watts += (UInt16(array[29]) << 8)
        
        self.car_temp = Int8(array[30])
        
        self.car_state = UInt8(array[31])
        
        //dc24v
        
        self.dc24v_temp = Int8(array[32])
        
        self.dc24v_state = UInt8(array[33])
    }
    
    func update(with jsonStr: String) {
        do {
            let jsonDat = try JSON(data: jsonStr.data(using: String.Encoding.utf8)!)
            //bms_s
            if let errorCode = jsonDat["data"]["status"]["mppt"]["error_code"].uInt32 {
                self.fault_code = errorCode
            }
            if let sysVersion = jsonDat["data"]["status"]["mppt"]["sys_ver"].uInt32 {
                self.sw_ver = sysVersion
            }
            if let inVol = jsonDat["data"]["status"]["mppt"]["in_vol"].uInt16 {
                self.in_vol = inVol
            }
            if let amp = jsonDat["data"]["status"]["mppt"]["in_amp"].uInt16 {
                self.in_amp = amp
            }
            if let inWatts = jsonDat["data"]["status"]["mppt"]["in_watts"].uInt16 {
                self.in_watts = inWatts
            }
            if let outVol = jsonDat["data"]["status"]["mppt"]["out_vol"].uInt16 {
                self.out_vol = outVol
            }
            if let outAmp = jsonDat["data"]["status"]["mppt"]["out_amp"].uInt16 {
                self.out_amp = outAmp
            }
            
            if let outWatts = jsonDat["data"]["status"]["mppt"]["out_watts"].uInt16 {
                self.out_watts = outWatts
            }
            if let mpptTemp = jsonDat["data"]["status"]["mppt"]["mppt_temp"].int8 {
                self.mppt_temp = mpptTemp
            }
            if let chgCfg = jsonDat["data"]["status"]["mppt"]["chg_type_cfg"].uInt8 {
                self.chg_type_cfg = chgCfg
            }
            if let chgtype = jsonDat["data"]["status"]["mppt"]["chg_type"].uInt8 {
                self.chg_type = chgtype
            }
            if let chgState = jsonDat["data"]["status"]["mppt"]["chg_state"].uInt8 {
                self.chg_state = chgState
            }
            if let catVol = jsonDat["data"]["status"]["mppt"]["cat_vol"].uInt16 {
                self.car_vol = catVol
            }
            if let catAmp = jsonDat["data"]["status"]["mppt"]["cat_amp"].uInt16 {
                self.car_amp = catAmp
            }
            if let carWatts = jsonDat["data"]["status"]["mppt"]["car_watts"].uInt16 {
                self.car_watts = carWatts
            }
            if let carTemp = jsonDat["data"]["status"]["mppt"]["car_temp"].int8 {
                self.car_temp = carTemp
            }
            if let carState = jsonDat["data"]["status"]["mppt"]["car_state"].uInt8 {
                self.car_state = carState
            }
            if let dc24vTemp = jsonDat["data"]["status"]["mppt"]["dc24v_temp"].int8 {
                self.dc24v_temp = dc24vTemp
            }
            if let dc24vState = jsonDat["data"]["status"]["mppt"]["dc24v_state"].uInt8 {
                self.dc24v_state = dc24vState
            }
        } catch {
            Debug.shared.println("解析远程数据异常")
        }
    }
}

