//
//  LanguageHelper.swift
//  dohome
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

class LanguageHelper: NSObject {
    //单例
    static let shareInstance = LanguageHelper()
    
    let def = UserDefaults.standard
    var bundle : Bundle?
    
    ///根据用户设置的语言类型获取字符串
    func getUserStr(key: String) -> String {
         // 获取本地化字符串，字符串根据手机系统语言自动切换
        let str = NSLocalizedString(key, comment: "default")
        return str
    }
    
    ///根据app内部设置的语言类型获取字符串
    func getAppStr(_ key: String, comment: String) -> String {
        // 获取本地化字符串，字符串会根据app系统语言自动切换
        let str = NSLocalizedString(key, tableName: "Localizable", bundle: LanguageHelper.shareInstance.bundle!, value: "default", comment: "default")
        return str
    }
    
    func setLanguage(index: Int) {
        guard index < Constants.LANGUAGE_SHORT_NAME.count else {
            return
        }
        setLanguage(langeuage: Constants.LANGUAGE_SHORT_NAME[index])
    }
    
    ///设置app语言环境
    func setLanguage(langeuage: String) {
        var str = langeuage
        //如果获取不到系统语言，就把app语言设置为首选语言
        if langeuage == "" {
            str = "en"
            //获取系统首选语言顺序
            if  let languages:[String] = def.object(forKey: "AppleLanguages") as? [String] {
            let str2:String = languages[0]
            //如果首选语言是中文，则设置APP语言为中文，否则设置成英文
            if ((str2=="zh-Hans-CN")||(str2=="zh-Hans")) {
                str = "zh-Hans"
            }
              }
        }
        //跟随系统语言
        if langeuage == Constants.KEY_SYSTEM_LANGUAGE {
          str =  Constants.LANGUAGE_SHORT_NAME[ Utils.getSystemLanguageTag()]   
        }
        //语言设置
        def.set(str, forKey: "langeuage")
        def.synchronize()
        //根据str获取语言数据（因为设置了本地化，所以项目中有en.lproj和zn-Hans.lproj）
        let path = Bundle.main.path(forResource:str , ofType: "lproj")
        bundle = Bundle(path: path!)
    }
    
    func setAppLanguage(_ index: Int) {
        if index < 0 || index >= Constants.LANGUAGES.count  { return }
        Utils.setNormalDefault(key: Constants.KEY_USER_LANGUAGE, value: index as AnyObject)
    }
}

