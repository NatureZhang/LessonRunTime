//
//  NodeItem.h
//  LessonRunTime
//
//  Created by zhangdong on 16/5/27.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NodeItem : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSArray *children;

@end
