//
//  AppDelegate.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "AppDelegate.h"

#import "UIWindow+ConfigRootVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    EFAccountItem *account = [EFAccountManager account];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    //第一次启动
        account.isFirstLaunch = YES;
    }else{
    //不是第一次启动了
        account.isFirstLaunch = NO;
    }
    [EFAccountManager save:account];
    [UIViewController setStatusBarStyleWhite:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self configKeyBoard];
        
    [self.window setupRootViewControllerWithIndex:0];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)configKeyBoard{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    
    //keyboardManager.enableDebugging = YES;
}

@end
