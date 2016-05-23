//
//  UIViewController+Example.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/12.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "UIViewController+Example.h"
#import <objc/runtime.h>

@implementation UIViewController (Example)

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
         
         如果类中不存在要替换的方法，那就先用class_addMethod 和 class_replaceMethod 函数替换两个方法的实现。如果类中已经有了想要替换的方法，那么就调用method_exchangeImplementations 函数交换两个方法的IMP。
         
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
    NSLog(@"%@被销毁了", self);
    
    [self deallocSwizzle];
}

@end
