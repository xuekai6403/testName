//
//  UIWindow+ConfigRootVC.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "UIWindow+ConfigRootVC.h"

#import "EFTabBarVC.h"

@implementation UIWindow (ConfigRootVC)

#pragma mark - 设置窗口的根控制器
- (void)setupRootViewControllerWithIndex:(NSInteger)index {
    [self getAppInitData];
    EFAccountItem *account = [EFAccountManager account];
    
    //FIXME:- tase code
//    EFTabBarVC *tabbarVC = [EFTabBarVC new];
//    tabbarVC.selectedIndex = 0;
//    self.rootViewController = tabbarVC;
//    return;
    
    if ((account.appToken.length > 0) && (account.LoginFlag.length > 0)) {
        EFTabBarVC *tabbarVC = [EFTabBarVC new];
        tabbarVC.selectedIndex = index;
        self.rootViewController = tabbarVC;
    } else {
        [EFAccountManager callLoginPage];
    }
}

- (void)getAppInitData {
           
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [QBBaseNetTool postWithUrl:@"app/sys/element/init" param:@{@"did":kDeviceUUID,@"dtype":kDeviceType,@"channel":kAppChannel,@"productId":kProductID,@"vcode":kAppBulidVersions,@"ver":kAppVersions} resultClass:[EFAppLaunchInfoEx class] success:^(EFAppLaunchInfoEx *responseObj) {
//            if (responseObj.data != nil) {
//                dispatch_main_async_safe_hy(^{
//                    [EFAppLaunchInfoManager saveLaunchInfo:responseObj.data];
//                });
//
//            }
//
//        } failure:^(NSError *error) {
//            NSLog(@"%@", error);
//        }];
//    });
    
}

@end
