//
//  Utils.swift
//  EcoFlow
//
//  Created by apple on 2020/5/15.
//  Copyright © 2020 wangwei. All rights reserved.
//

import Foundation
import UIKit
enum permissionType: String {
    case debugFirmware = "debugFirmware"
    case debugParams = "debugParams"
    case debugDeviceData = "debugDeviceData"
    case debugControlDevice = "debugControlDevice"
    case debugLogs = "debugLogs"
    case adminLogin = "adminLogin"
    case getFeedback = "getFeedback"
    case editFeedback = "editFeedback"
    case editMessageDef = "editMessageDef"
    case grantPermission = "grantPermission"
    case editGroup = "editGroup"
    case debugServer = "debugServer"
}
enum unitType {
    case KB
    case MB
}
enum languageType: Int {
    case en = 1
    case zh = 2
    case ja = 3
}
class Utils {

    
    static func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    static func isPhoneNumber(phone:String) ->Bool{
        let cellPhone = "^1[3-9]\\d{9}$"

        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",cellPhone)
        
        return regextestmobile.evaluate(with: phone)

    }
    //判断是否是数字字符串
    static func isNumericString (str: String) ->Bool {
        guard str.count != 0 else {
            return false
        }
        let regex = "[0-9]*"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: str)
            
    }
    
    static func goToSettingsPage(view: UIView) {
        let base64String = "QXBwLVByZWZzOnJvb3Q9R2VuZXJhbA==" //App-Prefs:root=General用base64加密后的字符串
        //let url = URL(string: UIApplicationOpenSettingsURLString)
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    if let settingsString = base64String.fromBase64(), let decodedUrl = URL(string: settingsString) {
                        UIApplication.shared.open(decodedUrl, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        } else {
//            view.makeToast(LanguageHelper.shareInstance.getAppStr("ActionFailed", comment: "")+": please open Settings manually", duration: 1, position: .center)
        }
    }
    
    static func gotoURL(target: String) {
        if let url = URL(string: target) {
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    print("go to :", target)
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    static func getSuperViewController(view: UIView) -> UIViewController? {
        var next: UIView? = view.superview
        while next != nil {
            if let nextResponder = next?.next, nextResponder is UIViewController {
                return (nextResponder as! UIViewController)
            }
            next = next?.superview
        }
        return nil
    }
    
    func getCurrentVC() -> UIViewController {
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal{
            let windows = UIApplication.shared.windows
            for  tempwin in windows{
                if tempwin.windowLevel == UIWindow.Level.normal{
                    window = tempwin
                    break
                }
            }
        }
        let frontView = (window?.subviews)![0]
        let nextResponder = frontView.next
        //Getdevice.println("getCurrentVC    XX \(frontView.classForCoder)")// iOS8 9 window  ios7 UIView
        //Getdevice.println("getCurrentVC    XX \((window?.subviews)!.count)")
        //Getdevice.println("getCurrentVC    XX \(nextResponder?.classForCoder)")
        if nextResponder?.isKind(of: UIViewController.classForCoder()) == true {
            return nextResponder as! UIViewController
        } else if nextResponder?.isKind(of: UINavigationController.classForCoder()) == true {
            return (nextResponder as! UINavigationController).visibleViewController!
        } else {
            if (window?.rootViewController) is UINavigationController{
              return ((window?.rootViewController) as! UINavigationController).visibleViewController!//只有这个是显示的controller 是可以的必须有nav才行
            } else if (window?.rootViewController) is UITabBarController {
                return ((window?.rootViewController) as! UITabBarController).selectedViewController! //不行只是最三个开始的页面
            }
            return (window?.rootViewController)!
        }
    }
    

    
    

    
    //MARK: - image
    static func imageToData(img: UIImage) -> Data? {
        let image2 = UIImage(cgImage: img.cgImage!, scale: img.scale, orientation: img.imageOrientation)
        do {
            let imageData = try NSKeyedArchiver.archivedData(withRootObject: image2, requiringSecureCoding: false)
            return imageData
        } catch {
            print("exception for getting image data")
        }
        return nil
    }
    

    

    

    


    


    
}
//MARK: 日期格式化
extension Utils {
    // - time format: UTC 时间转化为北京时间,输入的UTC日期格式2013-08-03T04:53:51+0000
    static func getLocalDateFrom(utcDate: String, withoutSecond: Bool=false) -> String {
        let dateFormatter = DateFormatter()
        //输入格式
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" //2020-06-18T02:23:46.360Z
        dateFormatter.timeZone = NSTimeZone.system
        
        let dateFormatted = dateFormatter.date(from: utcDate)
        //输出格式
        if withoutSecond {
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        } else {
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        }
        if dateFormatted != nil {
            return dateFormatter.string(from: dateFormatted!)
        }
        return utcDate
    }
}
//MARK: - 判断机型
extension Utils {
    
    static func isSimulator() -> Bool {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }
    static func isPad() -> Bool {
        return (UIDevice.current.userInterfaceIdiom == .pad)
    }
    static func isIPhoneX() -> Bool {
        if isPad() { return false }
        var isIPhoneX = false
        if #available(iOS 11.0, *) {
            isIPhoneX = UIApplication.shared.delegate?.window.unsafelyUnwrapped?.safeAreaInsets.bottom ?? 0 > 0.0
        }
        return isIPhoneX
    }
    
    static func isIPhone5() -> Bool {
        return (Int(UIScreen.main.bounds.width) == 320)
    }
}
//MARK: - 语言设置相关
extension Utils {
    //MARK: - language
    static func setAppLanguage(_ index: Int) {
        if index < 0 || index >= Constants.LANGUAGES.count {
            Debug.shared.println("Invalid language index")
            return
        }
        Utils.setNormalDefault(key: Constants.KEY_USER_LANGUAGE, value: index as AnyObject)
    }
    //获取当前APP内的语言环境
    static var currentLanguageType: languageType {
        let tag = getAppLanguage()
        if tag == 0 {//跟随语言系统
             return languageType(rawValue: getSystemLanguageTag()) ?? .en
        }
        return  languageType(rawValue: tag) ?? .en
    }
    static func getAppLanguage() -> Int {
        var lang:Int? = Utils.getNormalDefult(key: Constants.KEY_USER_LANGUAGE) as? Int
        if lang == nil { //第一次安装app，没有保存过默认语言
            lang = 0 // 跟随系统语言
            Utils.setNormalDefault(key: Constants.KEY_USER_LANGUAGE, value: lang as AnyObject?)
        }
        return lang!
    }
    //app内设置语言
    static func getAppCurrentLanguage() ->String {
        let tag =  currentLanguageType.rawValue
        if tag <  Constants.LANGUAGE_ARR.count{
            return Constants.LANGUAGE_ARR[tag]
        }
        return "en"
    }
    //获取网络请求头lang（语言标签）
    static func getHttpRequestHeadLang() -> String {
        let tag =  currentLanguageType.rawValue
        if tag <  Constants.HTTP_LANG_TAG.count{
            return Constants.HTTP_LANG_TAG[tag]
        }
        return "en-US"
    }
    //获取手机系统语言Tag
    static func getSystemLanguageTag() -> Int {
        let languageArr = Constants.LANGUAGE_ARR

        return languageArr.index(of: getCurrentLanguage()) ?? 0
        
    }
    //手机系统语言
    static func getCurrentLanguage() -> String {

        let preferredLang = Bundle.main.preferredLocalizations.first! as NSString
        //        let preferredLang = (languages! as AnyObject).object(0)
        Debug.shared.println("当前系统语言:\(preferredLang)")
        
        switch String(describing: preferredLang) {
        case "en-US", "en-CN":
            return "en"//英文
        case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":
            return "zh"//中文
//        case "de"://德语
//            return "de"
        case "ja":
            return "ja" //日语
        default:
            return "en"
        }
    }
}
//MARK: - 请求地理权限弹窗设置和获取
extension Utils {
    //设置请求地理权限弹窗不再提示
    static func setLocationNoMoreAlert() {
        Constants.SET_LOCAL_DATA(type: .locationAlert, data: "NoMoreAlert" as AnyObject)
    }
    
    static var isLocationNoMoreAlert: Bool {
        
        if let _ = Constants.GET_LOCAL_DATA(type: .locationAlert) as? String {
            return true
        }
        return false
    }
}
//MARK: - 温度单位换算
extension Utils {
    // 温度单位换算
    static func falrenheit(to celsius: Int) -> Int {
        let temp:Float = Float(celsius)*9/5+32
        return lroundf(temp)
    }
}
//MARK: - UserDefault设置,移除和获取本地数据
extension Utils {
    // 本地数据存储相关
    class func setNormalDefault(key:String, value:AnyObject?){
        if value == nil {
            UserDefaults.standard.removeObject(forKey: key)
        } else {
            UserDefaults.standard.set(value, forKey: key)
            // 同步
            UserDefaults.standard.synchronize()
        }
    }
    
    /**
     通过对应的key移除储存
     - parameter key: 对应key
     */
    class func removeNormalUserDefault(key:String?){
        if key != nil {
            UserDefaults.standard.removeObject(forKey: key!)
            UserDefaults.standard.synchronize()
        }
    }
    
    /**
     通过key找到储存的value
     - parameter key: key
     - returns: AnyObject
     */
    class func getNormalDefult(key:String)->AnyObject?{
        return UserDefaults.standard.value(forKey: key) as AnyObject
    }
}
//MARK: - 获取某一项的权限
extension Utils {
    //获取某一项的权限
    static func getPermissionForName(_ permissionType: permissionType) -> Bool {
        if Globals.gPermString != nil {
            return  Globals.gPermString?.contains("\(permissionType.rawValue)\":{\"enable\":1") ?? false
        }
        if let permissionStr =  Constants.GET_LOCAL_DATA(type: .permission) as? String {
            
            return  permissionStr.contains("\(permissionType.rawValue)\":{\"enable\":1")
        }
        return false
    }
}
//MARK: - Byte单位转换
extension Utils {
    //转换单位
    static func ByteChange( byte: Int, to uintType: unitType) -> Int {
        switch uintType {
        case .KB:
            return  lroundf(Float(byte)/1024)
        case .MB:
            return lroundf(Float(byte)/1024/1024)
        }
        
    }
}
//MARK: - 根据语言设置获取相应国家的跳转链接和邮箱
extension Utils {
    //使用条款
    static var EFTerms: String {
        switch currentLanguageType {
        case .ja:
            return Constants.JA_URL_TERMS_OF_USE
        case .en, .zh:
            return Constants.URL_TERMS_OF_USE
 
        }
    }
    //隐私政策
    static var EFPrivacy: String {
        switch currentLanguageType {
        case .ja:
            return Constants.JA_URL_PRIVACY_POLICY
        case .en, .zh:
            return Constants.URL_PRIVACY_POLICY
 
        }

    }
    //FaceBook跳转链接
    static var EFFacebookUrl: String {
        switch currentLanguageType {
        case .ja:
            return Constants.JA_URL_FACEBOOK
        case .en, .zh:
            return Constants.URL_FACEBOOK
 
        }

    }
    //Ins跳转链接
    static var EFInsUrl: String {
        switch currentLanguageType {
        case .ja:
            return Constants.JA_URL_INS
        case .en, .zh:
            return Constants.URL_INS
 
        }
    }
    //Twitter跳转链接
    static var EFTwitterUrl: String {
        switch currentLanguageType {
        case .ja:
            return Constants.JA_URL_TWITTER
        case .en, .zh:
            return Constants.URL_TWITTER
 
        }
    }
    //Youtube跳转链接
    static var EFYoutubeUrl: String {
        switch currentLanguageType {
        case .ja:
            return Constants.JA_URL_YOUTUBE
        case .en, .zh:
            return Constants.URL_YOUTUBE
 
        }
    }
    //对应国家的邮箱
    static var EFEmail: String {
        switch currentLanguageType {
        case .ja:
            return Constants.JA_EFEMAIL
        case .en, .zh:
            return Constants.EF_EMAIL
 
        }
    }
    //对应国家的设备配网Wi-Fi引导图
    static var EF_GuideWifiImage: String {
        switch currentLanguageType {
        case .ja:
            return "tu2"
        case .en, .zh:
            return "secondStep"
 
        }
    }
    //对应国家的官网
    static var EFWebsite: String {
        switch currentLanguageType {
        case .en:
            return Constants.EN_WEBSITE
        case .zh:
            return Constants.ZH_WEBSITE
        case .ja:
            return Constants.JA_WEBSITE
 
        }
    }
}
//MARK: - 获取iPhone型号（6s,6splus,xs等）
extension Utils {
   static var iphoneType: String {
    var devInfo = utsname()
    uname(&devInfo)
    let platform = withUnsafePointer(to: &devInfo.machine.0) { (ptr)  in
        return String(cString: ptr)
     }
    //iphone
    if platform == "iPhone3,1" { return "iPhone 4"}
    if platform == "iPhone3,2" { return "iPhone 4"}
    if platform == "iPhone3,3" { return "iPhone 4"}
    if platform == "iPhone4,1" { return "iPhone 4S"}
    if platform == "iPhone5,1" { return "iPhone 5"}
    if platform == "iPhone5,2" { return "iPhone 5"}
    if platform == "iPhone5,3" { return "iPhone 5C"}
    if platform == "iPhone5,4" { return "iPhone 5C"}
    if platform == "iPhone6,1" { return "iPhone 5S"}
    if platform == "iPhone6,2" { return "iPhone 5S"}
    if platform == "iPhone7,1" { return "iPhone 6 Plus"}
    if platform == "iPhone7,2" { return "iPhone 6"}
    if platform == "iPhone8,1" { return "iPhone 6S"}
    if platform == "iPhone8,2" { return "iPhone 6S Plus"}
    if platform == "iPhone8,4" { return "iPhone SE"}
    if platform == "iPhone9,1" { return "iPhone 7"}
    if platform == "iPhone9,2" { return "iPhone 7 Plus"}
    if platform == "iPhone10,1" { return "iPhone 8"}
    if platform == "iPhone10,2" { return "iPhone 8 Plus"}
    if platform == "iPhone10,3" { return "iPhone X"}
    if platform == "iPhone10,4" { return "iPhone 8"}
    if platform == "iPhone10,5" { return "iPhone 8 Plus"}
    if platform == "iPhone10,6" { return "iPhone X"}
    if platform == "iPhone11,8" { return "iPhone XR"}
    if platform == "iPhone11,2" { return "iPhone XS"}
    if platform == "iPhone11,6" { return "iPhone XS Max"}
    if platform == "iPhone11,4" { return "iPhone XS Max"}
    
    if platform == "iPhone12,1" { return "iPhone 11"}
    if platform == "iPhone12,3" { return "iPhone 11 Pro"}
    if platform == "iPhone12,5" { return "iPhone 11 Pro Max"}
    if platform == "iPhone12,8" { return "iPhone SE"}
    //ipad
    if platform == "iPad1,1" { return "iPad 1"}
    if platform == "iPad2,1" { return "iPad 2"}
    if platform == "iPad2,2" { return "iPad 2"}
    if platform == "iPad2,3" { return "iPad 2"}
    if platform == "iPad2,4" { return "iPad 2"}
    if platform == "iPad2,5" { return "iPad Mini 1"}
    if platform == "iPad2,6" { return "iPad Mini 1"}
    if platform == "iPad2,7" { return "iPad Mini 1"}
    if platform == "iPad3,1" { return "iPad 3"}
    if platform == "iPad3,2" { return "iPad 3"}
    if platform == "iPad3,3" { return "iPad 3"}
    if platform == "iPad3,4" { return "iPad 4"}
    if platform == "iPad3,5" { return "iPad 4"}
    if platform == "iPad3,6" { return "iPad 4"}
    if platform == "iPad4,1" { return "iPad Air"}
    if platform == "iPad4,2" { return "iPad Air"}
    if platform == "iPad4,3" { return "iPad Air"}
    if platform == "iPad11,3" { return "iPad Air"}
    if platform == "iPad4,4" { return "iPad Mini 2"}
    if platform == "iPad4,5" { return "iPad Mini 2"}
    if platform == "iPad4,6" { return "iPad Mini 2"}
    if platform == "iPad4,7" { return "iPad Mini 3"}
    if platform == "iPad4,8" { return "iPad Mini 3"}
    if platform == "iPad4,9" { return "iPad Mini 3"}
    if platform == "iPad5,1" { return "iPad Mini 4"}
    if platform == "iPad5,2" { return "iPad Mini 4"}
    if platform == "iPad5,3" { return "iPad Air 2"}
    if platform == "iPad5,4" { return "iPad Air 2"}
    if platform == "iPad6,3" { return "iPad Pro 9.7"}
    if platform == "iPad6,4" { return "iPad Pro 9.7"}
    if platform == "iPad6,7" { return "iPad Pro 12.9"}
    if platform == "iPad6,8" { return "iPad Pro 12.9"}
      return ""
   }
}
//MARK:- 替换不符合UTF-8编码的字符
extension Utils {
    
    //data转String
    static func convertedToUtf8String(data: Data) -> String? {
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            return string
        }
        
        return String(data: cleanUTF8(data: data), encoding: String.Encoding.utf8)

    }
    //替换不符合utf-8编码的字符
    static  func cleanUTF8(data: Data) -> Data {
    
 
        let resdata = NSMutableData.init(capacity: data.count)
        let replacement = "�".data(using: .utf8)!
        var index = 0
        let bytes = [UInt8](data)
        let dataLength = data.count
        while index < dataLength {
            var len = 0
            let  firstChar = bytes[index]
            // 1个字节
                    if ((firstChar & 0x80) == 0 && (firstChar == 0x09 || firstChar == 0x0A || firstChar == 0x0D || (0x20 <= firstChar && firstChar <= 0x7E))) {
                        len = 1
                    }else if ((firstChar & 0xE0) == 0xC0 && (0xC2 <= firstChar && firstChar <= 0xDF)) {
                        if (index + 1 < dataLength) {
                            let secondChar = bytes[index + 1]
                            if (0x80 <= secondChar && secondChar <= 0xBF) {
                                len = 2
                            }
                        }
                    } else if ((firstChar & 0xF0) == 0xE0) {
                        if (index + 2 < dataLength) {
                            let secondChar = bytes[index + 1];
                            let thirdChar = bytes[index + 2];
                            
                            if (firstChar == 0xE0 && (0xA0 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                                len = 3;
                            } else if (((0xE1 <= firstChar && firstChar <= 0xEC) || firstChar == 0xEE || firstChar == 0xEF) && (0x80 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                                len = 3;
                            } else if (firstChar == 0xED && (0x80 <= secondChar && secondChar <= 0x9F) && (0x80 <= thirdChar && thirdChar <= 0xBF)) {
                                len = 3;
                            }
                        }
                    }else if ((firstChar & 0xF8) == 0xF0) {
                        if (index + 3 < dataLength) {
                            let secondChar = bytes[index + 1];
                            let thirdChar = bytes[index + 2];
                            let fourthChar = bytes[index + 3];
                            
                            if (firstChar == 0xF0) {
                                if ((0x90 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                                    len = 4;
                                }
                            } else if ((0xF1 <= firstChar && firstChar <= 0xF3)) {
                                if ((0x80 <= secondChar && secondChar <= 0xBF) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                                    len = 4;
                                }
                            } else if (firstChar == 0xF3) {
                                if ((0x80 <= secondChar && secondChar <= 0x8F) && (0x80 <= thirdChar && thirdChar <= 0xBF) && (0x80 <= fourthChar && fourthChar <= 0xBF)) {
                                    len = 4;
                                }
                            }
                        }
                    }
            if len == 0 {
                index += 1
                resdata?.append(replacement)
            }else{
                
                resdata?.append(UnsafeRawPointer(bytes) + index, length: len)
                index += len
            }
            
        }
        return resdata! as Data
    }
}

class Debug {
    static private let TAG = "DEBUG:: "
    static let shared = Debug()
    private var isEnable = true
    
    func println(_ msg: String) {
        if !isEnable { return }
        print(Debug.TAG, msg)
    }
    
    func println(_ msg: String, tag: String=Debug.TAG) {
        if !isEnable { return }
        print(tag, msg)
    }
    
    func printHex(data: [UInt8], tag: String="") {
        if !isEnable { return }
        var str = ""
        for d in data { str += String.init(format: "0x%02X ", d) }
        print("count: \(data.count)")
        print("\(tag) ", str)
        print("--------------")
    }
}

class SystemParamsModel {
    var name: String = ""
    var type: String = "int32"
    var value: Any = Int(0)
    
    init(name: String, type: String, value: Any) {
        self.name = name
        self.type = type
        self.value = value
    }
}

struct Globals {
    static private var globalLock: Int = 0
    static var gUserModel: UserModel?
    static var httpToken: String?
    static var gLoginData: String = ""
    static var gPermString: String?
    
    static var remoteDevicesDictionary = NSMutableDictionary()
    static var localDevicesDictionary = NSMutableDictionary()
    static var sortDeviceArray = [BaseDevice]()
    static var sortLocalDeviceArray = [BaseDevice]()
    static var permissionSet = [PermissionModel]()
    
    static var parsedMessageDictionary: NSMutableDictionary?
    
    //MARK: - methods
    static func add(device: DeviceModel, for key: String, to remote: Bool) -> BaseDevice {
        objc_sync_enter(globalLock)
        if remote { //add remove device
            if let existDev = Globals.remoteDevicesDictionary.object(forKey: key) as? BaseDevice {
                objc_sync_exit(globalLock)
                return existDev
            }
            let dev = DeviceFactory.shareInstance.create(with: device)
            Globals.remoteDevicesDictionary.setValue(dev, forKey: key)
            objc_sync_exit(globalLock)
            return dev
        } else {
            if let existDev = Globals.localDevicesDictionary.object(forKey: key) as? BaseDevice {
                objc_sync_exit(globalLock)
                return existDev
            }
            device.firstIndex = localDevicesDictionary.count
            let dev = DeviceFactory.shareInstance.create(with: device)
            Globals.localDevicesDictionary.setValue(dev, forKey: key)
            objc_sync_exit(globalLock)
            return dev
        }
    }
    static func removeDevice(for key: String, from remote: Bool) {
        objc_sync_enter(globalLock)
        if remote {
            Globals.remoteDevicesDictionary.removeObject(forKey: key)
        } else {
            Globals.localDevicesDictionary.removeObject(forKey: key)
        }
        objc_sync_exit(globalLock)
    }
    static func getDevice(by index: Int, from remote: Bool) -> BaseDevice? {
        objc_sync_enter(globalLock)
        
        if remote {
            sortRemoteDevices()
            guard index < sortDeviceArray.count else {
                objc_sync_exit(globalLock)
                return nil
            }
            let dev = sortDeviceArray[index]
            objc_sync_exit(globalLock)
            return dev
        } else {
            sortLocalDevices()
            guard index < sortLocalDeviceArray.count else {
                objc_sync_exit(globalLock)
                return nil
            }
            let dev = sortLocalDeviceArray[index]
            objc_sync_exit(globalLock)
            return dev
        }

    }
    static func getDevice(by sn: String, from remote: Bool) -> BaseDevice? {
        objc_sync_enter(globalLock)
        
        if remote {
            sortRemoteDevices()
            for dev in sortDeviceArray {
                if dev.getSN() == sn {
                    objc_sync_exit(globalLock)
                    return dev
                }
            }
        } else {
            if let dev = Globals.localDevicesDictionary.object(forKey: sn) as? BaseDevice {
                objc_sync_exit(globalLock)
                return dev
            }
        }
        
        objc_sync_exit(globalLock)
        return nil
    }
    
    static func sortRemoteDevices() {
        sortDeviceArray.removeAll()
        
        for (_, d) in remoteDevicesDictionary {
            if let dev = d as? BaseDevice { sortDeviceArray.append(dev)
               

            }
        }

        sortDeviceArray.sort{ $0.getDeviceModel().firstIndex < $1.getDeviceModel().firstIndex }
    }
    
    static func getSortedRemoteDeviceNum() -> Int {
        sortRemoteDevices()
        return sortDeviceArray.count
    }
    
    static func sortLocalDevices() {
        sortLocalDeviceArray.removeAll()
        for (_, d) in localDevicesDictionary {
            if let dev = d as? BaseDevice {sortLocalDeviceArray.append(dev)}
        }
        sortLocalDeviceArray.sort{ $0.getDeviceModel().firstIndex < $1.getDeviceModel().firstIndex}
    }
}

class UserModel: NSObject, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    
    var email: String = ""
    var password: String = ""
    var userName: String = ""
    var userAccount: String = ""
    var userHeadImg: String = ""
    var phone: String = ""
    var address: String = ""
    var country: String = ""
    var state: Int = 0
    var latestLoginIP: String = ""
    var latestLoginTime: String = ""
    var tokenExpires: String = ""
    var isAutoLogin: Bool = false
    var isFacebookLogin: Bool = false
    var isAppleLogin: Bool = false
    var isGoogleLogin: Bool = false
    var isChinaLogin: Bool = false
    var isPermission: Bool = false
    var isWechatLogin: Bool = false
    var isThirdLogin: Bool {
        return isAppleLogin || isGoogleLogin || isFacebookLogin || isWechatLogin
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(email, forKey: "email")
        coder.encode(password, forKey: "password")
        coder.encode(userName, forKey: "userName")
        coder.encode(userAccount, forKey: "userAccount")
        coder.encode(userHeadImg, forKey: "userHeadImg")
        coder.encode(phone, forKey: "phone")
        coder.encode(address, forKey: "address")
        coder.encode(country, forKey: "country")
        coder.encode(state, forKey: "state")
        coder.encode(latestLoginIP, forKey: "latestLoginIP")
        coder.encode(latestLoginTime, forKey: "latestLoginTime")
        coder.encode(tokenExpires, forKey: "tokenExpires")
        coder.encode(isAutoLogin, forKey: "isAutoLogin")
        coder.encode(isFacebookLogin, forKey: "isFacebookLogin")
        coder.encode(isAppleLogin, forKey: "isAppleLogin")
        coder.encode(isGoogleLogin, forKey: "isGoogleLogin")
        coder.encode(isChinaLogin, forKey: "isChinaLogin")
        coder.encode(isPermission, forKey: "isPermission")
    }
    
    required init?(coder: NSCoder) {
        if let email = coder.decodeObject(forKey: "email") as? String {
            self.email = email
        }
        if let password = coder.decodeObject(forKey: "password") as? String {
            self.password = password
        }
        if let userName = coder.decodeObject(forKey: "userName") as? String {
            self.userName = userName
        }
        if let userAccount = coder.decodeObject(forKey: "userAccount") as? String {
            self.userAccount = userAccount
        }
        if let userHeadImg = coder.decodeObject(forKey: "userHeadImg") as? String {
            self.userHeadImg = userHeadImg
        }
        if let phone = coder.decodeObject(forKey: "phone") as? String {
            self.phone = phone
        }
        if let address = coder.decodeObject(forKey: "address") as? String {
            self.address = address
        }
        if let country = coder.decodeObject(forKey: "country") as? String {
            self.country = country
        }
        self.state = coder.decodeInteger(forKey: "state")
        if let latestLoginIP = coder.decodeObject(forKey: "latestLoginIP") as? String {
            self.latestLoginIP = latestLoginIP
        }
        if let latestLoginTime = coder.decodeObject(forKey: "latestLoginTime") as? String {
            self.latestLoginTime = latestLoginTime
        }
        if let tokenExpires = coder.decodeObject(forKey: "tokenExpires") as? String {
            self.tokenExpires = tokenExpires
        }
        self.isAutoLogin = coder.decodeBool(forKey: "isAutoLogin")
        self.isFacebookLogin = coder.decodeBool(forKey: "isFacebookLogin")
        self.isAppleLogin = coder.decodeBool(forKey: "isAppleLogin")
        self.isGoogleLogin = coder.decodeBool(forKey: "isGoogleLogin")
        self.isChinaLogin = coder.decodeBool(forKey: "isChinaLogin")
        self.isPermission = coder.decodeBool(forKey: "isPermission")
    }
    
    init(email: String, password: String, name: String, userHeadImg: String ,state: Int, latestLoginIP: String, latestLoginTime: String, tokenExpires: String, isAutoLogin: Bool, isFacebookLogin: Bool, isAppleLogin:Bool, isGoogleLogin: Bool = false ,facebookEmail: String="", phone: String = "", address: String = "", country: String = "", isChinaLogin: Bool = false, isPermission: Bool = false, account: String) {
        self.email = email
        self.password = password
        self.userName = name
        self.userAccount = account
        self.userHeadImg = userHeadImg
        self.phone = phone
        self.address = address
        self.country = country
        self.state = state
        self.latestLoginIP = latestLoginIP
        self.latestLoginTime = latestLoginTime
        self.tokenExpires = tokenExpires
        self.isAutoLogin = isAutoLogin
        self.isFacebookLogin = isFacebookLogin
        self.isAppleLogin = isAppleLogin
        self.isGoogleLogin = isGoogleLogin
        self.isChinaLogin = isChinaLogin
        self.isPermission = isPermission
    }
    
}

class DeviceEventModel {
    var level: Int = 0
    var msg: String = ""
    var errCode: Int64 = 0
    
    var msgId: Int = 0
    var createdAt: String = ""
    var eventType: Int = 0 //0:server 1:device
    var timestamp: Int = 0
    init(with dict: NSDictionary) {
        if let errCode = dict.object(forKey: "errCode") as? Int64 {
            self.errCode = errCode
        }
        
        if let msgId = dict.object(forKey: "msgId") as? Int {
            self.msgId = msgId
        }
        if let createdAt = dict.object(forKey: "createdAt") as? String {
            self.createdAt = createdAt
        }
        if let timestamp = dict.object(forKey: "timestamp") as? Int {
            self.timestamp = timestamp
        }
    }
}

class PermissionModel {
    var permissionName: String = ""
    var enable: Int = 0
    
    init(permName: String, enable: Int) {
        self.permissionName = permName
        self.enable = enable
    }
}

class DeviceModel:NSObject {
    var devSN: String = ""
    var devName: String = ""
    var model: Int = 0
    var productType: Int = 0
    var connected: Bool = false
    var createAt: String = ""
    var soc: Int = 0
    var firstIndex: Int = 0
    
    init(sn: String, name: String, model: Int, productType: Int, connected: Bool, createAt: String, soc: Int=0, firstIndex: Int=0) {
        self.devSN = sn
        self.devName = name
        self.model = model
        self.productType = productType
        self.connected = connected
        self.createAt = createAt
        self.soc = soc
        self.firstIndex = firstIndex
    }
}

extension String {
    // base64编码
    func toBase64() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }

    // base64解码
    func fromBase64() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    
    //获取临时目录
    func tempDir() -> String {
        let temp = NSTemporaryDirectory() as NSString
        let filePath = temp.appendingPathComponent((self as NSString).lastPathComponent)
        return filePath
    }
    
    //从0索引处开始查找是否包含指定的字符串，返回Int类型的索引
    //返回第一次出现的指定子字符串在此字符串中的索引
    func findFirst(_ sub:String)->Int {
        var pos = -1
        if let range = range(of:sub, options: .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
}

class DeviceFactory {
    static let shareInstance = DeviceFactory()
    
    func create(with model: DeviceModel) -> BaseDevice {
//            switch model.productType {
//            case 0,5,7:
//                if model.model == 1 {
//                    return DeviceR600(with: model)
//                }
//                if model.model == 2 {
//                    return DeviceR600Max(with: model)
//                }
//                if model.model == 3 {
//                    return DeviceR600Pro(with: model)
//                }
//                if model.model == 4 {
//                    return DeviceR600Lfp(with: model)
//                }
//                if model.model == 5 {
//                    return DeviceR600PKit(with: model)
//                }
//            case 12:
//                if model.model == 1 {
//                    return DeviceR600PLi(with: model)
//                }
//                if model.model == 2 {
//                    return DeviceR600PLiEF1500(with: model)
//                }
//            case 13:
//                if model.model == 1 {
//                    return DeviceR600DeltaPro(with: model)
//                }
//            default:
//                return DeviceR600Lite(with: model)
//            }
//          return DeviceR600Lite(with: model)
        return BaseDevice.init(with: model)
    }

}
