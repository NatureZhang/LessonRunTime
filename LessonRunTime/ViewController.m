//
//  ViewController.m
//  LessonRunTime
//
//  Created by zhangdong on 16/5/19.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import "ViewController.h"
#import "Son.h"
#import "Person.h"
#import <objc/runtime.h>

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
 
 Runtime 是什么
 Objective-C 的Runtime是一个运行时库，它是一个主要使用C和汇编写的库，为C添加面向对象的能力并创造了Objective-C。这就是说它在类信息中被加载，完成所有的方法分发，方法转发，等等。Objective-C Runtime 创建了所有需要的结构体，让Objective-C面向对象编程变为可能
 
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
 只要方法名相同，那么他们的SEL就是相同的
 
 两个类之间，不管他们是父类与子类的关系，还是之间没有这种关系，只要方法名相同，那么它的SEL就是一样的。每一个方法都对应着一个SEL。编译器会根据每个方法的方法名为那个方法生成唯一的SEL。这些SEL组成了一个Set集合，当我们在这个集合中查找某个方法时，只需要去找这个方法对应的SEL即可。而SEL本质是一个字符串
 不同的类可以拥有相同的selector，不同类的实例对象执行相同的selector时，会在各自的方法列表中去根据selector去寻找自己对应的IMP
 
 
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
     SEL method_name                   // 方法名
     char *method_types                // 存储着方法的参数类型和返回值类型
     IMP method_imp                    // 方法实现
 }
 
 */

/*
 
 Cache 
 Cache 用来缓存用过的方法，提高性能。
 每当实例对象接收到一个消息时，它不会直接在isa指向的类的方法列表中查找，而是优先在cache中查找。Runtime 系统会把被调用的方法存到cache中（一个方法如果被调用，那么他有可能今后还会被调用），下次查找的时候效率更高
 */

/*
 
 Ivar 
 Ivar 是代表类中实例变量的类型
 typedef struct objc_ivar *Ivar;
 
 struct objc_ivar {
     char *ivar_name                                          OBJC2_UNAVAILABLE;
     char *ivar_type                                          OBJC2_UNAVAILABLE;
     int ivar_offset                                          OBJC2_UNAVAILABLE;
 #ifdef __LP64__
     int space                                                OBJC2_UNAVAILABLE;
 #endif
 }
 
 ivar_offset 表示基地址偏移字节，ivar是通过偏移量来确定地址，并访问的。
 
 
 */

/*
 
 类中的Property属性被编译器转换成了ivar，并且自动添加了set和get方法
 
 
 */


/*
 1
 id 是指向一个objc_object 结构体的指针
 typedef struct objc_object *id;
 
 id 这个struct的定义本身就带了一个*，所以我们在使用其他NSObject类型的实例时需要咋前面加上*，而使用id时却不用
 
 struct objc_object {
    Class isa;
 };
 
 2
 Objective-C中的object在最后会被转换成C的结构体，而这个结构体中有一个isa指针，指向它的类别Class
 
 Class 也是一个结构体指针类型
 typedef struct objc_class *Class;
 
 struct objc_class {
 Class isa  OBJC_ISA_AVAILABILITY; //指向其所属的元类
 
 #if !__OBJC2__
 Class super_class                  指向其超类
 const char *name                   类名
 long version                       类的版本信息
 long info                          类的详情
 long instance_size                 该类的实例对象的大小
 struct objc_ivar_list *ivars       该类的成员变量列表
 struct objc_method_list **methodLists  该列的实例方法列表，它将方法选择器和方法实现地址联系起来，它是指向objc_method_list 指针的指针，也就是说可以动态修改*methodLists的值来添加成员方法，这也是category实现的原理
 struct objc_cache *cache           Runtime系统会把被调用的方法存到cache中，下次查找的时候效率更高
 struct objc_protocol_list *protocols 指向该类的协议列表
 #endif
 
 } OBJC2_UNAVAILABLE;
 
 */

/*
 
 Meta Class 元类
 
 可以把Meta Class 理解为一个Class对象的Class
 当向一个NSObject对象发送消息时，这条消息会在对象的类的方法列表中查找
 当向一个类发送消息时，这条消息会在类的Meta Class的方法列表里查找
 Meta Class 本身也是一个Class，它跟其他Class一样也有自己的 isa 和 super_class 指针
 
 每个Class 都有一个isa指针指向一个唯一的 Meta Class 
 每个Meta Class 的isa指针都指向最上层的Meta Class
 最上层的Meta Class的isa指针指向自己，形成一个回路
 每个Meta Class的super Class 指针指向他原本Class的super Class的Meta Class，但是最上层的Meta Class的super Class 指向NSObject Class本身
 最上层的NSObject Class 的 super Class 指向nil
 
 */

/*
 
 objc_msgSend 
 在OC中，消息直到运行时才会绑定到方法的实现上，编译器会把代码中[reserver message]转换成objc_msgSend消息函数，这个函数完成了动态绑定的所有事情。它的运行流程如下：
 1 检查selector是否需要忽略
 2 检查target是否为nil，如果为nil，直接cleanup，然后return
 3 然后在target的Class中根据selector去找IMP
 
 寻找Imp的过程
 1 先从当前Class的cache方法列表（cache methodLists）里去找
 2 找到了，跳到对应函数实现
 3 没找到，就从Class的方法列表（methodLists）里找
 4 还没找到，就到super class 的方法列表里找，直到找到基类为止
 5 最后再找不到，就会进入动态方法解析和消息转发的机制
 
 
 */

/*
 
 category
 category 可以动态的为已经存在的类添加新的方法，这样可以保证类的原始设计规模较小，功能增加时再逐步扩展
 typedef struct objc_category *Category;
 
 struct category_t {
 
    // name 是指class_name 不是 category_name
     const char *name;
 
    // cls 是要扩展的类对象，编译期间不会定义，而是在Runtime阶段通过name对应到对应的类对象
     classref_t cls;
     struct method_list_t *instanceMethods;
     struct method_list_t *classMethods;
     struct protocol_list_t *protocols;
 
    // 表示category里所有的properties，这就是我们可以通过 objc_setAssociatedObject和objc_getAssociatedObject增加实例变量的原因，这个和一般的实例变量是不一样的
     struct property_list_t *instanceProperties;
 };
 
 */



@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getIvars];
    [self getPropertys];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
