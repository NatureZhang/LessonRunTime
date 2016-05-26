//
//  TestViewController.m
//  LessonRunTime
//
//  Created by zhangdong on 16/5/23.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import "TestViewController.h"
#import "Son.h"
#import "Person.h"
#import "ManPerson.h"
#import "Person+Property.h"
#import <objc/runtime.h>
#import "NSObject+Parse.h"

#import "User.h"
#import "UserList.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getIvars];
    [self getPropertys];
    
    [self categoryProperty];

    [self dicToModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 获取ivar
- (void)getIvars {
    
    NSLog(@"=============== class ivars ===========\n");
    
    unsigned int ivarCount = 0;
    
    Ivar *ivars = class_copyIvarList([Person class], &ivarCount);
    
    for (int i = 0; i < ivarCount ; i++) {
        
        const char *ivarName = ivar_getName(ivars[i]);
        
        const char *ivarType = ivar_getTypeEncoding(ivars[i]);
        
        NSLog(@"%s  :  %s", ivarType, ivarName);
    }
}

- (void)getPropertys {
    
    NSLog(@"=============== class propertys ===========\n");
    
    unsigned int  pCount = 0;
    
    objc_property_t *properties = class_copyPropertyList([ManPerson class], &pCount);
    
    for (int i = 0; i < pCount; i ++) {
        
        const char *pName = property_getName(properties[i]);
        
        const char  *className = property_getAttributes(properties[i]);
        
        NSLog(@"%s : %s", className, pName);
        
    }
    
}

- (void)categoryProperty {
    Person *person = [[Person alloc] init];
    person.contry = @"中国";
    NSLog(@"%@", person.contry);
    
    // 动态方法解析
//    [person performSelector:@selector(fly)];
}

- (void)dicToModel {
//    // 1.定义一个字典
//    NSDictionary *dict = @{
//                           @"name" : @"Jack",
//                           @"icon" : @"lufy.png",
//                           @"age" : @"20",
//                           @"height" : @1.55,
//                           @"money" : @"100.9",
//                           @"sex" : @(SexFemale),
//                           @"gay" : @"1"
//                           };
//    
//    // 2.将字典转为MJUser模型
//    User *user = [User objectWithKeyValues:dict];
//    
//    // 3.打印MJUser模型的属性
//    NSLog(@"name=%@, icon=%@, age=%zd, height=%@, money=%@, sex=%d, gay=%d", user.name, user.icon, user.age, user.height, user.money, user.sex, user.gay);
    
    
    // 1.定义一个字典数组
//    NSDictionary *dict = @{ @"userList" : @[
//                                       @{
//                                           @"name" : @"",
//                                           @"icon" : @"lufy.png",
//                                           },
//                           
//                                       @{
//                                           @"name" : @"Rose",
//                                           @"icon" : @"nami.png",
//                                        }
//                                           ]
//                            };
    
    NSDictionary *dict = @{
                           @"usersDesc":@"这是一个测试",
                           @"user" :  @{
                                        @"name" : @"zhangdong",
                                        @"icon" : @"lufy.png",
                                        },
                           @"userList":@[
                                   @{
                                       @"name" : @"zhangdong",
                                       @"icon" : @"lufy.png",
                                       },
                                   @{
                                       @"name" : @"zhangdong",
                                       @"icon" : @"lufy.png",
                                       },
                                   @{
                                       @"name" : @"zhangdong",
                                       @"icon" : @"lufy.png",
                                       }
                                   ]
                            };
    
    UserList *userList = [UserList objectWithKeyValues:dict];
    NSLog(@"%@--%@", userList.user.name, userList.usersDesc);
    NSDictionary *dic = [userList dictInstanceKeyValues];
    
    // 1.定义一个字典数组
    NSArray *dictArray = @[
                           @{
                               @"name" : @"Jack",
                               @"icon" : @"lufy.png",
                               },
                           
                           @{
                               @"name" : @"Rose",
                               @"icon" : @"nami.png",
                               }
                           ];
    NSArray *userArray = [User objectArrayWithValueArray:dictArray];

    NSArray *values = [User arrayKeyValuesWithObjectArray:userArray];
    
    
    NSArray *dictArray2 = @[
                            
                            @[
                                @{
                                    @"name" : @"Jack",
                                    @"icon" : @"lufy.png",
                                    },
                                
                                @{
                                    @"name" : @"Rose",
                                    @"icon" : @"nami.png",
                                    }
                                ],
                            @[
                                @{
                                    @"name" : @"Jack",
                                    @"icon" : @"lufy.png",
                                    },
                                
                                @{
                                    @"name" : @"Rose",
                                    @"icon" : @"nami.png",
                                    }
                                ]
                            
                           ];

    NSArray *userArray2 = [User objectArrayWithValueArray:dictArray2];
    
    NSArray *values2 = [User arrayKeyValuesWithObjectArray:userArray2];
    
    
}

@end
