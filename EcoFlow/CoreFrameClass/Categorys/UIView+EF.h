//
//  UIView+EF.h
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (EF)

/// 设置控件短时间锁定，防止频繁点击
- (void)setUIKitShortLockTime;

/// 插入view
- (BOOL)lf_intersectWithView:(UIView *)view;

/// 拿到当前视图所在的控制器
- (UIViewController *)lf_currentViewController;

@property (nonatomic, assign) CGFloat lf_width;
@property (nonatomic, assign) CGFloat lf_height;
@property (nonatomic, assign) CGFloat lf_x;
@property (nonatomic, assign) CGFloat lf_y;
@property (nonatomic, assign) CGFloat lf_topY;
@property (nonatomic, assign) CGFloat lf_centerX;
@property (nonatomic, assign) CGFloat lf_centerY;
@property (nonatomic, assign) CGSize lf_size;

/// 视图背景添加毛玻璃效果
- (void)addBlurEffect:(UIBlurEffectStyle)style alpha:(CGFloat)alpha;

/// 设置 view 的部分圆角
+ (void)br_setView:(UIView *)view roundingCorners:(UIRectCorner)corners withRadius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
