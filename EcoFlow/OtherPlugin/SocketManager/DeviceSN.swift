//
//  DeviceSN.swift
//  EcoFlow
//
//  Created by apple on 2020/5/20.
//  Copyright © 2020 wangwei. All rights reserved.
//

import Foundation

class DeviceSN : NSObject, NSCoding {
    var res0: [UInt8] = [0x0, 0x0, 0x0, 0x0]
    var productType: UInt8 = 0x0
    var res1: [UInt8] = [0x0, 0x0]
    var model: UInt8 = 0x0
    var sn: [UInt8] = [
        0x0, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0,
    ]
    var res2: [UInt8] = [
        0x0, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0,
    ]
    
    init(dic:NSDictionary) {
        /*self.res0 = dic["res0"] as! Int
        self.heat = dic["heat"] as! Int
        self.motor = dic["motor"] as! Int
        self.shake = dic["shake"] as! Int
        self.power = dic["power"] as! Int
        self.temp = dic["temp"] as! Int*/
    }
    
    init(data: [UInt8]) {
        guard data.count == 36 else { return }
        productType = data[4]
        model = data[7]
        for i in 0 ..< EFProtocol.DEVICE_SN_LEN {
            sn[i] = data[8+i]
        }
    }
    
    func encode(with aCoder: NSCoder) {
        /*aCoder.encode(self.res0, forKey: "res0")
        aCoder.encode(self.productType, forKey: "productType")
        aCoder.encode(self.res1, forKey: "res1")
        aCoder.encode(self.model, forKey: "model")
        aCoder.encode(self.sn, forKey: "sn")
        aCoder.encode(self.res2, forKey: "res2")*/
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        /*self.spray = Int(aDecoder.decodeInt32(forKey: "spray"))
        self.heat = Int(aDecoder.decodeInt32(forKey: "heat"))
        self.motor = Int(aDecoder.decodeInt32(forKey: "motor"))
        self.shake = Int(aDecoder.decodeInt32(forKey: "shake"))
        self.power = Int(aDecoder.decodeInt32(forKey: "power"))
        self.res2 = Int(aDecoder.decodeData()(forKey: "res2"))*/
    }
    
    func snToString() -> String {
        if let str = String(bytes: sn, encoding: .utf8) {
//            if str.last == "\0" { return str[0 ..< 15] }
            return str
        }
        return "x"
    }
}
