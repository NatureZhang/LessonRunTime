//
//  UserSon.h
//  LessonRunTime
//
//  Created by zhangdong on 16/5/27.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import "User.h"

@interface UserSon : User

/** 头像 */
@property (copy, nonatomic) NSString *icon;
/** 年龄 */
@property (assign, nonatomic) unsigned int age;
/** 身高 */
@property (strong, nonatomic) NSNumber *height;
/** 财富 */
@property (strong, nonatomic) NSDecimalNumber *money;
/** 性别 */
@property (assign, nonatomic) Sex sex;
/** 同性恋 */
@property (assign, nonatomic, getter=isGay) BOOL gay;

@end
