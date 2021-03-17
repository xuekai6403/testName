//
//  EFSingleMacro.h
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#ifndef EFSingleMacro_h
#define EFSingleMacro_h

#pragma mark - 单例模式 .h文件内容
#define SingleInterface(className) +(instancetype)share##className;

#pragma mark - 单例模式 .m文件内容
#if __has_feature(objc_arc)
// 宏中 \ 用于拼接较长的字符串
#define SingleImplementation(className) \
static id instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        instance = [super allocWithZone:zone];\
    });\
    return instance;\
}\
+ (instancetype)share##className {\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        instance = [[self alloc] init];\
    });\
    return instance;\
}\
- (id)copyWithZone:(NSZone *)zone {\
    return instance;\
}\
- (id)mutableCopyWithZone:(NSZone *)zone {\
    return instance;\
}

#else

#define SingleImplementation(className) \
static id instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        instance = [super allocWithZone:zone];\
    });\
    return instance;\
}\
+ (instancetype)share##className {\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        instance = [[self alloc] init];\
    });\
    return instance;\
}\
- (id)copyWithZone:(NSZone *)zone {\
    return instance;\
}\
- (oneway void)release {}\
- (instancetype)retain {return instance;}\
- (instancetype)autorelease {return instance;}\
- (NSUInteger)retainCount {return ULONG_LONG_MAX;}

#endif

#endif /* EFSingleMacro_h */
