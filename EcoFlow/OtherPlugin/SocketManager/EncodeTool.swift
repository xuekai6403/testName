//
//  EncodeTool.swift
//  EcoFlow
//
//  Created by Curry on 2021/3/18.
//

import Foundation

class EncodeTool:NSObject{
    
    //参数
    private let PROTOCOL_V2:UInt8 = 0x02
    private let FRAME_SIG:UInt8 = 0xAA
    private let NEED_ACK:UInt8 = 0x01
    private let IS_ACK:UInt8 = 0x0
    private let CHECK_TYPE:UInt8 = 0x03
    
    //命令集
    private let CMD_SET_COMMON:UInt8 = 0x01
    private let CMD_SET_PD:UInt8 = 0x02
    private let CMD_SET_BMS:UInt8 = 0x03
    private let CMD_SET_INV:UInt8 = 0x04
    private let CMD_SET_MPPT:UInt8 = 0x05
    private let CMD_SET_KUAFU:UInt8 = 0x10 //MX200
    private let CMD_SET_IOT_SERVER:UInt8 = 0x20
    
    //子命令ID
    private let CMD_ID_SYS_RESET:UInt8 = 0x03
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
    
    //源地址
    private let SERV_ADDR:UInt8 = 0x20
    private let BLUESERV_ADDR:UInt8 = 0x21
    
    //目标地址
    private let ADDR_PD:UInt8 = 0x2
    private let ADDR_BMS_M:UInt8 = 0x3
    private let ADDR_BMS_S:UInt8 = 0x6
    private let ADDR_INV:UInt8 = 0x4
    private let ADDR_MPPT:UInt8 = 0x5
    private let ADDR_BLUE:UInt8 = 0x32
    
    private let HEADER_SIZE:Int = 16
    private let DEVICE_SN_LEN:Int = 16
    
    static let shared = EncodeTool()
    
    private override init() {
        
    }
    
    @objc open class func sharedInstance() -> EncodeTool
    {
        return self.shared
    }
    //     MARK: - R600
    
    //PD-系统消息推送
    @objc public func generatePD_STATUS() -> (Data){
        let pack = encode(cmdSet: CMD_SET_IOT_SERVER, cmdID: CMD_ID_STATUS_PUSH, product: 0xFFFF, data: [], srcAdd: SERV_ADDR, dstAdd: ADDR_PD)
        let data = Data(pack)
        return data
    }
    
    //设置LED
    @objc public func generatePD_LED() -> (Data){
        let pack = encode(cmdSet: CMD_SET_IOT_SERVER, cmdID: CMD_ID_LED_CONFIG, product: 0xFFFF, data: [UInt8(0)], srcAdd: SERV_ADDR, dstAdd: ADDR_PD)
        let data = Data(pack)
        return data
    }
    
    //设置AC
    @objc public func generateSet_AC(state: UInt8) -> (Data){
        let pack = encode(cmdSet: CMD_SET_IOT_SERVER, cmdID: CMD_ID_AC_OUT, product: 0xFFFF, data: [state,0xff,0xff,0xff,0xff,0xff,0xff], srcAdd: SERV_ADDR, dstAdd: ADDR_INV)
        let data = Data(pack)
        return data
    }
    
    //设置DC
    @objc public func generateSet_DC(state: UInt8) -> (Data){
        let pack = encode(cmdSet: CMD_SET_IOT_SERVER, cmdID: CMD_ID_DC_CONFIG, product: 0xFFFF, data: [state], srcAdd: SERV_ADDR, dstAdd: ADDR_PD)
        let data = Data(pack)
        return data
    }
    
    //     MARK:
    @objc public func generateP() -> (Data){
        let pack = encode(cmdSet: CMD_SET_IOT_SERVER, cmdID: CMD_ID_LED_CONFIG, product: 0xFFFF, data: [UInt8(0)], srcAdd: SERV_ADDR, dstAdd: ADDR_PD)
        let data = Data(pack)
        return data
    }
    
    func encode(cmdSet: UInt8, cmdID: UInt8, product: UInt16, data: [UInt8], srcAdd: UInt8,dstAdd: UInt8) -> [UInt8] {
        var frame = [UInt8]()
        frame.append(FRAME_SIG) //数据包开始标志-默认0xAA
        frame.append(PROTOCOL_V2) //协议版本目前默认0x02
        frame.append(UInt8(data.count & 0xFF)) //数据长度
        frame.append(UInt8((data.count & 0xFF00) >> 8))
        frame.append(CRCCheck.shareInstance.checkCRC8(buf: frame)) //包头校验
        
        var argsByte:UInt8 = 0x0
        argsByte += NEED_ACK
        argsByte += (IS_ACK << 1)
        argsByte += (CHECK_TYPE << 2)
        
        frame.append(argsByte) //need_ack
        
        frame.append(0x0) //frame_seq
        frame.append(0x0)
        frame.append(0x0)
        frame.append(0x0)
        
        frame.append(UInt8(product & 0xFF)) //product type 第一次填0xFFFF
        frame.append(UInt8((product & 0xFF00) >> 8))
        
        frame.append(srcAdd) //设备地址,不同的设备分配不同
        frame.append(dstAdd) //目标地址
        frame.append(cmdSet) //命令集ID
        frame.append(cmdID) //子命令ID
        
        //data
        for i in 0 ..< data.count {
            frame.append(data[i])
        }
        
        //package tail CRC16
        let crc16 = CRCCheck.shareInstance.checkCRC16(buf: frame)
        frame.append(UInt8(crc16 & 0xFF))
        frame.append(UInt8((crc16 & 0xFF00) >> 8))

        return frame
    }
}
