//
//  NSObject+EF.h
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (EF)

+ (void)saveString:(NSString *)value forKey:(NSString *)key;

+ (NSString *)getStringForKey:(NSString *)key;

+ (UIViewController *)hy_currentViewController;

+ (NSString *)getCurrentLanguage;

+ (NSString *)getIPAddressStr;

+ (UInt32)getIPAdress;
@end

NS_ASSUME_NONNULL_END
