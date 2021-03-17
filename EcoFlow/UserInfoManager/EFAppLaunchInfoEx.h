//
//  EFAppLaunchInfoEx.h
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class EFAppLaunchInfo, AppAgreeInfo, AppTabInfo, AppWelcomeInfo;

@interface EFAppLaunchInfoEx : BaseModel

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) EFAppLaunchInfo * data;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) NSString * timestamp;

@end

@interface EFAppLaunchInfo : BaseModel <NSCoding>

@property (nonatomic, strong) NSArray<AppAgreeInfo *> *agree;
//@property (nonatomic, strong) NSArray<AppTabInfo *> *tab;
@property (nonatomic, strong) NSArray<AppWelcomeInfo *> *welcome;

@end

@interface AppAgreeInfo : BaseModel <NSCoding>

@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * url;


@end

@interface AppTabInfo : BaseModel <NSCoding>

@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * icons;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString * url;

@end

@interface AppWelcomeInfo : BaseModel <NSCoding>

@property (nonatomic, copy) NSString * img;
@property (nonatomic, copy) NSString * url;

@end

NS_ASSUME_NONNULL_END
