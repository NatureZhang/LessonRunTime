//
//  Son.m
//  LessonRunTime
//
//  Created by zhangdong on 16/5/20.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import "Son.h"

@implementation Son
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSLog(@"%@", NSStringFromClass([self class]));
        NSLog(@"%@", NSStringFromClass([super class]));
        
        // 都输出为Son
        // super 是告诉编译器，调用方法时，要去父类的方法中找，而不是本类中
    }
    return self;
}


@end
