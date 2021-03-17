//
//  EFProgressHUD.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "EFProgressHUD.h"

@implementation EFProgressHUD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultStyle:SVProgressHUDStyleCustom];
        [self setBackgroundColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.8]];
        [self setForegroundColor:[UIColor whiteColor]];
        [self setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [self setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
        [self setCornerRadius:6];
        [self setFont:[UIFont systemFontOfSize:15]];
        [self setSuccessImage:[UIImage imageNamed:@""]];
        [self setErrorImage:[UIImage imageNamed:@""]];
        [self setInfoImage:[UIImage imageNamed:@""]];
        [self setMaximumDismissTimeInterval:30.0];
        [self setMinimumDismissTimeInterval:2.0];
        [self setMinimumSize:CGSizeMake(30, 30)];
    }
    return self;
}

@end
