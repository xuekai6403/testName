//
//  UIImageView+EFImageViewEx.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "UIImageView+EFImageViewEx.h"
#import <SDWebImage.h>

@implementation UIImageView (EFImageViewEx)

/** 利用SD获取网络图片 */
- (void)hy_getNetworkImage:(NSString *)imageNetworkPath placeholderImage:(UIImage *)placeholderImage {
    [self sd_setImageWithURL:[NSURL URLWithString:imageNetworkPath] placeholderImage:placeholderImage];
}

@end
