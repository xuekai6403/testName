//
//  Constants.swift
//  EcoFlow
//
//  Created by apple on 2020/5/14.
//  Copyright © 2020 wangwei. All rights reserved.
//

import Foundation
import UIKit

enum URL_API {
    case register
    case login
    case getDeviceList
    case getDeviceData
    case devicesUsage
    case getDeviceEvents
    case bindDevice
    case unbindDevice
    case resetDevice
    case queryDeviceStatus
    case getLatestPackInfo
    case upgradeDevice
    case abortUpgrade
    case getDeviceParams
    case configDevice
    case resetPassword
    case sendAgain
    case getPermissions
    case setPermission
    case parseMsgId
    case getFeedback
    case editFeedback
    case feedbackNotifications
    case getPushList
    case setUserLanguage
    case setUserInfo
    case getUserInfo
    case clearUpgradeResult
    case sendPhoneCode
    case getNewAPPVersion
    case resetPWD
    case checkAccount
}

enum LOCAL_DATA {
    case firstRun
    case userModel
    case language
    case naviBarHeight
    case tempUnit
    case httpToken
    case loginType // 0:国内版登录 1:国际版登录
    case permission
    case access_token
    case wifi_data
    case locationAlert
}

struct Constants {
    static let defBackColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
    static let userHeadColor = UIColor(red: 19, green: 205, blue: 205, alpha: 1)
    static let themeColor = UIColor(hex: 0x34AFB0)
    static let lightGrayColor = UIColor(hex: 0xE0E0E0)
    static let feedbackHightlightColor = UIColor(hex: 0xA0F0A0)
    static let DEF_ROW_HEIGHT:CGFloat = 52
    static let textFontSize:CGFloat = 14
    static let titleFontSize:CGFloat = 16
    static let TCP_PORT:UInt16 = 8055
    static let UDP_PORT:UInt16 = 6099
    static let TCPCLIENT_PORT: UInt16 = 6500
    static let TCPCLIENT_HOST = "iot1.ecoflow.com"
    static let HTTP_SERVER_PORT:UInt16 = 443//8081 8086 443
    static let COMPANY_WEBSITE:String = "https://www.ecoflow.com"
    static let SUPPORT_EMAIL = "mailto:support@ecoflow.com"
    
    static let UNIVERSAL_LINK = "https://iot1.ecoflow.com/china"
    static let BUILD_CODE: String = "1"
    static let KEYCHAIN_SERVICE_NAME = "com.ecoflow.app"
    static let KEY_KEYCHAIN_USER_IDENTIFIER = "userIdentifier"
    static let KEY_KEYCHAIN_USER_EMAIL = "userEmail"
    static let KEY_KEYCHAIN_USER_FAMILY_NAME = "userFamilyName"
    static let KEY_KEYCHAIN_APPLE_TOKEN = "appleToken"
    static let KEY_KEYCHAIN_AUTH_CODE = "appleAuthCode"
    
    static let ECOFLOW_URL = "https://iot1.ecoflow.com"//"http://iot.ecoflow.com" http://10.10.20.133
    static let ESP_HTTP_SERVER_IP = "http://192.168.4.1"
    static let APPSTORE_APPID = "1506693140"
    
    //Api
    static let URL_PATH_DEVICE_STATUS = "/api/v1/devices/getDeviceStatus"
    static let URL_PATH_SIGNUP = "/api/v1/register"
    static let URL_PATH_LOGIN = "/api/v1/login"
    static let URL_PATH_GET_DEVICE_LIST = "/api/v1/users/devices"
    static let URL_PATH_GET_DEVICE_DATA = "/api/v1/devices/getDeviceData"
    static let URL_PATH_DEVICES_USAGE = "/api/v1/devices/getDevicesUsage"
    static let URL_PATH_GET_DEVICE_EVENTS = "/api/getDeviceEvents"
    static let URL_PATH_BIND_DEVICE = "/api/v1/devices/bindDevice"
    static let URL_PATH_UNBIND_DEVICE = "/api/v1/devices/unbindDevice"
    static let URL_PATH_RESET_DEVICE = "/api/v1/devices/resetDevice"
    static let URL_PATH_QUERY_DEVICE_STATUS = "/api/v1/devices/getDeviceStatus"
    static let URL_PATH_GET_LATEST_PACK_INFO = "/api/v1/devices/getLatestPackInfo"
    static let URL_PATH_UPGRADE_DEVICE = "/api/v1/devices/upgradeDevice"
    static let URL_PATH_ABORT_UPGRADE = "/api/v1/devices/abortUpgrade"
    static let URL_PATH_GET_DEVICE_PARAMS = "/api/v1/devices/getDeviceParams"
    static let URL_PATH_CONFIG_DEVICE = "/api/v1/devices/configDevice"
    static let URL_PATH_RESET_PASSWORD = "/api/resetPassword"
    static let URL_PATH_SEND_AGAIN = "/api/sendActivateMail"
    static let URL_PATH_GET_PERMISSIONS = "/api/v1/users/getPermissions"
    static let URL_PATH_SET_PERMISSION = "/api/v1/users/setPermission"
    static let URL_PATH_GET_FEEDBACK = "/api/v1/feedbacks"
    static let URL_PATH_EDIT_FEEDBACK = "/api/v1/feedbacks/editFeedback"
    static let URL_PATH_FEEDBACK_NOTIFICATIONS = "/api/notifications/notifications"
    static let URL_PATH_GET_PUSH_LIST = "/api/v1/users/pushOptions"
    static let URL_PATH_SET_USER_LANGUAGE = "/api/v1/users/setting"
    static let URL_PATH_SET_USER_INFO = "/api/v1/users/setInfo"
    static let URL_PATH_GET_USER_INFO = "/api/v1/users/getInfo"
    static let URL_PATH_CLEAR_UPGRADERESULT = "/api/v1/devices/clearDeviceUpgradeResultFlag"
    static let URL_PATH_SEND_PHONECODE = "/api/v1/verificationCode/send"
    static let URL_PATH_GET_NEWESTAPPVERSION = "/api/v1/apps/getLatestVersion"
    static let URL_PATH_RESET_PWD = "/api/v1/resetPassword"
    static let URL_PATH_CHECK_ACCOUNT = "/api/v1/users/checkAccount"
    static let URL_PARSE_MESSAGE_ID = "\(ECOFLOW_URL):\(HTTP_SERVER_PORT)/api/v1/systems/messageDefs"
    
    //隐私政策，facebook，ins，youtube，twitter链接，联系邮箱,EF对应国家官网
    static let URL_TERMS_OF_USE = "https://ecoflow.com/pages/terms-of-use"
    static let URL_PRIVACY_POLICY = "https://ecoflow.com/pages/privacy-policy"
    static let JA_URL_TERMS_OF_USE = "https://jp.ecoflow.com/pages/terms-of-use"
    static let JA_URL_PRIVACY_POLICY = "https://jp.ecoflow.com/pages/privacy-policy"
    static let URL_FACEBOOK = "https://www.facebook.com/groups/741761226597628"
    static let URL_INS = "https://www.linkedin.com/company/ecoflowtech"
    static let URL_TWITTER = "https://twitter.com/EcoFlowTech"
    static let URL_YOUTUBE = "https://www.youtube.com/channel/UCk8Zk8tUAwBN_NKkORh4q2Q"
    static let JA_URL_FACEBOOK = "https://www.facebook.com/ecoflowjapan/"
    static let JA_URL_INS = "https://www.instagram.com/ecoflowtech_jp/"
    static let JA_URL_TWITTER = "https://twitter.com/EcoflowJapan"
    static let JA_URL_YOUTUBE = "https://www.youtube.com/channel/UCup-8KjYcdzZf6iP583Q5FQ"
    static let JA_EFEMAIL = "support.jp@ecoflow.com"
    static let EF_EMAIL = "support@ecoflow.com"
    static let EN_WEBSITE = "https://www.ecoflow.com"
    static let ZH_WEBSITE = "https://cn.ecoflow.com"
    static let JA_WEBSITE = "https://jp.ecoflow.com"
    
    
    //本地存储KEY
    static let KEY_USER_MODEL = "KeyUserModel"
    static let KEY_USER_LANGUAGE = "AppLanguage"
    static let KEY_SYSTEM_LANGUAGE = "SystemLanguage"
    static let KEY_FIRST_RUN = "KeyFirstRun"
    static let KEY_TEMP_UNIT = "KeyTempUnit"
    static let KEY_HTTP_TOKEN = "KeyHttpToken"
    static let KEY_MSG_PARSE_INFO = "KeyMsgParseInfo"
    static let KEY_LOGIN_TYPE = "loginType"
    static let KEY_PERMISSION = "permission"
    static let KEY_ACCESSTOKEN = "access_token"
    static let KEY_WIFIDATA = "wifi_data"
    static let KEY_LOCATION_ALERT = "locationAlert"
    
    //通知name
    static let NOTIF_NAME_FB_CHECK_TOKEN = "NotifFBTokenCheck"
    static let NOTIF_NAME_REFRESH_DEVICE_STAT = "NotifRefreshDeviceStat"
    static let NOTIF_NAME_DELAY_HEARTBEAT = "NotifDelayHeartbeat"
    static let NOTIF_NAME_REFRESH_LCD_MPPT = "NotifRefreshLCDMPPT"
    static let NOTIF_NAME_NETWORK_STAT_CHANGED = "InternetStatChanged"
    static let NOTIF_NAME_DEVICE_STAT_CHANGED = "DeviceStatChanged"
    static let NOTIF_NAME_WECHAT_LOGIN = "WechatLogin"
    
    //现在有八种颜色可选，['#9E2CFF', '#2C55FF', '#2CFFEF', '#66F726', '#FFEB00', '#FF7926', '#FF2C2C', '#EEEEEE']，分别对应那8个圆点
    static let COLOR_ARRAY:[UIColor] = [UIColor(hex: 0x9E2CFF), UIColor(hex: 0x2C55FF), UIColor(hex: 0x2CFFEF), UIColor(hex: 0x66F726), UIColor(hex: 0xFFEB00), UIColor(hex: 0xFF7926), UIColor(hex: 0xFF2C2C), UIColor(hex: 0xEEEEEE)]
    static let COLOR_HEX:[UInt32] = [0x00FF2C9E, 0x00FF552C, 0x00EFFF2C, 0x0026F766, 0x0000EBFF, 0x002679FF, 0x002C2CFF, 0x00EEEEEE]
    /*
     productType:[model:["name":"","img:""]]
     procuctType:产品大类
     model：型号
     **/
    static let EF_MODEL_LIST = [
        "5":[
            "1":["name":"RIVER 600","img":"river_600"],
            "2":["name":"RIVER 600 MAX","img":"river_max"]
        ],
        "7":[
            "3":["name":"RIVER 600 PRO","img":"r600pro"],
            "4":["name":"RIVER 600 PRO with Extra Battery","img":"1500"],
            "5":["name":"RIVER 600 PRO with Prokit","img":"prokit"]
        ],
        "12":[
            "1":["name":"RIVER 600 PRO LI","img":"r600pro"],
            "2":["name":"RIVER 600 PRO LI with Extra Battery","img":"river_pro"],
        ],
        "13":[
            "1":["name":"DELTA 2000","img":"delta_2000"],
        ],
        "14":[
            "1":["name":"DELTA 3000","img":"delta_3000"],
        ],
        "15":[
            "1":["name":"DELTA MINI","img":"river_600"],
        ],

    ]
    
    static let LANGUAGES = [
        LanguageHelper.shareInstance.getUserStr(key: "FollowLanguage"),
        "English",
        "简体中文",
        "日本語"
    ]
    //加载本地化语言文件
    static let LANGUAGE_SHORT_NAME = [Constants.KEY_SYSTEM_LANGUAGE,"en", "zh-Hans", "ja"]
    //网络请求语言标签lang
    static let HTTP_LANG_TAG = ["en-US","en-US","zh-CN","ja-JP"]
    //
    static let LANGUAGE_ARR = ["sys","en","zh","ja"]
    static let LCD_STANDBY_TIME_VALUES = [LanguageHelper.shareInstance.getAppStr("Str10Sec", comment: ""), LanguageHelper.shareInstance.getAppStr("Str30Sec", comment: ""), LanguageHelper.shareInstance.getAppStr("Str1Min", comment: ""), LanguageHelper.shareInstance.getAppStr("Str5Min", comment: ""), LanguageHelper.shareInstance.getAppStr("Str30Min", comment: ""), LanguageHelper.shareInstance.getAppStr("Never", comment: "")]
    static let LCD_STANDBY_TIME:[Int] = [10, 30, 60, 300, 1800, 0] //秒
    
    static func GET_APP_VERSION() -> String { //获取App版本号
        let infoDictionary = Bundle.main.infoDictionary!
        let minorVersion:String = infoDictionary["CFBundleShortVersionString"] as! String
        return minorVersion
    }
    static func GET_IOS_VERSION() -> String {
        let ver: NSString = UIDevice.current.systemVersion as NSString
        return ver as String
    }
    static func GET_APP_BUILD_NUM() -> String { //获取bundle build
        if let infoDictionary = Bundle.main.infoDictionary, let buildNum = infoDictionary["CFBundleVersion"] as? String {
            return buildNum
        }
        return "0"
    }
    
    static func GET_API_URL(type: URL_API) -> String {
        var url = ECOFLOW_URL+":"+String(HTTP_SERVER_PORT)
        switch type {
        case .register:
            url += URL_PATH_SIGNUP
            break
        case .login:
            url += URL_PATH_LOGIN
            break
        case .getDeviceList:
            url += URL_PATH_GET_DEVICE_LIST
            break
        case .getDeviceData:
            url += URL_PATH_GET_DEVICE_DATA
            break
        case .devicesUsage:
            url += URL_PATH_DEVICES_USAGE
            break
        case .getDeviceEvents:
            url += URL_PATH_GET_DEVICE_EVENTS
            break
        case .bindDevice:
            url += URL_PATH_BIND_DEVICE
            break
        case .unbindDevice:
            url += URL_PATH_UNBIND_DEVICE
            break
        case .resetDevice:
            url += URL_PATH_RESET_DEVICE
            break
        case .queryDeviceStatus:
            url += URL_PATH_QUERY_DEVICE_STATUS
            break
        case .getLatestPackInfo:
            url += URL_PATH_GET_LATEST_PACK_INFO
            break
        case .upgradeDevice:
            url += URL_PATH_UPGRADE_DEVICE
            break
        case .abortUpgrade:
            url += URL_PATH_ABORT_UPGRADE
            break
        case .getDeviceParams:
            url += URL_PATH_GET_DEVICE_PARAMS
            break
        case .configDevice:
            url += URL_PATH_CONFIG_DEVICE
            break
        case .resetPassword:
            url += URL_PATH_RESET_PASSWORD
            break
        case .sendAgain:
            url += URL_PATH_SEND_AGAIN
            break
        case .getPermissions:
            url += URL_PATH_GET_PERMISSIONS
            break
        case .setPermission:
            url += URL_PATH_SET_PERMISSION
            break
        case .parseMsgId:
            return URL_PARSE_MESSAGE_ID //参数lang=en,cn,jp
        case .getFeedback:
            url += URL_PATH_GET_FEEDBACK
            break
        case .editFeedback:
            url += URL_PATH_EDIT_FEEDBACK
            break
        case .feedbackNotifications:
            url += URL_PATH_FEEDBACK_NOTIFICATIONS
            break
        case .getPushList:
            url += URL_PATH_GET_PUSH_LIST
            break
        case .setUserLanguage:
            url += URL_PATH_SET_USER_LANGUAGE
            break
        case .setUserInfo:
            url += URL_PATH_SET_USER_INFO
            break
        case .getUserInfo:
            url += URL_PATH_GET_USER_INFO
            break
        case .clearUpgradeResult:
            url += URL_PATH_CLEAR_UPGRADERESULT
            break
        case .sendPhoneCode:
            url += URL_PATH_SEND_PHONECODE
            break
        case .getNewAPPVersion:
            url += URL_PATH_GET_NEWESTAPPVERSION
            break
        case .resetPWD:
            url += URL_PATH_RESET_PWD
            break
        case .checkAccount:
            url += URL_PATH_CHECK_ACCOUNT
        }
        return url
    }
    
    static func GET_LOCAL_DATA(type: LOCAL_DATA) -> AnyObject? {
        switch type {
        case .firstRun:
            guard let ret = Utils.getNormalDefult(key: GET_DATA_KEY(type: type)) else { return nil }
            return ret
        case .userModel:
            if Globals.gUserModel != nil {
                return Globals.gUserModel
                
            }
            let dat = Utils.getNormalDefult(key: GET_DATA_KEY(type: type))
            if dat is NSNull { return nil }
            if #available(iOS 12.0, *) {
                do {
                    if let model = try NSKeyedUnarchiver.unarchivedObject(ofClass: UserModel.self, from: dat as! Data) {
                        Globals.gUserModel = model
                        return model
                    }
                } catch {
                    print("unarchivedObject exception")
                }
            } else {
                if let model = NSKeyedUnarchiver.unarchiveObject(with: dat as! Data) as? UserModel {
                    Globals.gUserModel = model
                    return model
                }
            }
            break
        case .language:
            return Utils.getAppLanguage() as AnyObject
        case .naviBarHeight:
            var offset:CGFloat = 68
            if Utils.isIPhoneX() { offset = 90 }
            return offset as AnyObject
        case .tempUnit: //摄氏度返回“C”，华氏度返回“F”，默认保存摄氏度
            let dat = Utils.getNormalDefult(key: GET_DATA_KEY(type: .tempUnit))
            if dat == nil || dat is NSNull {
                Utils.setNormalDefault(key: GET_DATA_KEY(type: type), value: "C" as AnyObject)
                return "C" as AnyObject
            }
            return dat
        case .httpToken:
            let dat = Utils.getNormalDefult(key: GET_DATA_KEY(type: .httpToken))
            return dat as AnyObject
        case .loginType:
            let dat = Utils.getNormalDefult(key: GET_DATA_KEY(type: .loginType))
            return dat as AnyObject
        case .permission:
            let dat = Utils.getNormalDefult(key: GET_DATA_KEY(type: .permission))
            return dat as AnyObject
        case .access_token:
            let dat = Utils.getNormalDefult(key: GET_DATA_KEY(type: .access_token))
            return dat as AnyObject
        case .wifi_data:
            let dat = Utils.getNormalDefult(key: GET_DATA_KEY(type: .wifi_data))
            return dat as AnyObject
        case .locationAlert:
            let dat = Utils.getNormalDefult(key: GET_DATA_KEY(type: .locationAlert))
            return dat as AnyObject
        }
        return nil
    }
    
    static func SET_LOCAL_DATA(type: LOCAL_DATA, data: AnyObject) {
        switch type {
        case .firstRun:
            Utils.setNormalDefault(key: GET_DATA_KEY(type: type), value: data as AnyObject)
            break
        case .userModel:
            if #available(iOS 12.0, *) {
                do {
                    let dat = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
                    Utils.setNormalDefault(key: GET_DATA_KEY(type: type), value: dat as AnyObject)
                } catch {
                    print("archivedData exception")
                }
            } else {
                let dat = NSKeyedArchiver.archivedData(withRootObject: data) as NSData
                Utils.setNormalDefault(key: GET_DATA_KEY(type: type), value: dat)
            }
            if let model = data as? UserModel { //同时修改全局 UserModel
                Globals.gUserModel = model
            }
            break
        case .language:
            Utils.setAppLanguage(data as! Int)
            break
        case .naviBarHeight:
            //do nothing
            break
        case .tempUnit:
            Utils.setNormalDefault(key: GET_DATA_KEY(type: type), value: data)
            break
        case .httpToken:
            Utils.setNormalDefault(key: GET_DATA_KEY(type: .httpToken), value: data)
            break
        case .loginType:
            Utils.setNormalDefault(key: GET_DATA_KEY(type: .loginType), value: data)
            break
        case .permission:
            Utils.setNormalDefault(key: GET_DATA_KEY(type: .permission), value: data)
            break
        case .access_token:
            Utils.setNormalDefault(key: GET_DATA_KEY(type: .access_token), value: data)
            break
        case .wifi_data:
            Utils.setNormalDefault(key: GET_DATA_KEY(type: .wifi_data), value: data)
            break
        case .locationAlert:
            Utils.setNormalDefault(key: GET_DATA_KEY(type: .locationAlert), value: data)
        }
    }
    static private func GET_DATA_KEY(type: LOCAL_DATA) -> String {
        switch type {
        case .firstRun:
            return KEY_FIRST_RUN
        case .userModel:
            return KEY_USER_MODEL
        case .language:
            return KEY_USER_LANGUAGE
        case .naviBarHeight:
            return ""
        case .tempUnit:
            return KEY_TEMP_UNIT
        case .httpToken:
            return KEY_HTTP_TOKEN
        case .loginType:
            return KEY_LOGIN_TYPE
        case .permission:
            return KEY_PERMISSION
        case .access_token:
            return KEY_ACCESSTOKEN
        case .wifi_data:
            return KEY_WIFIDATA
        case .locationAlert:
            return KEY_LOCATION_ALERT
        }
    }
    
}

extension UIColor {
    
    /// SwifterSwift: https://github.com/SwifterSwift/SwifterSwift
    /// Hexadecimal value string (read-only).
    public var hexString: String {
        let components: [Int] = {
            let c = cgColor.components!
            let components = c.count == 4 ? c : [c[0], c[0], c[0], c[1]]
            return components.map { Int($0 * 255.0) }
        }()
        return String(format: "#%02X%02X%02X", components[0], components[1], components[2])
    }
    
    /// SwifterSwift: https://github.com/SwifterSwift/SwifterSwift
    /// Short hexadecimal value string (read-only, if applicable).
    public var shortHexString: String? {
        let string = hexString.replacingOccurrences(of: "#", with: "")
        let chrs = Array(string)
        guard chrs[0] == chrs[1], chrs[2] == chrs[3], chrs[4] == chrs[5] else { return nil }
        return "#\(chrs[0])\(chrs[2])\(chrs[4])"
    }
    
    /// Color to Image
    func toImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect:CGRect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        self.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image! // was image
    }
    
    /// SwifterSwift: https://github.com/SwifterSwift/SwifterSwift
    /// RGB components for a Color (between 0 and 255).
    ///
    ///        UIColor.red.rgbComponents.red -> 255
    ///        UIColor.green.rgbComponents.green -> 255
    ///        UIColor.blue.rgbComponents.blue -> 255
    ///
    public var rgbComponents: (red: Int, green: Int, blue: Int) {
        var components: [CGFloat] {
            let c = cgColor.components!
            if c.count == 4 {
                return c
            }
            return [c[0], c[0], c[0], c[1]]
        }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return (red: Int(r * 255.0), green: Int(g * 255.0), blue: Int(b * 255.0))
    }
    
    /// SwifterSwift: https://github.com/SwifterSwift/SwifterSwift
    /// RGB components for a Color represented as CGFloat numbers (between 0 and 1)
    ///
    ///        UIColor.red.rgbComponents.red -> 1.0
    ///        UIColor.green.rgbComponents.green -> 1.0
    ///        UIColor.blue.rgbComponents.blue -> 1.0
    ///
    public var cgFloatComponents: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var components: [CGFloat] {
            let c = cgColor.components!
            if c.count == 4 {
                return c
            }
            return [c[0], c[0], c[0], c[1]]
        }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return (red: r, green: g, blue: b)
    }
    
    /// SwifterSwift: https://github.com/SwifterSwift/SwifterSwift
    /// Get components of hue, saturation, and brightness, and alpha (read-only).
    public var hsbaComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0.0
        var s: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (hue: h, saturation: s, brightness: b, alpha: a)
    }
    
    /// Random color.
    public static var random: UIColor {
        let r = Int(arc4random_uniform(255))
        let g = Int(arc4random_uniform(255))
        let b = Int(arc4random_uniform(255))
        return UIColor(red: r, green: g, blue: b)
    }
}

// MARK: - Initializers
public extension UIColor {
    
    convenience init(hex: Int, alpha: CGFloat) {
        let r = CGFloat((hex & 0xFF0000) >> 16)/255
        let g = CGFloat((hex & 0xFF00) >> 8)/255
        let b = CGFloat(hex & 0xFF)/255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    /**
     Creates an UIColor from HEX String in "#363636" format
     
     - parameter hexString: HEX String in "#363636" format
     - returns: UIColor from HexString
     */
    convenience init(hexString: String) {
        
        let hexString: String       = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner                 = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    /// Create UIColor from RGB values with optional transparency.
    ///
    /// - Parameters:
    ///   - red: red component.
    ///   - green: green component.
    ///   - blue: blue component.
    ///   - transparency: optional transparency value (default is 1)
    public convenience init(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        var trans: CGFloat {
            if transparency > 1 {
                return 1
            } else if transparency < 0 {
                return 0
            } else {
                return transparency
            }
        }
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }
}
