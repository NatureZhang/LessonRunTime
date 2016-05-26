//
//  NSObject+Parse.m
//  LessonRunTime
//
//  Created by zhangdong on 16/5/20.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import "NSObject+Parse.h"
#import <objc/runtime.h>

@implementation NSObject (Parse)

+ (NSArray *)objectArrayWithValueArray:(NSArray *)valueArray {

    NSMutableArray *arrayModel = [NSMutableArray array];
    NSArray *tmpArray = valueArray;
    
    // 遍历
    for (int i = 0; i < tmpArray.count; i ++) {
        
        id object = tmpArray[i];
        if ([object isFoundationClass]) {
            [arrayModel addObject:object];
        }
        
        if ([object isKindOfClass:[NSArray class]]) {
            
            [arrayModel addObject:[self objectArrayWithValueArray:object]];
            
        }
        
        if ([object isKindOfClass:[NSDictionary class]]) {
            
            id model = [self objectWithKeyValues:object];
            [arrayModel addObject:model];
            
        }
    }
    
    return arrayModel;
}

/// 字典转模型
+ (instancetype)objectWithKeyValues:(NSDictionary *)keyValues {
    
    // 创建一个对象
    id object = [[self alloc] init];
    
    unsigned int pCount = 0;
    
    objc_property_t *properties = class_copyPropertyList([object class], &pCount);
    
    for (int i = 0; i < pCount; i ++) {
        
        // 取出属性名
        const char *pName = property_getName(properties[i]);
        NSString *pNameStr = [NSString stringWithUTF8String:pName];

        // 取出字典中与属性名一样的值
        id pValue = keyValues[pNameStr];
        
        // 当值的类型是字典时
        if ([pValue isKindOfClass:[NSDictionary class]]) {
            
            // T@"ClassName",&,N,V_user
            NSString *pAttri = @(property_getAttributes(properties[i]));
            NSRange range1 = [pAttri rangeOfString:@"\""];//第一个引号
            NSString *tmpStr = [pAttri substringFromIndex:range1.location+range1.length];
            NSRange range2 = [tmpStr rangeOfString:@"\""];//第二个引号
            NSString *pClass = [tmpStr substringToIndex:range2.location];
            
            pValue = [NSClassFromString(pClass) objectWithKeyValues:pValue];
        }
        
        // 当值的类型为数组时
        if ([pValue isKindOfClass:[NSArray class]]) {
            
            NSArray *arrayValues = pValue;
            NSMutableArray *arrMTemp = [NSMutableArray array];
            
            for (int i = 0; i < arrayValues.count; i ++) {
                
                id item = [arrayValues objectAtIndex:i];
                
                if ([item isFoundationClass]) {
                    [arrMTemp addObject:item];
                }
                
                if ([item isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary *dictionaryJsonItem = item;

                    // 数组中是模型 必须实现这个方法 objectClassInArray
                    if ([self respondsToSelector:@selector(dictObjectClassInArray)]) {
                        
                        // 数组中类型字典
                        NSDictionary *dictObjcType = [self dictObjectClassInArray];
                        // 数组中类
                        id objcType = NSClassFromString([dictObjcType objectForKey:pNameStr]);
                        
                        // 为类赋值
                        id objcValue = [objcType objectWithKeyValues:dictionaryJsonItem];
                
                        // 类名错误 对象没有值
                        if (objcType == nil || objcValue == nil) {
                            
                            arrMTemp = pValue;
#if DEBUG
                            NSLog(@"创建模型失败，dictObjectClassInArray 发生错误.....");
#endif
                            continue;
                            
                        } else {
                            
                            [arrMTemp addObject:objcValue];
                        }
                    }
                    else {
                        NSAssert(YES, @"数组中是模型 必须实现这个方法 objectClassInArray");
                    }
                }
                
                if ([item isKindOfClass:[NSArray class]]) {
                    
                    NSArray *array = item;
                    NSArray *objArray = [self objectArrayWithValueArray:array];
                    [arrMTemp addObject:objArray];
                }
            }
            
            pValue = [NSArray arrayWithArray:arrMTemp];
            
        }
        // 赋值
        if (pValue) {
            
            [object setValue:pValue forKey:pNameStr];
            
        } else {

        }
    }
    
    free(properties);
    
    return object;
}

// 模型转字典
- (NSDictionary *)dictInstanceKeyValues {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    Class class = [self class];
    
    while (class != [NSObject class]) {
        
        unsigned int pCount = 0;
        
        objc_property_t *properties = class_copyPropertyList(class, &pCount);
        
        for (int i = 0; i < pCount; i ++) {
            
            // 取出属性名
            const char *pName = property_getName(properties[i]);
            NSString *pNameStr = [NSString stringWithUTF8String:pName];
            
            id pValue = [self valueForKey:pNameStr];
            
            if([pValue isFoundationClass]) {
                // FoundationClass
                
            } else if([pValue isKindOfClass:[NSArray class]]){
                // 数组
                
                NSArray *objarr = pValue;
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
                
                for (int i = 0; i < objarr.count; i ++) {
                    
                    id object = [objarr objectAtIndex:i];
                    [arr setObject:[object dictInstanceKeyValues] atIndexedSubscript:i];
                }
                
                pValue = arr;
                
            } else {
                
                // 自定义对象
                pValue = [pValue dictInstanceKeyValues];
            }
            
            if (pValue == nil) {
                pValue = [NSNull null];
            }
            
            [dic setObject:pValue forKey:pNameStr];
        }
        
        free(properties);
        class = class_getSuperclass(class);
    }
    
    return dic;
}

+ (NSArray *)arrayKeyValuesWithObjectArray:(NSArray *)arrObject {
    
    NSMutableArray *arrayKeyValues = [NSMutableArray array];
    NSArray *arrTmp = arrObject;
    
    for (int i = 0; i < arrTmp.count; i ++) {
        id object = [arrTmp objectAtIndex:i];
        [arrayKeyValues addObject:[object dictInstanceKeyValues]];
    }
    
    return arrayKeyValues;
}

// 框架类
- (BOOL)isFoundationClass {
    
    if ([self isKindOfClass:[NSString class]]
        || [self isKindOfClass:[NSNumber class]]
        || [self isKindOfClass:[NSNull class]]
        || [self isKindOfClass:[NSURL class]]
        || [self isKindOfClass:[NSValue class]]
        || [self isKindOfClass:[NSData class]]
        || [self isKindOfClass:[NSError class]]
        || [self isKindOfClass:[NSAttributedString class]]) {
        
        return YES;
    }
    
    return NO;
}

@end
