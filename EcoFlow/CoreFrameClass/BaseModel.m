//
//  BaseModel.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "BaseModel.h"

@implementation BaseModel

- (NSString *)description
{
    return [self autoDescription];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
