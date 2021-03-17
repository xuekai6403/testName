//
//  UIColor+HexColorSetting.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "UIColor+HexColorSetting.h"

@implementation UIColor (HexColorSetting)

+ (UIColor *)colorWithHextColorString:(NSString *)hexColorString {
    //这里是alpha传1，在colorWithHextColorString alpha 里面做了alpha修改
    return [self colorWithHextColorString:hexColorString alpha:1.0f];
}

//支持rgb,argb
+ (UIColor *)colorWithHextColorString:(NSString *)hexColorString alpha:(CGFloat)alphaValue {
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    //排除掉  @\"
    if ([hexColorString hasPrefix:@"@\""]) {
        hexColorString = [hexColorString substringWithRange:NSMakeRange(2, hexColorString.length-3)];
    }
    
    //排除掉 0x
    if ([hexColorString hasPrefix:@"0X"])
    {
        hexColorString = [hexColorString substringFromIndex:2];
    }
    
    //排除掉 #
    if ([hexColorString hasPrefix:@"#"]) {
        hexColorString = [hexColorString substringFromIndex:1];
    }

    if (nil != hexColorString) {
        NSScanner *scanner = [NSScanner scannerWithString:hexColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    
    if ([hexColorString length]==8) {   //如果是8位，就那其中的alpha
        alphaValue = (float)(unsigned char)(colorCode>>24)/0xff;
    }
    
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte / 0xff
              blue: (float)blueByte / 0xff
              alpha:alphaValue];
    return result;
    
}

@end
