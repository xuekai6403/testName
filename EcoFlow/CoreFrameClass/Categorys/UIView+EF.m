//
//  UIView+EF.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/10.
//

#import "UIView+EF.h"

@implementation UIView (EF)

- (void)setUIKitShortLockTime {
    self.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
    });
}

#pragma mark - 插入view
- (BOOL)lf_intersectWithView:(UIView *)view
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect selfRect = [self convertRect:self.bounds toView:window];
    CGRect viewRect = [view convertRect:view.bounds toView:window];
    return CGRectIntersectsRect(selfRect, viewRect);
}

#pragma mark - 拿到当前视图所在的控制器
- (UIViewController *)lf_currentViewController
{
    return [NSObject hy_currentViewController];
}

#pragma mark - 视图背景添加毛玻璃效果
- (void)addBlurEffect:(UIBlurEffectStyle)style alpha:(CGFloat)alpha
{
    //创建毛玻璃效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:style];
    //创建毛玻璃视图
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
    visualView.frame = self.bounds;
    visualView.alpha = alpha;
    //添加到view上
    [self insertSubview:visualView atIndex:0];
}

- (CGFloat)lf_topY {
    return self.frame.origin.y;
}

- (void)setLf_topY:(CGFloat)topY {
    self.frame = CGRectMake(self.frame.origin.x, topY, self.bounds.size.width, self.bounds.size.height);
}

// 宽度
- (CGFloat)lf_width
{
    return self.bounds.size.width;
}
- (void)setLf_width:(CGFloat)lf_width
{
    CGRect frame = self.frame;
    frame.size.width = lf_width;
    self.frame = frame;
}

// 高度
- (CGFloat)lf_height
{
    return self.bounds.size.height;
}
- (void)setLf_height:(CGFloat)lf_height
{
    CGRect frame = self.frame;
    frame.size.height = lf_height;
    self.frame = frame;
}

// x
- (CGFloat)lf_x
{
    return self.frame.origin.x;
}
- (void)setLf_x:(CGFloat)lf_x
{
    CGRect frame = self.frame;
    frame.origin.x = lf_x;
    self.frame = frame;

}

// y
- (CGFloat)lf_y
{
    return self.frame.origin.y;
}
- (void)setLf_y:(CGFloat)lf_y
{
    CGRect frame = self.frame;
    frame.origin.y = lf_y;
    self.frame = frame;

}


- (void)setLf_centerX:(CGFloat)lf_centerX{
    CGPoint center = self.center;
    center.x = lf_centerX;
    self.center = center;
}

- (CGFloat)lf_centerX
{
    return self.center.x;
}

- (void)setLf_centerY:(CGFloat)lf_centerY{
    CGPoint center = self.center;
    center.y = lf_centerY;
    self.center = center;
}

- (CGFloat)lf_centerY
{
    return self.center.y;
}

- (void)setLf_size:(CGSize)lf_size
{
    CGRect frame = self.frame;
    frame.size = lf_size;
    self.frame = frame;
}

- (CGSize)lf_size
{
    return self.frame.size;
}


#pragma mark - 设置 view 的部分圆角
// corners(枚举类型，可组合使用)：UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
// 调用示例 [UIView br_setView:_alertView roundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadius:self.pickerStyle.topCornerRadius];
+ (void)br_setView:(UIView *)view roundingCorners:(UIRectCorner)corners withRadius:(CGFloat)radius {
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *shape = [[CAShapeLayer alloc]init];
    [shape setPath:rounded.CGPath];
    view.layer.mask = shape;
}


@end
