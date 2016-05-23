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
#import "Person+Property.h"
#import <objc/runtime.h>

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self getIvars];
    //    [self getPropertys];
    
    [self categoryProperty];

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
        
        NSLog(@"%s", ivarName);
    }
}

- (void)getPropertys {
    
    NSLog(@"=============== class propertys ===========\n");
    
    unsigned int  pCount = 0;
    
    objc_property_t *properties = class_copyPropertyList([Person class], &pCount);
    
    for (int i = 0; i < pCount; i ++) {
        
        const char *pName = property_getName(properties[i]);
        
        NSLog(@"%s", pName);
    }
    
}

- (void)categoryProperty {
    Person *person = [[Person alloc] init];
    person.contry = @"中国";
    NSLog(@"%@", person.contry);
    
    // 动态方法解析
//    [person performSelector:@selector(fly)];
}


@end
