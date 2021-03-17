//
//  EFCommonMacro.h
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#ifndef EFCommonMacro_h
#define EFCommonMacro_h

#define KImage(name) [UIImage imageNamed:name]

// SIZE
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define kiPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define KgetSize(view) view.frame.size
#define KNavBarHeight (CGFloat)(kiPhoneX? (88): (64))
#define KTabBarHeight (CGFloat)(kiPhoneX ?83:49)

#define KNavBarWithoutStatusBarHeight (CGFloat)(44.0)

// 底部安全区域远离高度
#define kBottomSafeHeight   (CGFloat)(kiPhoneX?(34):(0))
// 顶部安全区域远离高度
#define kTopBarSafeHeight   (CGFloat)(kiPhoneX?(44):(0))

#define kTopBarSafeHeightNew   (CGFloat)(kiPhoneX?(24):(0))

//适配参数 以6s(750*1334)为基准图
#define GLJSuitParam ([UIScreen mainScreen].bounds.size.width/375.0)
#define hy_adapt_size(number) (number * GLJSuitParam)

// COLOR
#define EFColorHex(hex)         [UIColor colorWithHextColorString:hex]
#define kColorAppMain           EFColorHex(@"#FFAC0B")


// 统一替换服务器返回 json 对象中的特殊 key (id & description)
#define kID @"ID"
#define kDesc @"desc"

// app 登陆 方式
#define kAppLoginChannel @"AppLoginChannel"

// 已同一用户协议
#define kAgreeUserProtocalDone @"kAgreeUserProtocalDone"

// Apple 登陆 uid
#define kAppleLoginUidKey @"AppleLoginUidKey"
#define kAppleLoginUidServiceKey @"AppleLoginUidServiceKey"

// 极光 Appkey
#define kJPushAppKey @"5e3564a9c2a6a298576a4469"

// app名字
#define kAppName ([[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey])
// app version
#define kAppVersions ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
// app bulid version
#define kAppBulidVersions ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])
// bundle id
#define kAppBundleId ([[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey])
// display name
#define kAppBundleDisplayName ([[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)@"CFBundleDisplayName"])

#define kDeviceUUID ([[[UIDevice currentDevice] identifierForVendor] UUIDString])

#define kDeviceBrand [UIDevice currentDevice].model
#define kDeviceModel [NSObject getDeviceIdentifierName]
#define kDeviceSystemVersion [UIDevice currentDevice].systemVersion
#define kDevicePlatform [UIDevice currentDevice].systemName
#define kDeviceScale [[UIScreen mainScreen] scale]

#define kAppChannel @"iOS"
#define kDeviceType @"2" //设备类型 1 android 2 iOS
#define kApiVersion @"v1.0"
#define kProductID  @"1000"
#define kEnvtype  @"0"  //1生产环境，0测试环境
#define kMjbname  @"mjbname"  //MJia mark
#define kInnerVer  @"1"
#define kSinaifiosauditing  @""

/// 列表限制单次请求 item 条数
#define kLimitCount 20

// FONT
#define KFont(x)  [UIFont systemFontOfSize:x]
#define KBFont(x) [UIFont boldSystemFontOfSize:x]


// Notification
#define kNoNetworkNotification @"NoNetworkNotification"


typedef void(^EFSelectRowActionBlock)(int row);

#ifndef dispatch_main_async_safe_hy   
#define dispatch_main_async_safe_hy(block)\
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }
#endif

#endif /* EFCommonMacro_h */
