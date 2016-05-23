//
//  Person.m
//  LessonRunTime
//
//  Created by zhangdong on 16/5/20.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import "Bird.h"
@interface Person ()
{
    NSNumber *height;
}


@end

@implementation Person

- (void)jump {
    NSLog(@"我会跳不会飞！！！！");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    /*
     
     如果当前对象调用了一个不存在的方法
     Runtime会调用resolveInstanceMethod:来进行动态方法解析
     我们需要用class_addMethod 函数完成向特定类添加特定方法实现的操作
     如果返回NO，则进入forwardingTargetForSelector:
     
     */
    
#if 1
    return NO;
#else
    class_addMethod([self class], sel, class_getMethodImplementation([self class], @selector(jump)), "v@:");
    return [super resolveInstanceMethod:sel];
#endif
}

- (id)forwardingTargetForSelector:(SEL)aSelector {

    /*
     
     通过重载forwardingTargetForSelector:方法来替换消息的接收者为其他对象
     返回nil则进入下一步forwardInvocation:
     
     */
    
#if 0
    return nil;
#else
    return [[Bird alloc] init];
#endif
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    // 获取方法签名进入下一步，进行消息转发
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    // 消息转发
    return [anInvocation invokeWithTarget:[[Bird alloc] init]];
}
@end
