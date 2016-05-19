//
//  ViewController.m
//  LessonRunTime
//
//  Created by zhangdong on 16/5/19.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import "ViewController.h"

// 目的在于系统的学习
/*
 
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtInteracting.html
 
 http://yulingtianxia.com/blog/2014/11/05/objective-c-runtime/
 
 http://www.cocoachina.com/ios/20141008/9844.html
 
 http://www.cocoachina.com/ios/20141224/10740.html
 
 http://tech.meituan.com/DiveIntoCategory.html
 
 http://www.jianshu.com/p/efeb33712445
 
*/

/*
 
 self 与 super
 self 是类隐藏的参数，指向当前调用方法的这个类的实例
 super 是一个编译器指示器，它并不是一个指针，它仅仅是表示调用父类的方法，但是调用者仍然是当前对象，跟父类没有关系，当使用super时，是从父类的方法列表中开始找，找到后调用父类的方法
 
 */

/*
 
 SEL
 方法的selector表示运行时方法的名字，OC在编译时，会根据每一个方法的名字、参数序列、生成一个唯一的标识，这个标识就是SEL
 在类对象的方法列表中存储着该签名与实现代码的对应关系
 本质上，SEL只是一个指向方法的指针（准确的说，只是一个根据方法名hash化了的KEY值，能唯一代表一个方法），它的存在只是为了加快方法的查询速度，最终指向方法的实现
 三种方式获得SEL
1   sel_registerName函数
2   编译器提供的@selector()
3   NSSelectorFromString()
 
 */

/*
 
 IMP
 IMP实际上是一个函数指针，指向方法实现的首地址，它是方法实现的一个入口，连接着代码区的方法实现代码，取得IMP后我们就可以像调用普通的C语言函数一样来使用这个指针了
 通过取得IMP，可以跳过runtime的消息传递机制，直接执行IMP指向的函数实现
 直接获取方法地址：methodForSelector:
 
 */

/*
 
 Method  相当于在SEL和IMP之间做了一个映射
 typedef struct objc_method *Method;
 struct objc_method {
     SEL method_name                 OBJC2_UNAVAILABLE;  // 方法名
     char *method_types              OBJC2_UNAVAILABLE;
     IMP method_imp                  OBJC2_UNAVAILABLE;  // 方法实现
 }
 
 */

/*
 
 Cache 
 Cache 为方法调用的性能进行优化。
 每当实例对象接收到一个消息时，它不会直接在isa指向的类的方法列表
 
 
 */

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
