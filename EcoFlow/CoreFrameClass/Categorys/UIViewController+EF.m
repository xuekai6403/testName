//
//  UIViewController+EF.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "UIViewController+EF.h"

@implementation UIViewController (EF)

// 设置状态栏字体样式: YES -> 白色字体
+ (void)setStatusBarStyleWhite:(BOOL)isWhite {
    if (isWhite) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        if(@available(iOS 13.0, *)) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    }
    
}

@end
