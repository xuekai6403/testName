//
//  LFBaseTool.h
//  EcoFlow
//

#import <Foundation/Foundation.h>
#import "QBHttpTool.h"

@interface QBBaseNetTool : NSObject


/**
 get请求

 @param url 请求的url
 @param param 请求的参数,可传字典和模型,内部已做处理
 @param resultClass 传了之后,不用再手动去字典转模型;不传递,需要自己手动去字典转模型
 @param success 成功的回调,可以拿到请求得到的字典
 @param failure 失败的回调
 */
+ (void)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/**
 post请求
 
 @param url 请求的url
 @param param 请求的参数,可传字典和模型,内部已做处理
 @param resultClass 传了之后,不用再手动去字典转模型;不传递,需要自己手动去字典转模型
 @param success 成功的回调,可以拿到请求得到的字典
 @param failure 失败的回调
 */
+ (void)postWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass isRawData:(BOOL)isRawData success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;
+ (void)deleteWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;
@end
