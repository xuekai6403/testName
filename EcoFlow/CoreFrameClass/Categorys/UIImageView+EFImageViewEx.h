//
//  UIImageView+EFImageViewEx.h
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (EFImageViewEx)

/** SD获取网络图片 */
- (void)hy_getNetworkImage:(NSString *)imageNetworkPath placeholderImage:(UIImage *)placeholderImage;

@end

NS_ASSUME_NONNULL_END
