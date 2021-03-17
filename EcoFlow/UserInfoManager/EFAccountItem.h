//
//  EFAccountItem.h
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "BaseModel.h"

#import "EFLoginUserInfo.h"

//NS_ASSUME_NONNULL_BEGIN

@interface EFAccountItem : BaseModel

/** 是否App第一次启动 */
@property (nonatomic, assign) BOOL isFirstLaunch;
/**是否已开启青少年模式*/
@property (nonatomic, assign) BOOL isYoungStyle;
/**青少年模式密码*/
@property (nonatomic, strong) NSString *youngStyleCode;


/** -------------- APP 大部分 用户信息汇总（本地归档） -------------- */
@property (nonatomic, strong) EFLoginUserInfo *userInfo;

/// 当前用户资料
@property (nonatomic, strong) EFLoginCurrentUserInfo *currentUserInfo;

/**------deviceId----------*/
@property (nonatomic, copy) NSString *jpushId;

/**------app token----------*/
@property (nonatomic, copy) NSString *appToken;

/**------app 登录成功 flag----------*/
@property (nonatomic, copy) NSString *LoginFlag;

/**------app avatar image----------*/
@property (nonatomic, copy) NSString *avatarImage;

/**------手机号登录输入号码记录----------*/
@property (nonatomic, copy) NSString *hy_mobile;

@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;

/// 更新app token
- (void)updateAppToken:(NSString *)appToken;

/// 标记 app 登录流程走完
- (void)updateAppLoginSuccessFlag:(NSString *)flag;

/// 更新app avatar image
- (void)updateAppAvatarImage:(NSString *)avatarImage;

/// 更新用户手机号登录手机号
- (void)updateHyMobile:(NSString *)hy_mobile;

///  更新用户信息
- (void)updateUserInfo:(EFLoginCurrentUserInfo *)currentUserInfo;

@end

//NS_ASSUME_NONNULL_END
