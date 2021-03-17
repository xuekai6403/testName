//
//  LFBaseTool.m
//  EcoFlow
//

#import "QBBaseNetTool.h"
#import "MJExtension.h"

@implementation QBBaseNetTool

+ (void)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;
{
    [QBHttpTool get:url params:[self dealParam:param] success:^(id responseObj) {
        if (success) {
            if (resultClass) { // 有传resultClass,内部用MJExtension做好字典转模型操作
                if ([responseObj isKindOfClass:NSDictionary.class]) {
                    id result = [resultClass mj_objectWithKeyValues:responseObj];
                    success(result);
                    
                    //TODO:- 处理token过期 重新登录
                    NSInteger code = [responseObj[@"code"] integerValue];
                    NSString *msg = (NSString *)responseObj[@"message"];
                    if ((code != 0) && (code != 200) && (msg.length > 0)) {
                        [EFProgressHUD showErrorWithStatus:msg];
                    }
                    
                    if ((code == 500) && ([msg rangeOfString:@"重新登录"].length > 0)) {
                        [EFAccountManager deleteAccount];
                        [EFAccountManager callLoginPage];
                    }
                }
                if ([responseObj isKindOfClass:NSArray.class]) {
                    id result = [resultClass mj_objectArrayWithKeyValuesArray:responseObj];
                    success(result);
                }
                if (!responseObj) {//特殊情况，成功返回空
                    success(nil);
                }
            } else { // 没有传resultClass,外部自行处理字典转模型操作
                success(responseObj);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)postWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass isRawData:(BOOL)isRawData success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;
{
    [QBHttpTool post:url params:[self dealParam:param] isRawData:isRawData success:^(id responseObj) {
        if (success) {
            if (resultClass) { // 有传resultClass,内部用MJExtension做好字典转模型操作
                if ([responseObj isKindOfClass:NSDictionary.class]) {
                    id result = [resultClass mj_objectWithKeyValues:responseObj];
                    success(result);
                    
                    //TODO:- 处理token过期 重新登录
                    NSInteger code = [responseObj[@"code"] integerValue];
                    NSString *msg = (NSString *)responseObj[@"message"];
                    if ((code != 0) && (code != 200) && (msg.length > 0)) {
                        [EFProgressHUD showErrorWithStatus:msg];
                    }
                    
                    if ((code == 500) && ([msg rangeOfString:@"重新登录"].length > 0)) {
                        [EFAccountManager deleteAccount];
                        [EFAccountManager callLoginPage];
                    }
                }
                if ([responseObj isKindOfClass:NSArray.class]) {
                    id result = [resultClass mj_objectArrayWithKeyValuesArray:responseObj];
                    success(result);
                }
                if (!responseObj) {//特殊情况，成功返回空
                    success(nil);
                }
            } else { // 没有传resultClass,外部自行处理字典转模型操作
                success(responseObj);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//delete
+ (void)deleteWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;
{
    [QBHttpTool delete:url params:[self dealParam:param] success:^(id responseObj) {
        if (success) {
            if (resultClass) { // 有传resultClass,内部用MJExtension做好字典转模型操作
                if ([responseObj isKindOfClass:NSDictionary.class]) {
                    id result = [resultClass mj_objectWithKeyValues:responseObj];
                    success(result);
                }
                if ([responseObj isKindOfClass:NSArray.class]) {
                    id result = [resultClass mj_objectArrayWithKeyValuesArray:responseObj];
                    success(result);
                }
            } else { // 没有传resultClass,外部自行处理字典转模型操作
                success(responseObj);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (NSDictionary *)dealParam:(id)param {
    // 参数处理
    NSDictionary *params = [NSDictionary dictionary];
    if ([param isKindOfClass:NSDictionary.class]) { // 字典,直接赋值
        params = param;
    } else { // 模型,模型转为字典后赋值
        params = [param mj_keyValues];
    }
    return params;
}

@end
