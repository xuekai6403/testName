//
//  EFLoginUserInfo.h
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class EFLoginUserInfo;

@interface EFLoginUserInfoEx : BaseModel

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) EFLoginUserInfo * data;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) NSString * timestamp;

@end

@interface EFLoginUserInfo : BaseModel <NSCoding>

@property (nonatomic, copy) NSString * headImg;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, assign) NSInteger money;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * userId;

@property (nonatomic, copy) NSString * token;
@property (nonatomic, copy) NSString * tokenExpires;

/// 用户短码
@property (nonatomic, copy) NSString * userCode;
/// 登录名（手机号码）
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * headerImg;

@end


@interface EFLoginCurrentUserInfo : BaseModel <NSCoding>

@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * userId;

@property (nonatomic, copy) NSString * token;
@property (nonatomic, copy) NSString * tokenExpires;
@property (nonatomic, copy) NSString * productId;

/// 登录名（手机号码）
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * headerImg;

@end

NS_ASSUME_NONNULL_END
