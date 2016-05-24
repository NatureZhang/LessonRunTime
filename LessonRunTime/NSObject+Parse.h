//
//  NSObject+Parse.h
//  LessonRunTime
//
//  Created by zhangdong on 16/5/20.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParseKeyValueProtocol <NSObject>

@optional
+ (NSDictionary *)dictObjectClassInArray;

// 假设这种情况  一个数组  数组里是不同的模型这种情况怎么处理呢？？

@end

@interface NSObject (Parse)<ParseKeyValueProtocol>

/// 最外层是数组
+ (NSArray *)objectArrayWithValueArray:(NSArray *)valueArray;

/// 字典 转 模型
+ (instancetype)objectWithKeyValues:(NSDictionary *)keyValues;

/// 模型 转 字典
- (NSDictionary *)dictInstanceKeyValues;

+ (NSArray *)arrayKeyValuesWithObjectArray:(NSArray *)arrObject;
@end
