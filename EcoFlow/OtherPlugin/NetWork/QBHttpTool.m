//
//  QBHttpTool.m
//  EcoFlow
//

#import "QBHttpTool.h"
#import "EFAccountManager.h"

@implementation QBHttpManager

+ (instancetype)sharedManager {
    static QBHttpManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[QBHttpManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
        
        // 设置json序列化
        _sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        // 设置请求头
        [_sharedManager.requestSerializer setValue:kAppVersions forHTTPHeaderField:@"ver"];
        [_sharedManager.requestSerializer setValue:kAppBulidVersions forHTTPHeaderField:@"vcode"];
        [_sharedManager.requestSerializer setValue:kDeviceUUID forHTTPHeaderField:@"did"];
        [_sharedManager.requestSerializer setValue:kDeviceType forHTTPHeaderField:@"dtype"];
        [_sharedManager.requestSerializer setValue:[QBHttpManager dateTransformToTimeString] forHTTPHeaderField:@"timestamp"];
        [_sharedManager.requestSerializer setValue:kProductID forHTTPHeaderField:@"productId"];
        [_sharedManager.requestSerializer setValue:kAppChannel forHTTPHeaderField:@"channel"];
        [_sharedManager.requestSerializer setValue:kApiVersion forHTTPHeaderField:@"apiVersion"];
                
        if ([EFAccountManager account].appToken.length > 0) {
            [_sharedManager.requestSerializer setValue:[EFAccountManager account].appToken forHTTPHeaderField:@"Authorization"];
        }
        
        // 设置可接受类型
        _sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
        
        // 设置请求超时设定
        _sharedManager.requestSerializer.timeoutInterval = 5.0f;
        
//        __weak typeof(self)weakSelf = self;
        
        _sharedManager.HYNetworkStates = [_sharedManager.reachabilityManager networkReachabilityStatus];

        [_sharedManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            NSString *statusStr = [[NSString alloc] init];
            
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    statusStr = @"未知网络";
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    statusStr = @"当前网络不可用";
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    statusStr = @"当前网络为蜂窝数据";
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    statusStr = @"当前网络为Wi-Fi";
                    break;
                    
                default:
                    break;
            }
            
            _sharedManager.HYNetworkStates = status;
            _sharedManager.HYNetworkStatesDesc = statusStr;
            if ((status == AFNetworkReachabilityStatusUnknown) || (status == AFNetworkReachabilityStatusNotReachable)) {
                [EFProgressHUD showSuccessWithStatus:statusStr];
            }
        }];
        
        // 开始监听
        [_sharedManager.reachabilityManager startMonitoring];
    });
    return _sharedManager;
}

+ (NSString *)dateTransformToTimeString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setDateFormat:@"yyyyMMddHHmmss"];
    NSString *timeString = [df stringFromDate:[NSDate date]];
    return timeString;
}

@end

@implementation QBHttpTool

+ (void)setHttpHeaderToken {
    if ([EFAccountManager account].appToken.length>0) {
        [[QBHttpManager sharedManager].requestSerializer setValue:[EFAccountManager account].appToken forHTTPHeaderField:@"Authorization"];
    } else {
        [[QBHttpManager sharedManager].requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];
    }
}

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(responseSuccessBlock)success failure:(requestFailureBlock)failure;
{
    // 1.判断网络状况 
    NetworkStates states = [self getNetworkStates];
    if (states != NetworkStatesNone) {  // 有网
        
        // 2.发送GET请求
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
        
        [QBHttpTool setHttpHeaderToken];
        
        [[QBHttpManager sharedManager] GET:url parameters:params headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"get请求头%@",task.originalRequest.allHTTPHeaderFields);
            NSLog(@"=====URL: \n%@", task.originalRequest.URL);
            NSLog(@"=====responseObject: \n%@", responseObject);
            if (success) {
                success(responseObject);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"链接是%@",task.originalRequest.URL);
            if (failure) {
                failure(error);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
        }];
    } else {   // 无网
        
        // 显示无网络时的空白页
        NSLog(@"显示无网络时的空白页");
        
        // 发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kNoNetworkNotification object:nil];
    }
}

+ (void)post:(NSString *)url params:(NSDictionary *)params isRawData:(BOOL)isRawData success:(responseSuccessBlock)success failure:(requestFailureBlock)failure
{
    // 1.判断网络状况
    NetworkStates states = [self getNetworkStates];
    if (states != NetworkStatesNone) {  // 有网
        
        // 2.发送POST请求
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
        
        [QBHttpTool setHttpHeaderToken];

        if (isRawData) {
            NSError *error;
            NSData *dataFromDict = [NSJSONSerialization dataWithJSONObject:params
                                                                   options:NSJSONWritingPrettyPrinted
                                                                     error:&error];
                        
            NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[[NSURL URLWithString:url relativeToURL:[QBHttpManager sharedManager].baseURL] absoluteString] parameters:nil error:nil];
            req.timeoutInterval = 30;
            [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

            if ([EFAccountManager account].appToken.length > 0) {
                [req setValue:[EFAccountManager account].appToken forHTTPHeaderField:@"Authorization"];
            } else {
                [req setValue:nil forHTTPHeaderField:@"Authorization"];
            }
            
            [req setHTTPBody:dataFromDict];
            
            NSLog(@"post请求头%@", req.allHTTPHeaderFields);
            
            [[[QBHttpManager sharedManager] dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                
            } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                });
                
                if (!error) {
                    NSLog(@"post响应头%@", httpResponse.allHeaderFields);
                    NSLog(@"=====URL: \n%@", req.URL);
                    NSLog(@"=====responseObject: \n%@", responseObject);
                     
                    NSString *tokenStr = [httpResponse.allHeaderFields valueForKey:@"Authorization"];

                    if (tokenStr.length > 0) {
                        [[EFAccountManager account] updateAppToken:tokenStr];
                    }
                    
                    //TODO:- 处理token过期 重新登录
                    NSInteger code = httpResponse.statusCode;
                    NSLog(@"Response.statusCode:%ld", (long)code);
                    
                    if (code == 500) {
                        [EFAccountManager deleteAccount];
                        [EFAccountManager callLoginPage];
                        return;
                    }
                    
                    if (success && (code == 200)) {
                        success(responseObject);
                    } else {
                        NSLog(@"！！！！！！！！！post请求异常！！！！！！！");
                    }
                    
                } else {
                    NSLog(@"错误消息 Error: %@, %@, %@", error, httpResponse, responseObject);
                    if (failure) {
                        failure(error);
                    }
                }
            }] resume];
            
            return;
        }
        
        [[QBHttpManager sharedManager] POST:url parameters:params headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"post请求头%@",task.originalRequest.allHTTPHeaderFields);
            NSLog(@"=====URL: \n%@", task.originalRequest.URL);
            NSLog(@"=====responseObject: \n%@", responseObject);
                       
            if (success) {
                success(responseObject);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"链接是%@",task.originalRequest.URL);
            if (failure) {
                failure(error);
                NSLog(@"错误,错误消息%@", error);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
        }];
        
    } else {  // 无网
        
        // 显示无网络时的空白页
        
        // post请求不显示为空
        NSLog(@"显示无网络时的空白页");
        
    }
}

+ (void)delete:(NSString *)url params:(NSDictionary *)params success:(responseSuccessBlock)success failure:(requestFailureBlock)failure
{
    // 1.判断网络状况
    NetworkStates states = [self getNetworkStates];
    if (states != NetworkStatesNone) {  // 有网
        
        // 2.发送POST请求
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
        
        [QBHttpTool setHttpHeaderToken];

        [[QBHttpManager sharedManager]DELETE:url parameters:params headers:@{} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                
                success(responseObject);
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"链接是%@",task.originalRequest.URL);
            if (failure) {
                failure(error);
                NSLog(@"错误,错误消息%@", error);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
        }];
        
    } else {  // 无网
        
        // 显示无网络时的空白页
        
        // post请求不显示为空
        NSLog(@"显示无网络时的空白页");
        
    }
}

+ (void)uploadImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params progress:(uploadProgressBlock)progress success:(responseSuccessBlock)success failure:(requestFailureBlock)failure
{
    [self uploadImages:@[image] url:url params:params progress:progress success:success failure:failure];
}

+ (void)uploadImages:(NSArray<UIImage *> *)images url:(NSString *)url params:(NSDictionary *)params progress:(uploadProgressBlock)progress success:(responseSuccessBlock)success failure:(requestFailureBlock)failure
{
    NetworkStates states = [self getNetworkStates];
    if (states != NetworkStatesNone) {  // 有网
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
//        GLJWeakSelf;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //[manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
        
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//        // 设置请求头
//        [manager.requestSerializer setValue:kAppVersions forHTTPHeaderField:@"ver"];
//        [manager.requestSerializer setValue:kAppBulidVersions forHTTPHeaderField:@"vcode"];
//        [manager.requestSerializer setValue:kDeviceUUID forHTTPHeaderField:@"did"];
//        [manager.requestSerializer setValue:kDeviceType forHTTPHeaderField:@"dtype"];
//        [manager.requestSerializer setValue:[QBHttpManager dateTransformToTimeString] forHTTPHeaderField:@"timestamp"];
//        [manager.requestSerializer setValue:kProductID forHTTPHeaderField:@"productId"];
//        [manager.requestSerializer setValue:kAppChannel forHTTPHeaderField:@"channel"];
//        [manager.requestSerializer setValue:kApiVersion forHTTPHeaderField:@"apiVersion"];
//        NSLog(@"请求头是%@",manager.requestSerializer.HTTPRequestHeaders);
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
        
        
        [QBHttpTool setHttpHeaderToken];
        NSLog(@"请求头%@",manager.requestSerializer);
        [manager POST:url parameters:params headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            // 构造数据
            
            for (NSUInteger i=0; i<images.count; i++) {
                UIImage *image = images[i];
                if ([image isKindOfClass:[UIImage class]]) {
                    NSData *data = [QBFileSize resetSizeOfSourceImageData:image maxSize:5000];
                    
                    // 设置fileName,拼接时间
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    NSString *string = [formatter stringFromDate:[NSDate date]];
                    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", string];
                    //此处的name需与后台给的字段一模一样
                    [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
                }
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                progress(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
                NSLog(@"错误,错误消息%@", error);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
        }];
    } else {
        //[EFProgressHUD showErrorWithStatus:@"请求检查网络"];
    }
}

//上传视频
+ (void)uploadVideo:(NSData *)data url:(NSString *)url params:(NSDictionary *)params progress:(uploadProgressBlock)progress success:(responseSuccessBlock)success failure:(requestFailureBlock)failure
{
    NetworkStates states = [self getNetworkStates];
    if (states != NetworkStatesNone) {  // 有网
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
//        GLJWeakSelf;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];

        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
        
        
        [QBHttpTool setHttpHeaderToken];
        NSLog(@"请求头%@",manager.requestSerializer);
        [manager POST:url parameters:params headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            // 构造数据
            
            // 设置fileName,拼接时间
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
//            NSString *string = [formatter stringFromDate:[NSDate date]];
//            NSString *fileName = [NSString stringWithFormat:@"%@.mp4", string];
            
            //此处的name需与后台给的字段一模一样
            [formData appendPartWithFileData:data name:@"file" fileName:@".mp4" mimeType:@"video/mp4"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                progress(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
                NSLog(@"错误,错误消息%@", error);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
        }];
    } else {
        //[EFProgressHUD showErrorWithStatus:@"请求检查网络"];
    }
}

// fileType: 1->.wav, 2->.amr, 3->.mp4, 4->.jpg, 5->.gif
+ (void)uploadMultipartData:(NSArray *)dataAry fileType:(int)fileType url:(NSString *)url params:(NSDictionary *)params progress:(uploadProgressBlock)progress success:(responseSuccessBlock)success failure:(requestFailureBlock)failure {
    
    NetworkStates states = [self getNetworkStates];
    if ((states != NetworkStatesNone) && (dataAry.count > 0)) {  // 有网
        dispatch_main_async_safe_hy(^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
        
        //FIXME:- 未设置请求头
//        [QBHttpTool setHttpHeaderToken];
        
        if ([EFAccountManager account].appToken.length>0) {
            [manager.requestSerializer setValue:[EFAccountManager account].appToken forHTTPHeaderField:@"Authorization"];
        } else {
            [manager.requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];
        }
        
        NSLog(@"upload file请求头:%@\n上传地址:%@", manager.requestSerializer.HTTPRequestHeaders, url);
                
        [manager POST:url parameters:params headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            // 设置fileName,拼接时间
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            
            for (int i = 0; i < dataAry.count; i++) {
                NSData *data = dataAry[i];
                if (fileType == 1) {
                    [formData appendPartWithFileData:data name:@"file" fileName:@".wav" mimeType:@"audio/wav"];
                } else if (fileType == 2) {
                    [formData appendPartWithFileData:data name:@"file" fileName:@".amr" mimeType:@"audio/amr"];
                } else if (fileType == 3) {
                    [formData appendPartWithFileData:data name:@"file" fileName:@".mp4" mimeType:@"video/mp4"];
                } else if (fileType == 4) {
                    [formData appendPartWithFileData:data name:@"file" fileName:@".jpg" mimeType:@"image/jpeg"];
                } else if (fileType == 5) {
                    [formData appendPartWithFileData:data name:@"file" fileName:@".gif" mimeType:@"image/gif"];
                } else {
                    NSAssert(false, @"warning!!! 未设置上传文件类型");
                }
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                progress(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"=====URL: \n%@", task.originalRequest.URL);
            NSLog(@"=====responseObject: \n%@", responseObject);
            if (success) {
                success(responseObject);
            }
            dispatch_main_async_safe_hy(^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
                NSLog(@"错误,错误消息%@", error);
            }
            
            dispatch_main_async_safe_hy(^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
        }];
    } else {
        //[EFProgressHUD showErrorWithStatus:@"请求检查网络"];
    }
}

// 多图片上传
+ (void)uploadImages:(NSArray *)images fileUrl:(NSURL *)fileUrl voiceUrl:(NSURL *)voiceUrl url:(NSString *)url params:(NSDictionary *)params progress:(uploadProgressBlock)progress success:(responseSuccessBlock)success failure:(requestFailureBlock)failure
{
    NetworkStates states = [self getNetworkStates];
    if (states != NetworkStatesNone) {  // 有网
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
//        GLJWeakSelf;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        

        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
        
        
        [QBHttpTool setHttpHeaderToken];
        NSLog(@"请求头%@",manager.requestSerializer);
        [manager POST:url parameters:params headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            // 构造数据

            if (images.count>0) {
                for (NSUInteger i=0; i<images.count; i++) {
                    id model = images[i];
                    if ([model isKindOfClass:[UIImage class]]) {
                        UIImage *image = images[i];
                       
                        NSData *data = [QBFileSize resetSizeOfSourceImageData:image maxSize:5000];
                        
                        // 设置fileName,拼接时间
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        formatter.dateFormat = @"yyyyMMddHHmmssSSS";
                        NSString *string = [formatter stringFromDate:[NSDate date]];
                        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", string];
                        //此处的name需与后台给的字段一模一样
                        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
                        NSLog(@"图片%@",formData);
                    }
                    if ([model isKindOfClass:[NSString class]]) {
                        NSString *str = images[i];
//                        NSURL *url = [NSURL URLWithString:str];
//                        [formData appendPartWithFileURL:url name:@"file" error:nil];
                        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                        [formData appendPartWithFileData:data name:@"file" fileName:@".jpg" mimeType:@"image/jpeg"];
                        NSLog(@"其他%@",formData);
                    }
                    
                }
            }
                    
            if (fileUrl) {
                 [formData appendPartWithFileURL:fileUrl name:@"file" fileName:@".gif" mimeType:@"image/gif" error:nil];
            }
            if (voiceUrl) {//name:@"file" fileName:@".wav" mimeType:@"audio/wav"
                [formData appendPartWithFileURL:voiceUrl name:@"file" fileName:@".wav" mimeType:@"audio/wav" error:nil];
            }
                
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                progress(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
                NSLog(@"错误,错误消息%@", error);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
        }];
    } else {
        //[EFProgressHUD showErrorWithStatus:@"请求检查网络"];
    }
}

// 判断网络类型
+ (NetworkStates)getNetworkStates
{
    return [QBHttpManager sharedManager].HYNetworkStates;
}

@end

@implementation QBFileSize

+ (NSData *)resetSizeOfSourceImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        return finallImageData;
    }
    return imageData;
}

@end

/** 用来封装上传参数 */
//@implementation QBFileConfig
//
//+ (instancetype)fileConfigWithfileData:(NSData *)fileData
//                                  name:(NSString *)name
//                              fileName:(NSString *)fileName
//                              mimeType:(NSString *)mimeType {
//
//    return [[self alloc] initWithfileData:fileData
//                                     name:name
//                                 fileName:fileName
//                                 mimeType:mimeType];
//}
//
//- (instancetype)initWithfileData:(NSData *)fileData
//                            name:(NSString *)name
//                        fileName:(NSString *)fileName
//                        mimeType:(NSString *)mimeType {
//
//    if (self = [super init]) {
//
//        _fileData = fileData;
//        _name = name;
//        _fileName = fileName;
//        _mimeType = mimeType;
//    }
//    return self;
//}
//
//@end
