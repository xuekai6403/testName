//
//  EFAccountManager.h
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import <Foundation/Foundation.h>

#import "EFAccountItem.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EFAccountManager : NSObject

SingleInterface(AccountManager);

/** 位置管理器 */
@property (nonatomic, strong) CLLocationManager *locationManager;

/** 全局账户信息单例 */
@property (nonatomic, strong) EFAccountItem *accountInfo;

/// 1 -> 男
@property (nonatomic, strong) NSString *WX_sexStr;

@property (nonatomic, strong) NSString *WX_nickname;

@property (nonatomic, strong) NSString *curLoginChannel;

//@property (nonatomic, strong) NSString *hy_mobile;

/** 存储帐号 */
+ (void)save:(EFAccountItem *)account;

/** 读取帐号 */
+ (EFAccountItem *)account;

/** 删除帐号,登出 */
+ (EFAccountItem *)deleteAccount;

/// 唤起登录页
+ (void)callLoginPage;

/// 获取用户信息
- (void)getUserInfo:(NSString *)tokenStr completionHandler:(void (^) (id responseObj, bool isSuccess))completionHandler;

/// 请求通讯录权限
- (void)requestContactAuthorAfterSystemVersion9:(BOOL)isSimpleOne;

@end

NS_ASSUME_NONNULL_END
