//
//  UIImage+EFImageEx.h
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (EFImageEx)

/// SD 异步加载网络图片
+ (void)hy_loadImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage scale:(CGFloat) scale resultBlock:(void (^) (UIImage *image)) resultBlock;

/// 处理网络图片缩放 scale:根据服务器返回的几倍图定，暂定为 3.0(设置3.0的图后，2.0的可自动适配)
+ (instancetype)lf_imageWithNetworkImage:(UIImage *)image scale:(CGFloat) scale;

/** 快速的返回一个最原始的图片 */
+ (instancetype)lf_imageWithOriRenderingImage:(NSString *)imageName;

/** 根据view生成一张图片 */
+ (UIImage *)lf_imageWithView:(UIView *)view;

/** 根据颜色生成一张图片 */
+ (UIImage *)lf_imageWithColor:(UIColor *)color;

- (UIImage *)compressWithWidth:(CGFloat)width height:(CGFloat)height;

/// 压缩图片到指定大小
/// @param image 目标图片
/// @param maxSize 需要压缩到的byte值 例如100 * 1024  100kb以内
+ (NSData *)compressImageQuality:(UIImage *)image maxSize:(NSInteger)maxSize;

/**
 *  拉伸图片:自定义比例
 */
- (UIImage *)resizeWithleftCap:(CGFloat)leftCap topCap:(CGFloat)topCap;

/**
 *  拉伸图片
 */
- (UIImage *)resizeImage;

/**
 *  改变图片为指定的size
 *
 *  @param newSize 指定大小
 *
 *  @return 新图片
 */
- (UIImage*)scaledToSize:(CGSize)newSize;

/**
 *  拉伸图片
 *
 *  @param imageName 要拉伸的图片
 *
 *  @return 拉伸后的图片
 */
+(UIImage*)resizableImageNamed:(NSString*)imageName;

/**
 *  将当前图片转换成指定大小的缩略图
 *
 *  @param thumbnailSize 缩略图大小
 *
 *  @return 缩略图
 */
- (UIImage *)convertToThumbnailWithSize:(CGSize)thumbnailSize;

/**
 *  获取高斯模糊照片
 */
- (UIImage *)getGaussBlurImageWithRadius:(CGFloat)radius;

/**
 *  压缩为固定宽度的图片
 *
 *  @param width 宽度
 *
 *  @return 压缩图
 */

-(UIImage*)imageWithMaxWidth:(CGFloat)width;

- (NSString *)base64String;
/**旋转图片*/
+(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
/**屏幕截图*/
+ (UIImage *)getNormalImage:(UIView *)view;
/**网络获取图片*/
+(UIImage *) getImageFromURL:(NSURL *)fileURL;

@end

NS_ASSUME_NONNULL_END
