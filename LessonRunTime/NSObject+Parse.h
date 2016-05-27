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
+ (NSDictionary *)dictObjectTypeInArray;

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
