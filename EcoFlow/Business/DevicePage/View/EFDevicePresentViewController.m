//
//  EFDevicePresentViewController.m
//  EcoFlow
//
//  Created by Curry on 2021/3/16.
//

#import "EFDevicePresentViewController.h"

@implementation EFDevicePresentViewController{
    NSInteger _statue;
}
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        // 必须设置 presentedViewController 的 modalPresentationStyle
        // 在自定义动画效果的情况下，苹果强烈建议设置为 UIModalPresentationCustom
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
        
        UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [presentedViewController.view addGestureRecognizer:tap];
    }
    
    return self;
}
- (void)pan:(UIPanGestureRecognizer*)swipe{
    if (swipe.state == UIGestureRecognizerStateChanged) {
        [self commitTranslation:[swipe translationInView:self.presentedView]];
    }
    if (swipe.state == UIGestureRecognizerStateEnded) {
        if (_statue == 1) {
            [UIView animateWithDuration:0.20 animations:^{
                self.presentedView.frame = CGRectMake(0, 100, ScreenWidth, ScreenHeight-100-KTabBarHeight);
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [UIView animateWithDuration:0.15 animations:^{
                self.presentedView.frame = CGRectMake(0, ScreenHeight-400, ScreenWidth, 400-KTabBarHeight);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}
/** 判断手势方向  */
- (void)commitTranslation:(CGPoint)translation {
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    // 设置滑动有效距离
    if (MAX(absX, absY) < 10)
        return;
    if (absX > absY ) {
        if (translation.x<0) {//向左滑动
        }else{//向右滑动
        }
    } else if (absY > absX) {
        if (translation.y<0) {//向上滑动
            if (self.presentedView.frame.origin.y>100) {
                [UIView animateWithDuration:0.20 animations:^{
                    self.presentedView.frame = CGRectMake(0, ScreenHeight-400-absY, ScreenWidth, (400+absY)-KTabBarHeight);
                } completion:^(BOOL finished) {
                    
                }];
            }
            _statue = 1;
        }else{ //向下滑动
            if (self.presentedView.frame.origin.y<ScreenHeight-400) {
                [UIView animateWithDuration:0.20 animations:^{
                    self.presentedView.frame = CGRectMake(0, 100+absY, ScreenWidth, ScreenHeight-100-absY-KTabBarHeight);
                } completion:^(BOOL finished) {
                    
                }];
            }
            _statue = 2;
        }
    }
}
- (CGRect)frameOfPresentedViewInContainerView{
    return CGRectMake(0, ScreenHeight-400, ScreenWidth, 400-KTabBarHeight);
}

- (UIPresentationController* )presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return self;
}
@end
