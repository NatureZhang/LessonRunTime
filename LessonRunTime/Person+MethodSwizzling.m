//
//  Person+MethodSwizzling.m
//  LessonRunTime
//
//  Created by zhangdong on 16/5/20.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import "Person+MethodSwizzling.h"
#import <objc/runtime.h>

@implementation Person (MethodSwizzling)

#pragma mark - swizzle
+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzle];
    });
}

+ (void)swizzle {
    
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    
    Method method2 = class_getInstanceMethod([self class], NSSelectorFromString(@"deallocSwizzle"));
    
    method_exchangeImplementations(method1, method2);
}

- (void)deallocSwizzle {
    NSLog(@"%@被销毁了", self);
    
    [self deallocSwizzle];
}

@end
