//
//  UIWindow+ConfigRootVC.h
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (ConfigRootVC)

/**
 *  设置窗口的根控制器
 */
- (void)setupRootViewControllerWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
