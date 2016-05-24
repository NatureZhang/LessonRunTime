//
//  Person.h
//  LessonRunTime
//
//  Created by zhangdong on 16/5/20.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

{
    NSString *age;
    NSString *weight;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sex;

@end
