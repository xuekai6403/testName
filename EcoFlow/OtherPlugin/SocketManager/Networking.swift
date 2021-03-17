//
//  Networking.swift
//  EcoFlow
//
//  Created by apple on 2020/5/19.
//  Copyright © 2020 wangwei. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import Reachability

class Networking {
    
    static var online: Bool = true
    static var reachability = try! Reachability()
    //开启网络监听
    static func monitorNetwork(){
        //reachability = try Reachability.reachabilityForInternetConnection()
        reachability.whenReachable = { reachability in
            //            self.netWorkIsAvailable = true
            // 判断网络状态及类型
            online = true
            print("网络可用")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NOTIF_NAME_NETWORK_STAT_CHANGED), object: nil)
        }
        
        // 网络不可用时执行
        reachability.whenUnreachable = { reachability in
            //            self.netWorkIsAvailable = false
            // 判断网络状态及类型
            online = false
            print("网络不可用")
//            UIApplication.shared.keyWindow?.makeToast(LanguageHelper.shareInstance.getAppStr("NoNetwork", comment: ""), duration: 3.0, position: .center)
        }
        
        do {
            // 开始监听
            try reachability.startNotifier()
        } catch {
            print("AppDelegate:Unable to start notifier")
        }
    }
    
    static func getWiFiName() -> String? { //获取wifi SSID
        var ssid: String?
        /*if !Networking.isWifiEnable() {
            return ssid
        }*/
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    //print(ssid)
                    let bssid = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String ?? "Nil"
                    print(bssid)
                    break
                }
            }
        }
        return ssid

    }
    
    static public var ipAddress: String {
        var information = [String:[String]]()
        var ifaddr:UnsafeMutablePointer<ifaddrs>? = nil
        //retrieve the current interface -- return 0 on success
        guard getifaddrs(&ifaddr) == 0 else { return "0.0.0.0" }
        
        var interface = ifaddr
        //loop through linked list of interface
        while interface != nil {
            let flags = Int32(interface!.pointee.ifa_flags)
            var addr = interface!.pointee.ifa_addr.pointee
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        if let _ = String(validatingUTF8:hostname) {
                            //addresses.append(address)
                            var mask = interface!.pointee.ifa_netmask.pointee
                            var netmaskName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            getnameinfo(&mask, socklen_t(mask.sa_len), &netmaskName, socklen_t(netmaskName.count), nil, socklen_t(0), NI_NUMERICHOST)
                            let netMask = String(validatingUTF8: netmaskName)
                            guard let ds = interface?.pointee.ifa_dstaddr else {
                                return "0.0.0.0"
                            }
                            var bc = ds.pointee
                            var broadcastName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            getnameinfo(&bc, socklen_t(bc.sa_len), &broadcastName, socklen_t(broadcastName.count), nil, socklen_t(0), NI_NUMERICHOST)
                            let interfaceBroadcast = String(validatingUTF8: broadcastName)

                            information[String(cString: interface!.pointee.ifa_name)] = [String(validatingUTF8:hostname)!, netMask!, interfaceBroadcast!]
                        }
                    }
                }
            }
            interface = interface!.pointee.ifa_next
        }
        freeifaddrs(ifaddr)
        if information["en0"] == nil {
            return "0.0.0.0"
        }
        return information["en0"]![0]
    }
    //是否处于热点模式
    static public  var isHotspotMode: Bool {
        if ipAddress.contains("192.168.4.") {
            return true
        }
        return false
    }
}
