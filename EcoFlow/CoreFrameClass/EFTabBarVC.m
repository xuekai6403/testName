//
//  EFTabBarVC.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "EFTabBarVC.h"

#import "EFDeviceHomeViewController.h"
#import "EFDiscoverPageViewController.h"
#import "EFMyPageViewController.h"


@interface EFTabBarVC ()<UITabBarControllerDelegate>

@property (nonatomic, assign) NSInteger lastSelectedIndex;

@end

@implementation EFTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    
    self.lastSelectedIndex = 0;
    
    [self addAllChildController];
    
    // 2.1 正常状态下的文字
    NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
    normalAttr[NSForegroundColorAttributeName] = EFColorHex(@"#C7C7CC");

    // 2.2 选中状态下的文字
    NSMutableDictionary *selectedAttr = [NSMutableDictionary dictionary];
    selectedAttr[NSForegroundColorAttributeName] = EFColorHex(@"#1D1D1D");
    
    
    if (@available(iOS 13.0, *)) {

        UITabBarAppearance *tabBarAppearance = [[UITabBarAppearance alloc] init];
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttr.copy;
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttr.copy;
        tabBarAppearance.backgroundImage = [UIImage lf_imageWithColor:[UIColor whiteColor]];
        tabBarAppearance.shadowColor = EFColorHex(@"#FFFFFF");
        self.tabBar.standardAppearance = tabBarAppearance;
        
    } else {
        
        [[UITabBarItem appearance] setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
        [[UITabBarItem appearance] setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
        
        self.tabBar.shadowImage = [UIImage lf_imageWithColor:EFColorHex(@"#FFFFFF")];
        self.tabBar.backgroundImage = [UIImage lf_imageWithColor:[UIColor whiteColor]];
    }
    
}

#pragma mark -添加所有的子控制器
- (void)addAllChildController {
    // device
    EFDeviceHomeViewController *deviceVC = [[EFDeviceHomeViewController alloc] init];
    [self addOneViewController:deviceVC image:@"tab_default_home" selectedImage:@"tab_pressed_home" title:@"Device"];

    // discover
    EFDiscoverPageViewController *discoverVC = [[EFDiscoverPageViewController alloc] init];
    [self addOneViewController:discoverVC image:@"tab_default_home" selectedImage:@"tab_pressed_home" title:@"Discover"];

    // my
    EFMyPageViewController *myPageVC = [[EFMyPageViewController alloc] init];
    [self addOneViewController:myPageVC image:@"tab_default_home" selectedImage:@"tab_pressed_home" title:@"My"];

}


#pragma mark - 添加单个控制器
- (void)addOneViewController:(UIViewController *)childViewController image:(NSString *)imageName selectedImage:(NSString *)selectedImageName title:(NSString *)title
{
    ZXNavigationBarNavigationController *nav = [[ZXNavigationBarNavigationController alloc] initWithRootViewController:childViewController];
    
    nav.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    
    
    // 1.1.1 设置tabBar文字
    nav.tabBarItem.title = title;
    
    // 1.1.2 设置正常状态下的图标
    if (imageName.length) { // 图片名有具体
        nav.tabBarItem.image =  [UIImage lf_imageWithOriRenderingImage:imageName];
        // 1.1.3 设置选中状态下的图标
        nav.tabBarItem.selectedImage = [UIImage lf_imageWithOriRenderingImage:selectedImageName];
    }
        
    // 1.1.5 添加tabBar为控制器的子控制器
    [self addChildViewController:nav];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[ZXNavigationBarNavigationController class]]) {
        ZXNavigationBarNavigationController *navVC = (ZXNavigationBarNavigationController *)viewController;
        UIViewController *curRootVC = navVC.viewControllers.firstObject;
        
        for (int index=0; index<self.tabBar.items.count; index++) {
            
            ZXNavigationBarNavigationController *navvVC = (ZXNavigationBarNavigationController *)tabBarController.viewControllers[index];
            UIViewController *rootVC = navvVC.viewControllers.firstObject;
            
            if (index == 0) {
//                HYHomeVC *vc = (HYHomeVC *)rootVC;
                
//                if ((index == tabBarController.selectedIndex) && (vc.isShowScrollToTop == YES)) {
//                    [vc recoverTabbarOriginItem:NO];
//                }
//
//                if ((index != tabBarController.selectedIndex) && (vc.isShowScrollToTop == YES)) {
//                    vc.isScrolling = NO;
//                    [vc recoverTabbarOriginItem:YES];
//                    vc.isShowScrollToTop = YES;
//                }
                
            }
        }
        
//        if ([curRootVC isKindOfClass:[HYHomeVC class]]) {
//            HYHomeVC *vc = (HYHomeVC *)curRootVC;
//            if ((vc.isScrolling == NO) && (vc.isShowScrollToTop == YES) && (self.lastSelectedIndex == tabBarController.selectedIndex)) {
//                [vc reloadWebView:0];
//            }
//        }
        
    }
    self.lastSelectedIndex = tabBarController.selectedIndex;
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}



@end
