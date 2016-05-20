/*
// @implementation Son

 // clang -rewrite-objc Son.m
 
static instancetype _I_Son_init(Son * self, SEL _cmd) {
    
    self = ((Son *(*)(__rw_objc_super *, SEL))(void *)objc_msgSendSuper)((__rw_objc_super){(id)self, (id)class_getSuperclass(objc_getClass("Son"))}, sel_registerName("init"));
    
    
    if (self) {
        NSLog( NSStringFromClass(((Class (*)(id, SEL))(void *)objc_msgSend)((id)self, sel_registerName("class"))));
        
        NSLog(NSStringFromClass(((Class (*)(__rw_objc_super *, SEL))(void *)objc_msgSendSuper)((__rw_objc_super){(id)self, (id)class_getSuperclass(objc_getClass("Son"))}, sel_registerName("class"))));

        // [self class]  id objc_msgSend(id self, SEL op, ...)
        // [super class] id objc_msgSendSuper(struct objc_super *super, SEL op, ...)
 
        
         struct objc_super {
         
            __unsafe_unretained id receiver;
            __unsafe_unretained Class super_class;
         
         };
 
 

    }
    return self;
}

*/
// @end
