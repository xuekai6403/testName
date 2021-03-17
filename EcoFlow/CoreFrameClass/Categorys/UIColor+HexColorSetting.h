//
//  UIColor+HexColorSetting.h
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HexColorSetting)

+ (UIColor *)colorWithHextColorString:(NSString *)hexColorString;

@end

NS_ASSUME_NONNULL_END
