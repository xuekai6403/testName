//
//  QBHttpTool.h
//  EcoFlow
//

#import <Foundation/Foundation.h>
#import "QBServerMacro.h"
#import "AFNetworking.h"

typedef NS_ENUM(NSUInteger, NetworkStates) {
    NetworkStatesUnknown, // 不可知的网络环境
    NetworkStatesNone, // 没有网络
    NetworkStatesWWAN, // 2G,3G,4G
    NetworkStatesWIFI // WIFI
};

/* 请求进度的 */
typedef void (^uploadProgressBlock)(NSProgress *uploadProgress);
/* 当request成功后的 responseSuccessBlock */
typedef void (^responseSuccessBlock)(id responseObj);
/* 当request失败后的 requestFailureBlock */
typedef void (^requestFailureBlock)(NSError *error);

@class QBFileConfig;
@interface QBHttpTool : NSObject
+ (void)delete:(NSString *)url params:(NSDictionary *)params success:(responseSuccessBlock)success failure:(requestFailureBlock)failure;
/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(responseSuccessBlock)success failure:(requestFailureBlock)failure;

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params isRawData:(BOOL)isRawData success:(responseSuccessBlock)success failure:(requestFailureBlock)failure;

/**
 上传一张图片

 @param image 上传的图片
 @param url 请求路径
 @param params 请求参数
 @param progress 请求的进度
 @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)uploadImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params progress:(uploadProgressBlock)progress success:(responseSuccessBlock)success failure:(requestFailureBlock)failure;

/**
 上传多张图片

 @param images 上传的图片数组
 @param url 请求路径
 @param params 请求参数
 @param progress 请求的进度
 @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)uploadImages:(NSArray<UIImage *> *)images url:(NSString *)url params:(NSDictionary *)params progress:(uploadProgressBlock)progress success:(responseSuccessBlock)success failure:(requestFailureBlock)failure;
/**上传视频*/
+ (void)uploadVideo:(NSData *)data url:(NSString *)url params:(NSDictionary *)params progress:(uploadProgressBlock)progress success:(responseSuccessBlock)success failure:(requestFailureBlock)failure;
/**上传本地资源文件*/
+ (void)uploadMultipartData:(NSArray *)dataAry fileType:(int)fileType url:(NSString *)url params:(NSDictionary *)params progress:(uploadProgressBlock)progress success:(responseSuccessBlock)success failure:(requestFailureBlock)failure;
/**上传图片和URL地址型gif*/
+ (void)uploadImages:(NSArray <UIImage *>*)images fileUrl:(NSURL *)fileUrl voiceUrl:(NSURL *)voiceUrl url:(NSString *)url params:(NSDictionary *)params progress:(uploadProgressBlock)progress success:(responseSuccessBlock)success failure:(requestFailureBlock)failure;
/** 判断网络类型 */
+ (NetworkStates)getNetworkStates;

@end

/** 网络请求单例 */
@interface QBHttpManager : AFHTTPSessionManager

@property (nonatomic, assign) NetworkStates HYNetworkStates;
@property (nonatomic, strong) NSString *HYNetworkStatesDesc;

+ (instancetype)sharedManager;

@end

@interface QBFileSize : NSObject

/**
 压缩一张图片

 @param sourceImage 源图片
 @param maxSize 最大的图片大小,以KB为单位计
 @return 返回一个二进制流
 */
+ (NSData *)resetSizeOfSourceImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize;

@end
