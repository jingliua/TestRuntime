//
//  ViewController.m
//  TestRuntime
//
//  Created by liujing on 2018/10/23.
//  Copyright © 2018 jean. All rights reserved.
//
//  使用category要注意baseclass+categoryA 和+B如果有同名方法 调用谁取决于buildPhases->Compile Sources谁后加入
//  categoryA和baseClass也不要声明同名方法 categoryA在methodlist里的顺序在本类之前 category不是继承 不能调用
//  super 本类此方法不能被调用 会产生覆盖本类的效果
//  故category只用来增加方法 不用来重写 几个category不要出现同名方法 可用前缀区分

#import "ViewController.h"
#import "ViewController+CATEGORY.h"
#import "ViewController+EXTENSION.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "UIView+EXTENSION.h"

@interface ViewController (){
    NSArray * titleArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    titleArray = @[@"object_getClass",@"objc_getClass",@"objc_getMetaClass",@"class_getSuperclass",@"NSObject",
                   @"class_copyIvarList",@"class_copyPropertyList",@"class_copyMethodList",
                   @"Property/ivar",@"Category",@"Extension",@"ReplaceMethod",@"AssociatedObject",
                   @"KVO"];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self testObject_getClass];
            break;
        case 1:
            [self testObjc_getClass];
            break;
        case 2:
            [self testObjc_getMetaClass];
            break;
        case 3:
            [self testClass_getSuperclass];
            break;
        case 4:
            [self testNSObject];
            break;
        case 5:
            [self testClass_copyIvarList];
            break;
        case 6:
            [self testClass_copyPropertyList];
            break;
        case 7:
            [self testClass_copyMethodList];
            break;
        case 8:
            [self testProperty_ivar];
            break;
        case 9:
            [self testCategoryMethod];
            break;
        case 10:
            [self testExtensionMethod];
            break;
        case 11:
            [self testReplaceMethod];
            break;
        case 12:
            [self testAssociatedObject];
            break;
        case 13:
            [self testKVO];
            break;
    }
}
#pragma mark ---------------------object_getClass------------------------
- (void)testObject_getClass {
    // 1. 测试 object_getClass    return isa
    Class currentClass0 = object_getClass(self);
    const char *name0 = class_getName(currentClass0);
    NSLog(@"self is %p",self);
    for (int i = 1; i < 5; i++) {
        NSLog(@"Following the isa pointer %d times gives %p---%s", i, currentClass0,name0);
        currentClass0 = object_getClass(currentClass0);
        name0 = class_getName(currentClass0);
        if (i == 4) {
            NSLog(@"-----------------------------------\n");
        }
    }
}

#pragma mark ---------------------objc_getClass------------------------
- (void)testObjc_getClass {
    // 3. 测试 objc_getClass    return class
    Class currentClass1 = objc_getClass(class_getName(object_getClass(self)));
    const char *name1 = class_getName(currentClass1);
    NSLog(@"self is %p",self);
    for (int i = 1; i < 5; i++) {
        NSLog(@"Following the isa pointer %d times gives %p---%s", i, currentClass1,name1);
        currentClass1 = objc_getClass(class_getName(currentClass1));
        name1 = class_getName(currentClass1);
        if (i == 4) {
            NSLog(@"-----------------------------------\n");
        }
    }
}

#pragma mark ---------------------objc_getMetaClass------------------------
- (void)testObjc_getMetaClass {
    // 2. 测试 objc_getMetaClass   return objc_getClass的isa
    Class currentClass2 = object_getClass(self);
    const char *name2 = class_getName(currentClass2);
    NSLog(@"self is %p",self);
    for (int i = 1; i < 5; i++) {
        NSLog(@"Following the isa pointer %d times gives %p---%s", i, currentClass2,name2);
        currentClass2 = objc_getMetaClass(class_getName(currentClass2));
        name2 = class_getName(currentClass2);
        if (i == 4) {
            NSLog(@"-----------------------------------\n");
        }
    }
}

#pragma mark ---------------------class_getSuperclass------------------------
- (void)testClass_getSuperclass {
    // 4. 测试 super class NSObject's super=nil
    Class currentClass0_1 = object_getClass(self);
    const char *name0_1 = class_getName(currentClass0_1);
    NSLog(@"self is %p",self);
    for (int i = 1; i < 7; i++) {
        NSLog(@"Following the isa pointer %d times gives %p---%s", i, currentClass0_1,name0_1);
        currentClass0_1 = class_getSuperclass(currentClass0_1);
        name0_1 = class_getName(currentClass0_1);
        if (i == 6) {
            NSLog(@"-----------------------------------\n");
        }
    }
    
}

- (void)testNSObject {
    // 5. 测试 NSObject's isa isa isa
    NSObject *ob = [[NSObject alloc]init];
    Class currentClassob = object_getClass(ob);
    const char *nameob = class_getName(currentClassob);
    NSLog(@"ob is %p",ob);
    for (int i = 1; i < 5; i++) {
        NSLog(@"Following the isa pointer %d times gives %p---%s", i, currentClassob,nameob);
        currentClassob = object_getClass(currentClassob);
        nameob = class_getName(currentClassob);
        if (i == 4) {
            NSLog(@"-----------------------------------\n");
        }
    }
    
    currentClassob = object_getClass(ob);//NSObject
    Class currentClassob_super = class_getSuperclass(currentClassob);//NSObject的super:0x0
    Class currentClassob_Meta = objc_getMetaClass(class_getName(currentClassob));//NSObject的meta
    Class currentClassob_Meta_super = class_getSuperclass(currentClassob_Meta);//NSObject的meta的super为NSObject
    Class currentClassob_Meta_Meta = object_getClass(currentClassob_Meta);//NSObject的元类的isa指向此元类本身
    NSLog(@"\n NSObject class pointer is %p,\n NSObject's super class pointer is %p,\n NSObject's meta class pointer is %p,\n NSObject meta class's super class pointer is %p,\n NSObject meta class's meta class pointer is %p\n", currentClassob,currentClassob_super,currentClassob_Meta,currentClassob_Meta_super,currentClassob_Meta_Meta);
}

#pragma mark ---------------------class_copyIvarList------------------------
- (void)testClass_copyIvarList {
    // 1. 测试class_copyIvarList  (extension里的成员变量也会加进去，category不能添加ivar会编译报错)
    unsigned int outCountIvar = 0;
    Ivar * ivars =  class_copyIvarList(self.class, &outCountIvar);
    for (int i = 0; i < outCountIvar; i++) {
        Ivar ivar = ivars[i];
        NSString *ivarName = [[NSString alloc]initWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        NSString *ivarType = [[NSString alloc]initWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
        NSLog(@"ivar name is: %@, ivar type is: %@",ivarName,ivarType);
    }
}

#pragma mark ---------------------class_copyPropertyList------------------------
- (void)testClass_copyPropertyList {
    // 2. 测试class_copyPropertyList (extension和category中的属性都会加进去)
    unsigned int outCountProperty = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &outCountProperty);
    for (int i = 0; i < outCountProperty; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property is: %s , property attributes: %s",property_getName(property),property_getAttributes(property));
    }
    
}

#pragma mark ---------------------class_copyMethodList------------------------
- (void)testClass_copyMethodList {
    // 3. 测试object_getClass(self) 的method (extension和category中的方法也会加进去，其中自己和extension里的property会生成getter,setter方法，而category的property不会生成)
    unsigned int outCount0 = 0;
    Method *methods0 =  class_copyMethodList(object_getClass(self), &outCount0);
    for (int i = 0; i < outCount0; i++) {
        Method method = methods0[i];
        NSLog(@"self's class method's signature: %@", NSStringFromSelector(method_getName(method)));
    }
    
    // 4. 测试object_getClass(object_getClass(self)) 的method
    unsigned int outCount1 = 0;
    Method *methods1 = class_copyMethodList(object_getClass(object_getClass(self)), &outCount1);
    for (int i = 0; i < outCount1; i++) {
        Method method = methods1[i];
        NSLog(@"class's meta class method's signature: %@", NSStringFromSelector(method_getName(method)));
    }
    
    // 5. 测试class_getInstanceMethod
    struct objc_method *instanceMethod = class_getInstanceMethod(object_getClass(self), @selector(viewWillAppear:));
    if (instanceMethod != NULL) {
        NSLog(@"self's class's instance method : %@", NSStringFromSelector(method_getName(instanceMethod)));
    }
    
    // 6. 测试class_getClassMethod  (去查看class_getClassMethod 源码)
    struct objc_method *classMethod = class_getClassMethod(object_getClass(self), @selector(testClassMethod));
    if (classMethod != NULL) {
        NSLog(@"self's class's class method : %@", NSStringFromSelector(method_getName(classMethod)));
    }
}

+ (void)testClassMethod {
    
}

#pragma mark ---------------------Property/ivar------------------------
- (void)testProperty_ivar {
    // 1. 动态生成一个类
    Class cls = objc_allocateClassPair(self.class, "MySubClass", 0);
   
    // 2. 给动态生成的类添加ivar (type见表)
    BOOL success1 = class_addIvar(cls, "_ivar1", sizeof(NSArray*), log(2*sizeof(NSArray*)),"NSArray");
    NSLog(@"给动态创建的类添加ivar%@成功",success1?@"":@"没有");
    // 给已存在的类如self.class加ivar不会成功
    BOOL success2 = class_addIvar(self.class, "_ivar1", sizeof(NSArray*), log(2*sizeof(NSArray*)),"NSArray");
    NSLog(@"给已经存在的类添加ivar%@成功",success2?@"":@"没有");
    
    // 3. 给此类添加属性
    objc_property_attribute_t type = {"T", "@\"NSArray\""};//type
    objc_property_attribute_t ownership = { "C", "" };//copy 属性
    objc_property_attribute_t backingivar = { "V", "_ivar2"};//variable名
    objc_property_attribute_t attrs[] = {type,ownership,backingivar};
   
    BOOL success3 = class_addProperty(cls, "property", attrs, 3);
    NSLog(@"给动态创建的类添加property%@成功",success3?@"":@"没有");
   
    // 给已存在的类如self.class加属性会成功
    BOOL success4 = class_addProperty(self.class, "property", attrs, 3);
    NSLog(@"给已经存在的类添加property%@成功",success4?@"":@"没有");
    
    // 4. 注册
    objc_registerClassPair(cls);
    
    // 5. 打印所有ivar （发现没有生成_property成员变量）
    unsigned int outCount = 0;
    Ivar * ivars =  class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSString *ivarName = [[NSString alloc]initWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        NSLog(@"ivar name is: %@, ivar type is: %@",ivarName,ivarType);
    }
    
    // 6. 打印所有属性
    unsigned int outCount1, i;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount1);
    for (i = 0; i < outCount1; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property is: %s , property attributes: %s",property_getName(property),property_getAttributes(property));
    }
    
    // 7. 打印方法 （property并没有生成getter setter方法）
    unsigned int outCount2 = 0;
    Method *methods =  class_copyMethodList(cls, &outCount2);
    for (int i = 0; i < outCount2; i++) {
        Method method = methods[i];
        NSLog(@"method's signature: %@", NSStringFromSelector(method_getName(method)));
    }
    
    objc_disposeClassPair(cls);
}

#pragma mark ---------------------class_addMethod class_replaceMethod ------------------------
- (void)testReplaceMethod {
    Class cls = objc_allocateClassPair(self.class, "MySubClass", 0);
   
    //MySubClass里找不到 找它的父类ViewController
    Method testM = class_getInstanceMethod(cls, @selector(testMethod:));
    IMP imp_testMethod0 = method_getImplementation(testM);
    IMP imp_testMethod = class_getMethodImplementation(cls, @selector(testMethod:));
    NSLog(@"imp_testMethod0 is %p,imp_testMethod is %p",imp_testMethod0,imp_testMethod);
    
    // 1. class_addMethod  allocatedMethod:与testMethod:实现一致
    const char * type = method_getTypeEncoding(testM);//"v24@0:8@16"
    class_addMethod(cls, @selector(allocatedMethod:), (IMP)imp_testMethod, type);
    
    // 2. exchangeimp testMethod和existMethod交换实现
    Method existM = class_getInstanceMethod(cls, @selector(existMethod:));
    method_exchangeImplementations(testM,existM);
    
    Method allocatedM = class_getInstanceMethod(cls, @selector(allocatedMethod:));
    //sel-imp的映射关系变了 而非imp交换了 如果imp变了allocatedMethod:会变成existMethod:的实现
    
    //class_replaceMethod(cls, @selector(existMethod:), (IMP)imp_testMethod,type);
    
    // 3. objc_msgSend 调用
    ((void (*)(id, SEL, NSString*))objc_msgSend)(self, NSSelectorFromString(@"testMethod:"), @"objc_msgSend");
    
    // 4. imp() 调用
    void (*func)(id,SEL,NSString*) = (void *)imp_testMethod;
    func(self,NSSelectorFromString(@"testMethod:"),@"imp直接使用");

    // 5. method_invoke 调用
    id instance = [[cls alloc] init];
    ((void (*)(id, Method, NSString*))method_invoke)(instance, allocatedM, @"method_invoke");
   
    //6. performSelector 调用 （此种方法只可以最多传2个参数）
    [instance performSelector:@selector(allocatedMethod:) withObject:@"hi"];
    [instance performSelector:@selector(existMethod:) withObject:@"hello"];
}


- (void)testMethod:(NSString *)str {
    NSLog(@"testMethod: self is %@, str is %@",self,str);
}

- (void)existMethod:(NSString *)str {
    NSLog(@"existMethod: self is %@, str is %@",self,str);
}


#pragma mark ---------------------Category------------------------
//方法查找的优先级:catogory的方法->自己类的这个方法->父类中这个方法
- (void)testCategoryMethod {
    NSLog(@"testCategoryMethod is %p",_cmd);
}

#pragma mark ---------------------Extension------------------------
//extension的作用是为了隐藏类的私有信息 相当于把那块内容放.m里 扩展和本类不可以拥有相同的属性或者成员变量
-(void)testExtensionMethod {
    self.extensionProperty = @"extensionProperty";
    extensionIvar = @"extensionIvar";
    NSLog(@"self.extensionProperty:%@ ,extensionIvar:%@",self.extensionProperty,extensionIvar);
    
    [self testExtensionForUIView];
}

//系统类无法扩展 因为你不能改系统类实现 去#import扩展.h
- (void)testExtensionForUIView {
    UIView * v = [UIView new];
    v.extensionName = @"extensionName";
}

#pragma mark ---------------------AssociatedObject------------------------
- (void)testAssociatedObject {
    self.categoryProperty = @"hahhahahha";
    NSLog(@"self的category的categoryProperty值为%@",self.categoryProperty);
}

#pragma mark ---------------------KVO------------------------
- (void)testKVO {
    Person * p = [Person new];
    p.name = @"小明";
    [p printInfo];
    [p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    p.name = @"小红";
    [p printInfo];
    [p removeObserver:self forKeyPath:@"name"];
    [p printInfo];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    NSLog(@"监听到了%@的%@属性发生了改变", object, keyPath);
    NSLog(@"%@", change);
}
@end

@interface Person ()
@end

@implementation Person
- (void)printInfo {
    NSLog(@"isa:%@, supper class:%@", object_getClass(self),
          class_getSuperclass(object_getClass(self)));
    
    //setAge方法的地址没变
    NSLog(@"age setter function pointer:%p", class_getMethodImplementation(object_getClass(self), @selector(setAge:)));
    NSLog(@"name setter function pointer:%p", class_getMethodImplementation(object_getClass(self), @selector(setName:)));
    NSLog(@"printInfo function pointer:%p", class_getMethodImplementation(object_getClass(self), @selector(printInfo)));
}

@end

