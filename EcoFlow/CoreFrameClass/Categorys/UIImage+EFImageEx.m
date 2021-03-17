//
//  UIImage+EFImageEx.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "UIImage+EFImageEx.h"
#import <SDWebImage.h>

@implementation UIImage (EFImageEx)

// SD 异步加载网络图片
+ (void)hy_loadImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholderImage scale:(CGFloat) scale resultBlock:(void (^) (UIImage *image)) resultBlock {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager loadImageWithURL:imageURL options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        UIImage *resultImage;
        if (image && finished) {
            resultImage = [UIImage lf_imageWithNetworkImage:image scale:scale];
            resultBlock(resultImage);
        } else {
            resultBlock([placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]);
        }
    }];
}


// 处理网络图片缩放 scale:根据服务器返回的几倍图定，暂定为 3.0(设置3.0的图后，2.0的可自动适配)
+ (instancetype)lf_imageWithNetworkImage:(UIImage *)image scale:(CGFloat) scale {
    UIImage *img = [UIImage imageWithCGImage:image.CGImage scale:scale orientation:UIImageOrientationUp];
    return [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

// 快速的返回一个最原始的图片
+ (instancetype)lf_imageWithOriRenderingImage:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

// 根据view生成一张图片
+ (UIImage *)lf_imageWithView:(UIView *)view {
    CGRect rect = view.frame;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果(Alpha通道)，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 根据颜色生成一张图片
+ (UIImage *)lf_imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);

    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();

    return theImage;
}

+ (NSData *)compressImageQuality:(UIImage *)image maxSize:(NSInteger)maxSize {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxSize) {
        return data;
    }
    CGFloat max = 1;
    CGFloat min = 0;
    // 二分最大10次，区间范围精度最大可达0.00097657；第6次，精度可达0.015625，10次，0.000977
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxSize * 0.9) {
            min = compression;
        } else if (data.length > maxSize) {
            max = compression;
        } else {
            break;
        }
    }
    
    // 如果二分法之后，还是不符合大小
    if (data.length > maxSize) {
        
        UIImage *resultImage = [UIImage imageWithData:data];
        while (data.length > maxSize) {
            @autoreleasepool {
                CGFloat ratio = (CGFloat)maxSize / data.length;
                // 使用NSUInteger不然由于精度问题，某些图片会有白边
                CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                         (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
                resultImage = [self compressByImageIOFromData:data maxPixelSize:MAX(size.width, size.height)];
                data = UIImageJPEGRepresentation(resultImage, compression);
            }
        }
        
    }
    return data;
}

// 根据指定size 使用 ImageIO 重新绘图
+ (UIImage *)compressByImageIOFromData:(NSData *)data maxPixelSize:(NSUInteger)maxPixelSize
{
    UIImage *imgResult = nil;
    
    if (data == nil) {
        return imgResult;
    }
    if (data.length <= 0) {
        return imgResult;
    }
    if (maxPixelSize <= 0) {
        return imgResult;
    }
    
    const float scale = [UIScreen mainScreen].scale;
    const int sizeTo = maxPixelSize * scale;
    CFDataRef dataRef = (__bridge CFDataRef)data;

    CFDictionaryRef dicOptionsRef = (__bridge CFDictionaryRef) @{
                                                                 (id)kCGImageSourceCreateThumbnailFromImageIfAbsent : @(YES),
                                                                 (id)kCGImageSourceThumbnailMaxPixelSize : @(sizeTo),
                                                                 (id)kCGImageSourceShouldCache : @(YES),
                                                                 };
    CGImageSourceRef src = CGImageSourceCreateWithData(dataRef, nil);
    // 注意：如果设置 kCGImageSourceCreateThumbnailFromImageIfAbsent为 NO，那么 CGImageSourceCreateThumbnailAtIndex 会返回nil
    CGImageRef thumImg = CGImageSourceCreateThumbnailAtIndex(src, 0, dicOptionsRef);
    
    CFRelease(src); // 注意释放对象，否则会产生内存泄露
    
    imgResult = [UIImage imageWithCGImage:thumImg scale:scale orientation:UIImageOrientationUp];
    
    if (thumImg != nil) {
        // 注意释放对象，否则会产生内存泄露
        CFRelease(thumImg);
    }
    
    return imgResult;
}

- (UIImage *)compressWithWidth:(CGFloat)width height:(CGFloat)height
{
    CGSize originSize = self.size;
    CGRect newRect = CGRectMake(0, 0, width, height);
    float ratio = MAX(newRect.size.width / originSize.width, newRect.size.height / originSize.height);
    
    CGRect projectRect;
    projectRect.size.width = ratio * originSize.width;
    projectRect.size.height = ratio * originSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:0];
    [path addClip];
    [self drawInRect:projectRect];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
}


/**
 *  拉伸图片:自定义比例
 */
- (UIImage *)resizeWithleftCap:(CGFloat)leftCap topCap:(CGFloat)topCap
{
    return [self stretchableImageWithLeftCapWidth:self.size.width * leftCap topCapHeight:self.size.height * topCap];
}

/**
 *   拉伸图片
 */
- (UIImage *)resizeImage
{
    return [self resizeWithleftCap:.5f topCap:.5f];
}


/**
 *  压缩图片
 */
- (UIImage*)scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//拉伸图片
+ (UIImage*)resizableImageNamed:(NSString*)imageName
{
    UIImage *tmpImg = [UIImage imageNamed:imageName];
    CGFloat imgWidth = tmpImg.size.width;
    CGFloat imgHeight = tmpImg.size.height;
    return [tmpImg resizableImageWithCapInsets:UIEdgeInsetsMake(imgHeight/2, imgWidth/2, imgHeight/2, imgWidth/2) resizingMode:UIImageResizingModeStretch];
}


//生成缩略图
- (UIImage *)convertToThumbnailWithSize:(CGSize)thumbnailSize
{
    CGSize originSize = self.size;
    CGRect newRect = CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height);
    float ratio = MAX(newRect.size.width / originSize.width, newRect.size.height / originSize.height);
    
    CGRect projectRect;
    projectRect.size.width = ratio * originSize.width;
    projectRect.size.height = ratio * originSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:0];
    [path addClip];
    [self drawInRect:projectRect];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
}

- (UIImage *)getGaussBlurImageWithRadius:(CGFloat)radius
{
    if (radius <= 0)
    {
        return self;
    }
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@(radius) forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:[image extent]];
    UIImage *blurImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    
    return blurImage;
}

-(UIImage*)imageWithMaxWidth:(CGFloat)width
{
    CGFloat oldWidth = self.size.width;
    CGFloat oldHeight = self.size.height;
    CGFloat newWidth =  MIN(width, oldWidth);
    
    CGFloat newHeight = oldHeight *  newWidth/ oldWidth ;
    return [self scaledToSize:CGSizeMake(newWidth, newHeight)];
}

- (NSString *)base64String
{
    NSData *data = UIImagePNGRepresentation(self);
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    
    long double rotate = 0.0;
    
    CGRect rect;
    
    float translateX = 0;
    
    float translateY = 0;
    
    float scaleX = 1.0;
    
    float scaleY = 1.0;
    
    
    
    switch (orientation) {
            
        case UIImageOrientationLeft:
            
            rotate =M_PI_2;
            
            rect =CGRectMake(0,0,image.size.height, image.size.width);
            
            translateX=0;
            translateY= -rect.size.width;
            
            scaleY =rect.size.width/rect.size.height;
            
            scaleX =rect.size.height/rect.size.width;
            
            break;
        case UIImageOrientationRight:
            rotate =3 *M_PI_2;
            
            rect =CGRectMake(0,0,image.size.height, image.size.width);
            
            translateX= -rect.size.height;
            translateY=0;
            
            scaleY =rect.size.width/rect.size.height;
            
            scaleX =rect.size.height/rect.size.width;
            break;
            
        case UIImageOrientationDown:
            
            rotate =M_PI;
            
            rect =CGRectMake(0,0,image.size.width, image.size.height);
            
            translateX= -rect.size.width;
            
            translateY= -rect.size.height;
            
            break;
            
        default:
            rotate =0.0;
            
            rect =CGRectMake(0,0,image.size.width, image.size.height);
            translateX=0;
            translateY=0;
            
            break;
    }
    
    
    //UIGraphicsBeginImageContext(rect.size);=UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);清晰度不好
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);//清晰度更好
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    //做CTM变换
    
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX,translateY);
    CGContextScaleCTM(context, scaleX,scaleY);
    //绘制图片
    
    CGContextDrawImage(context, CGRectMake(0,0,rect.size.width, rect.size.height), image.CGImage);
    UIImage *newPic =UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
    
}

#pragma mark - 获取屏幕截图

+ (UIImage *)getNormalImage:(UIView *)view {
    
    UIGraphicsBeginImageContext(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}
/**获取网络或本地路径图片*/
+ (UIImage *)getImageFromURL:(NSURL *)fileURL {
    
    UIImage *result;
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    result = [UIImage imageWithData:data];
    return result;
}

@end
