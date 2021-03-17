//
//  EFProtocol.swift
//  EcoFlow
//
//  Created by apple on 2020/5/19.
//  Copyright © 2020 wangwei. All rights reserved.
//

import Foundation

enum EFCommands {
    case getSN
    case getStatus
    case setLED
    case setLEDMode
    case setMaxChgSoc
    case setBeep
    case setAC
    case setDC
    case setOutFreq
    case setXboost
    case setMoodLight
    case setLEDColor
    case setBrightness
    case setStandby
    case setWorkMode
    case getWorkMode
    case resetDevice
    case getInvStatus
    case getBMSSlaveStatus
    case getBMSMasterStatus
    case getMpptStatus
    case setLcdStandbyTime
    case setMPPT
    case getLcdStandbyTime
    case getPDSysParams
    case getInvSysParams
    case getBmsSlaveSysParams
    case getBmsMasterSysParams
    case getSystemLogs
}

enum SysParamsType {
    case pd
    case inv
    case bmsSlave
    case bmsMaster
}

//MARK: - 数据包，包头和数据部分（payload）
class EFFrame {
    //header
    var sig: UInt8 = 0 //0xAA
    var version: UInt8 = 0 //0x2
    var dataLen: UInt16 = 0 //package length
    var hdrChk: UInt8 = 0 //header CRC8 check
    
    var args: UInt8 = 0 //including: need_ack/is_ack/chk_type/enc_type/seq_type
    var frameSeq: UInt32 = 0 //frame sequence
    var product: UInt16 = 0
    var srcAddr: UInt8 = 0
    var destAddr: UInt8 = 0
    var cmdSet: UInt8 = 0
    var cmdID: UInt8 = 0
    
    //payload
    var payload = [UInt8]()
    
    //CRC16
    var crc16: UInt16 = 0
}


//MARK: - 包解析
class EFProtocol {
    private let PROTOCOL_V2:UInt8 = 0x02
    private let FRAME_SIG:UInt8 = 0xAA
    private let NEED_ACK:UInt8 = 0x01
    private let IS_ACK:UInt8 = 0x0
    private let CHECK_TYPE:UInt8 = 0x03
    private let SERV_ADDR:UInt8 = 0x20
    
    static let CMD_SET_COMMON:UInt8 = 0x01
    static let CMD_ID_SYS_RESET:UInt8 = 0x03
    static let CMD_SET_IOT_SERVER:UInt8 = 0x20
    static let CMD_ID_GET_SN:UInt8 = 0x41
    static let CMD_ID_STATUS_PUSH:UInt8 = 0x02
    static let CMD_ID_LED_CONFIG:UInt8 = 0x23
    static let CMD_ID_SYS_EVENT_PUSH:UInt8 = 0x20
    static let CMD_ID_AMBIENT_LIGHT:UInt8 = 0x61
    static let CMD_ID_UPS_CONFIG:UInt8 = 0x31
    static let CMD_ID_SET_BEEP:UInt8 = 0x26
    static let CMD_ID_AC_OUT:UInt8 = 0x42
    static let CMD_ID_DC_CONFIG:UInt8 = 0x22
    static let CMD_ID_STAND_BY:UInt8 = 0x21
    static let CMD_ID_WORK_MODE:UInt8 = 0x41
    static let CMD_ID_GET_LCD_TIME:UInt8 = 0x28
    static let CMD_ID_GET_MPPT_MODE:UInt8 = 0x44
    static let CMD_ID_SET_LCD_TIME:UInt8 = 0x27
    static let CMD_ID_SET_MPPT_MODE:UInt8 = 0x43
    static let CMD_ID_SET_BATTERY:UInt8 = 0x62
    static let CMD_ID_GET_SYS_PARAMS:UInt8 = 0x01
    static let CMD_ID_GET_SYS_LOGS:UInt8 = 0x24
    
    static let ADDR_PD:UInt8 = 0x2
    static let ADDR_BMS_M:UInt8 = 0x3
    static let ADDR_BMS_S:UInt8 = 0x6
    static let ADDR_INV:UInt8 = 0x4
    static let ADDR_MPPT:UInt8 = 0x5
    private let HEADER_SIZE:Int = 16
    static let DEVICE_SN_LEN:Int = 16
    
    static let shareInstance = EFProtocol()//单例
    
    static private var buffer = [UInt8]()
    private var lock: Int = 0
    
    //传入参数是整个包，包括最后两个字节的CRC16
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
    
    private func clear() {
        //if EFProtocol.buffer.count > 2048 { EFProtocol.buffer.removeAll() }
    }
    
    func decode(data: [UInt8]) -> EFFrame? {
        
        objc_sync_enter(lock)
        let package = EFFrame()
        Debug.shared.println("开始解析收到的数据，长度:\(data.count)", tag: "batteryVal")
        var foundHeaderTag = false
        for d in data { EFProtocol.buffer.append(d) }
        for i in 0 ..< EFProtocol.buffer.count {
            guard i+4 < EFProtocol.buffer.count else {
                
                    //删除掉i之前的没用数据
                    var temp = [UInt8]()
                    for item in i..<EFProtocol.buffer.count {
                        temp.append(EFProtocol.buffer[item])
                    }
                    EFProtocol.buffer.removeAll()
                    EFProtocol.buffer = temp
                    
                
                objc_sync_exit(lock)
                return nil
            } //包括hdr_chk总共5字节的头校验
            if EFProtocol.buffer[i] == FRAME_SIG {
                Debug.shared.println("debug: global buff count:\(EFProtocol.buffer.count)", tag: "AC的值")
                foundHeaderTag = true
                if EFProtocol.buffer[i+4] == CRCCheck.shareInstance.checkCRC8(buf: [EFProtocol.buffer[i], EFProtocol.buffer[i+1], EFProtocol.buffer[i+2], EFProtocol.buffer[i+3]]) {
                    //找到了header
                    guard i+15 < EFProtocol.buffer.count else { //不完整包，等待下次接收
                        objc_sync_exit(lock)
                        return nil
                    }
                    package.sig = EFProtocol.buffer[i]
                    package.version = EFProtocol.buffer[i+1]
                    package.dataLen = UInt16(Int(EFProtocol.buffer[i+2])+Int(EFProtocol.buffer[i+3])*256)
                    package.hdrChk = EFProtocol.buffer[i+4]
                    package.args = EFProtocol.buffer[i+5]
                    package.frameSeq = UInt32(EFProtocol.buffer[i+6])
                    package.frameSeq += (UInt32(EFProtocol.buffer[i+7]) << 8)
                    package.frameSeq += (UInt32(EFProtocol.buffer[i+8]) << 16)
                    package.frameSeq += (UInt32(EFProtocol.buffer[i+9]) << 24)
                    package.product = UInt16(EFProtocol.buffer[i+10])
                    package.product += (UInt16(EFProtocol.buffer[i+11]) << 8)
                    package.srcAddr = EFProtocol.buffer[i+12]
                    package.destAddr = EFProtocol.buffer[i+13]
                    package.cmdSet = EFProtocol.buffer[i+14]
                    package.cmdID = EFProtocol.buffer[i+15]
                    
                    if package.version == PROTOCOL_V2 { //version check
                        let packLen: Int = HEADER_SIZE+Int(package.dataLen)+2 //2是CRC16长度
                        let remainLen: Int = EFProtocol.buffer.count-i-2 //减去2是减去最后CRC16长度
                        if Int(package.dataLen) > remainLen {
                            objc_sync_exit(lock)
                            return nil //不是一个完整的包，等下次decode
                        } else {
                            var packBuff = [UInt8]()
                            for j in i ..< i+packLen {
                                guard j < EFProtocol.buffer.count else {
                                    objc_sync_exit(lock)
                                    return nil //不是一个完整的包，等下次decode
                                }
                                packBuff.append(EFProtocol.buffer[j])
                            }
                            if verifyFrame(data: packBuff) { //frame CRC16，得到一个正确包
                                //Debug.shared.println("EFProtocol.buffer.count=\(EFProtocol.buffer.count)")
                                for j in i+HEADER_SIZE ..< i+HEADER_SIZE+Int(package.dataLen) {
                                    if j < EFProtocol.buffer.count {
                                        package.payload.append(EFProtocol.buffer[j])
                                    }
                                }
                                //删除这个包
                                var tempBuf = [UInt8]()
                                //Debug.shared.println("保存数据 \(i+packLen) to \(EFProtocol.buffer.count)")
                                //Debug.shared.println("保存数据 删除bytes：0~\(i+packLen-1)")
                                if i+packLen < EFProtocol.buffer.count {
                                    for j in i+packLen ..< EFProtocol.buffer.count {
                                        
                                        
                                            tempBuf.append(EFProtocol.buffer[j])
                                        
                                        
                                        
                                    }
                                }
                                EFProtocol.buffer.removeAll()
                                //Debug.shared.println("保存数据: remove \(EFProtocol.buffer.count)")
                                for d in tempBuf { EFProtocol.buffer.append(d) }
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
        
        //clear()
        Debug.shared.println("remain len:\(EFProtocol.buffer.count)", tag: "batteryVal")
        return package
    }
    
    func encode(cmdSet: UInt8, cmdID: UInt8, product: UInt16, data: [UInt8], destAddr: UInt8) -> [UInt8] {
        var frame = [UInt8]()
        frame.append(FRAME_SIG)
        frame.append(PROTOCOL_V2)
        frame.append(UInt8(data.count & 0xFF)) //数据长度
        frame.append(UInt8((data.count & 0xFF00) >> 8))
        frame.append(CRCCheck.shareInstance.checkCRC8(buf: frame)) //头校验
        
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
        
        frame.append(SERV_ADDR) //SERV_ADDR
        frame.append(destAddr) //dest_addr
        frame.append(cmdSet) //cmd set
        frame.append(cmdID) //cmd ID
        
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
    
    func generateCommand(type: EFCommands, cmdData: [UInt8]=[0x0], product: UInt16=0xFFFF) -> [UInt8] {
        //只有获取SN的命令集是0x01，其他控制命令的命令集是CMD_SET_IOT_SERVER=0x20
        switch type {
        case .getSN:
            let dat: [UInt8] = [0x0]
            return encode(cmdSet: EFProtocol.CMD_SET_COMMON, cmdID: EFProtocol.CMD_ID_GET_SN, product: 0xFFFF, data: dat,  destAddr: EFProtocol.ADDR_PD)
        case .setLED:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_LED_CONFIG, product: product, data: cmdData, destAddr: EFProtocol.ADDR_PD)
        case .getStatus:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_STATUS_PUSH, product: product, data: cmdData, destAddr: EFProtocol.ADDR_PD)
        case .setLEDMode:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_AMBIENT_LIGHT, product: product, data: cmdData, destAddr: EFProtocol.ADDR_BMS_S)
        case .setMaxChgSoc:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_UPS_CONFIG, product: product, data: cmdData, destAddr: EFProtocol.ADDR_BMS_M)
        case .setBeep:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_SET_BEEP, product: product, data: cmdData, destAddr: EFProtocol.ADDR_PD)
        case .setAC:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_AC_OUT, product: product, data: cmdData, destAddr: EFProtocol.ADDR_INV)
        case .setDC:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_DC_CONFIG, product: product, data: cmdData, destAddr: EFProtocol.ADDR_PD)
        case .setOutFreq:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_AC_OUT, product: product, data: cmdData, destAddr: EFProtocol.ADDR_INV)
        case .setXboost:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_AC_OUT, product: product, data: cmdData, destAddr: EFProtocol.ADDR_INV)
        case .setMoodLight:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_AMBIENT_LIGHT, product: product, data: cmdData, destAddr: EFProtocol.ADDR_BMS_S)
        case .setLEDColor:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_AMBIENT_LIGHT, product: product, data: cmdData, destAddr: EFProtocol.ADDR_BMS_S)
        case .setBrightness:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_AMBIENT_LIGHT, product: product, data: cmdData, destAddr: EFProtocol.ADDR_BMS_S)
        case .setStandby:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_STAND_BY, product: product, data: cmdData, destAddr: EFProtocol.ADDR_PD)
        case .setWorkMode:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_WORK_MODE, product: product, data: cmdData, destAddr: EFProtocol.ADDR_INV)
        case .getWorkMode:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_GET_MPPT_MODE, product: product, data: cmdData, destAddr: EFProtocol.ADDR_INV)
        case .resetDevice:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_SYS_RESET, product: product, data: cmdData, destAddr: EFProtocol.ADDR_PD)
        case .getInvStatus:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_STATUS_PUSH, product: product, data: cmdData, destAddr: EFProtocol.ADDR_INV)
        case .getBMSSlaveStatus:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_STATUS_PUSH, product: product, data: cmdData, destAddr: EFProtocol.ADDR_BMS_S)
        case .getBMSMasterStatus:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_STATUS_PUSH, product: product, data: cmdData, destAddr: EFProtocol.ADDR_BMS_M)
        case .getMpptStatus:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_STATUS_PUSH, product: product, data: cmdData, destAddr: EFProtocol.ADDR_MPPT)
        case .setLcdStandbyTime:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_SET_LCD_TIME, product: product, data: cmdData, destAddr: EFProtocol.ADDR_PD)
        case .setMPPT:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_SET_MPPT_MODE, product: product, data: cmdData, destAddr: EFProtocol.ADDR_INV)
        case .getLcdStandbyTime:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_GET_LCD_TIME, product: product, data: cmdData, destAddr: EFProtocol.ADDR_PD)
        case .getPDSysParams:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_GET_SYS_PARAMS, product: product, data: cmdData, destAddr: EFProtocol.ADDR_PD)
        case .getInvSysParams:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_GET_SYS_PARAMS, product: product, data: cmdData, destAddr: EFProtocol.ADDR_INV)
        case .getBmsSlaveSysParams:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_GET_SYS_PARAMS, product: product, data: cmdData, destAddr: EFProtocol.ADDR_BMS_S)
        case .getBmsMasterSysParams:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_GET_SYS_PARAMS, product: product, data: cmdData, destAddr: EFProtocol.ADDR_BMS_M)
        case .getSystemLogs:
            return encode(cmdSet: EFProtocol.CMD_SET_IOT_SERVER, cmdID: EFProtocol.CMD_ID_GET_SYS_LOGS, product: product, data: cmdData, destAddr: EFProtocol.ADDR_PD)
        }
        //return [UInt8]()
    }
    
    func decrypt(frame: EFFrame) -> [UInt8] { //数据包data部分解密
        let ctrl = frame.args
        var decryptArray = [UInt8]()
        if ((ctrl >> 5) & 0x11) == 0x01 { //decrypt
            let decoder = UInt8(frame.frameSeq & 0xFF)
            for d in frame.payload {
                let d0 = d ^ decoder
                decryptArray.append(d0)
            }
        } else {
            for d in frame.payload { decryptArray.append(d) }
        }
        return decryptArray
    }
    
    func productTypeToProduct(type: UInt8) -> UInt16 { //productType转换为product值
        var product: UInt16 = 0
//        if type == 5 {
//            product = ((1 << 8) | 1)
//        } else if type > 6 && type < 10 {
//            product = (1 << 8) | 2
//        } else if type == 10 {
//            product = (1 << 8) | 3
//        }
        return product
    }
    
    /**
     struct param_item{
         uint8_t name_length;        //参数名称长度
         uint8_t value_type;         //参数值类型
         uint32_t value;             //参数值
         uint8_t param_name[];       //参数名称
     };
      //获取系统参数表
     struct sys_params{
         uint16_t    count;      //参数数量
         param_item  params[];   //参数列表
     };
     */
    func parseSystemParams(data: [UInt8]) -> [SystemParamsModel] {
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
    
    /**
     struct log_item{
         uint32_t    timestamp;      //时间戳
         uint8_t     level;          //0 message, 1 warning, 2 error, 3 debug
         uint8_t     msg_type;       //信息类别，详细见下文列表
         uint32_t    err_code;
     };
      //获取设备缓存记录的最近10条信息
     struct sys_logs{
         uint16_t    count;      //有效日志数量，最大20条
         log_item    items[];    //日志内容
     };
     */
    func parseDeviceLogs(data: [UInt8]) -> [DeviceEventModel] {
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
    
    func cleanBuffer() {
        //EFProtocol.buffer.removeAll()
    }
}

