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
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self swizzle];
//    });
//}
//
//+ (void)swizzle {
//    
//    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
//    
//    Method method2 = class_getInstanceMethod([self class], @selector(deallocSwizzle));
//    
//    method_exchangeImplementations(method1, method2);
//}
//
//- (void)deallocSwizzle {
//    NSLog(@"%@被销毁了", self);
//    
//    [self deallocSwizzle];
//}

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class aclass = [self class];
        // 当要替换一个类方法的时候使用下面的方法
//        Class aClass = object_getClass((id)self);
        
        SEL originalSelector = NSSelectorFromString(@"dealloc");
        SEL swizzledSelector = @selector(deallocSwizzle);
        
        Method originalMethod = class_getInstanceMethod(aclass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(aclass, swizzledSelector);
        
        /*
         
         Adds a new method to a class with a given name and implementation.
         YES if the method was added successfully, otherwise NO (for example, the class already contains a method implementation with that name).
         
         */
        BOOL didAddMethod = class_addMethod(aclass,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(aclass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)deallocSwizzle {

    [self deallocSwizzle];
}

@end
