//
//  Person+Local.m
//  LessonRunTime
//
//  Created by zhangdong on 16/5/20.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import "Person+Property.h"
#import <objc/message.h>

static char contryKey;

@implementation Person (Property)

- (NSString *)contry {
    return objc_getAssociatedObject(self, &contryKey);
}

- (void)setContry:(NSString *)contry {
    
    // 1 要添加属性的对象
    // 2 属性名
    // 3 属性值
    // 4 属性策略
    objc_setAssociatedObject(self, &contryKey, contry, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
