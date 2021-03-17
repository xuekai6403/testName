//
//  EFAppLaunchInfoEx.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "EFAppLaunchInfoEx.h"

@implementation EFAppLaunchInfoEx

@end

@implementation EFAppLaunchInfo

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"agree" : [AppAgreeInfo class],
             @"welcome" : [AppWelcomeInfo class]
             };
}

MJCodingImplementation

@end

@implementation AppAgreeInfo

MJCodingImplementation

@end

@implementation AppTabInfo

MJCodingImplementation

@end

@implementation AppWelcomeInfo

MJCodingImplementation

@end
