//
//  EFAppLaunchInfoManager.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "EFAppLaunchInfoManager.h"

#define kAppLaunchInfoFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"launchInfo.plist"]

@implementation EFAppLaunchInfoManager

/** 存储 App 启动配置信息*/
+ (void)saveLaunchInfo:(EFAppLaunchInfo *)info {
    // 归档
    [NSKeyedArchiver archiveRootObject:info toFile:kAppLaunchInfoFilepath];
}

/** 获取 App 启动配置信息 */
+ (EFAppLaunchInfo *)takeLaunchInfo {
    EFAppLaunchInfo *info = [NSKeyedUnarchiver unarchiveObjectWithFile:kAppLaunchInfoFilepath];
    if (info) {
        return info;
    } else {
        return [EFAppLaunchInfo new];
    }
}

/** 删除 App 启动配置信息 */
+ (EFAppLaunchInfo *)deleteLaunchInfo {
    EFAppLaunchInfo *info = [EFAppLaunchInfoManager takeLaunchInfo];
    info.welcome = [NSArray new];
    info.agree = [NSArray new];
    [EFAppLaunchInfoManager saveLaunchInfo:info];
    
    return info;
}

/** 获取启动配置特定的协议信息: code = APP/ AUTH/SCRET/PAY*/
+ (AppAgreeInfo *)getRuleUrlInfo:(NSString *)ruleCode {
    AppAgreeInfo *ruleInfo = [AppAgreeInfo new];
    ruleInfo.title = @"";
    ruleInfo.url = @"";
    
    EFAppLaunchInfo *data = [EFAppLaunchInfoManager takeLaunchInfo];
    if (data.agree.count > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code = %@", ruleCode];
        NSArray *filteredArray= [data.agree filteredArrayUsingPredicate:predicate];
        if (filteredArray.count > 0) {
            AppAgreeInfo *ag = filteredArray.firstObject;
            
            if (ag.url.length > 0) {
                ruleInfo.url = ag.url;
            }
            
            if (ag.title.length > 0) {
                ruleInfo.title = ag.title;
            }
        }
    }
    return ruleInfo;
}

@end
