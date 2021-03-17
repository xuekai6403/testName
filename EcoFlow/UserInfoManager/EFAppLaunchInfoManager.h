//
//  EFAppLaunchInfoManager.h
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import <Foundation/Foundation.h>

#import "EFAppLaunchInfoEx.h"

NS_ASSUME_NONNULL_BEGIN

@interface EFAppLaunchInfoManager : NSObject

/** 存储 App 启动配置信息*/
+ (void)saveLaunchInfo:(EFAppLaunchInfo *)info;

/** 获取 App 启动配置信息 */
+ (EFAppLaunchInfo *)takeLaunchInfo;

/** 删除 App 启动配置信息 */
+ (EFAccountItem *)deleteLaunchInfo;

/** 获取启动配置特定的协议信息 */
+ (AppAgreeInfo *)getRuleUrlInfo:(NSString *)ruleCode;

@end

NS_ASSUME_NONNULL_END
