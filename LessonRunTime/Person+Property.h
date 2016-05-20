//
//  Person+Local.h
//  LessonRunTime
//
//  Created by zhangdong on 16/5/20.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import "Person.h"

/// 地域
@interface Person (Property)

// 为分类添加属性 不能生成实例变量

@property (nonatomic, strong) NSString *contry;

@end
