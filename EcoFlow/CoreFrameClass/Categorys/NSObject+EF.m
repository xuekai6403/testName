//
//  NSObject+EF.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "NSObject+EF.h"

#include <netdb.h>
#include <arpa/inet.h>
#include <ifaddrs.h>

@implementation NSObject (EF)

+ (void)saveString:(NSString *)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getStringForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (UIViewController *)hy_currentViewController {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController *) vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController *) vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        } else {
            break;
        }
    }
    return vc;
}

/*
 获取当前语言环境
 @ return 返回当前语言标示
 */
+ (NSString *)getCurrentLanguage {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    return currentLanguage;
}

+ (NSString *)getIPAddressStr {
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    NSString *netname;
    
    NSString *modelname = [[UIDevice currentDevice]model];

    if ([modelname isEqualToString:@"iPhone Simulator"]) {
        netname = @"en1";
    } else {
        netname = @"en0";
    }

    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:netname]) {
                    break;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    if (temp_addr) {
        UInt32 tmp=0;
        UInt8 IP[4] = {0};
        
        struct sockaddr_in *ipAddr = (struct sockaddr_in *)temp_addr->ifa_addr;
        tmp = ((ipAddr) ? ipAddr->sin_addr.s_addr : 0);
        IP[3] = (UInt8)((tmp>>24)&0xff);
        IP[2] = (UInt8)((tmp>>16)&0xff);
        IP[1] = (UInt8)((tmp>>8)&0xff);
        IP[0] = (UInt8)(tmp&0xff);
        
        return [NSString stringWithFormat:@"%d.%d.%d.%d",IP[0],IP[1],IP[2],IP[3]];
    }
    return nil;
}

+ (UInt32)getIPAdress {
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    NSString *netname;
    
    NSString *modelname = [[UIDevice currentDevice]model];
    
    if ([modelname isEqualToString:@"iPhone Simulator"]) {
        netname = @"en1";
    } else {
        netname = @"en0";
    }
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:netname]) {
                    
                    break;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    if (temp_addr) {
        UInt32 IP = 0;
        
        struct sockaddr_in *ipAddr = (struct sockaddr_in *)temp_addr->ifa_addr;
        IP = ((ipAddr) ? ipAddr->sin_addr.s_addr : 0);
        
        return IP;
    }
    
    return 0;
}

@end
