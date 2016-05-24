//
//  UserList.h
//  LessonRunTime
//
//  Created by zhangdong on 16/5/24.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface UserList : NSObject

@property (nonatomic, strong) NSArray *userList;
@property (nonatomic, strong) NSString *usersDesc;
@property (nonatomic, strong) User *user;
@end
