//
//  ViewController+CATEGORY.m
//  TestRuntime
//
//  Created by liujing on 2018/10/31.
//  Copyright © 2018 jean. All rights reserved.
//

#import "ViewController+CATEGORY.h"
#import <objc/runtime.h>

static const void*PersonNameKey = &PersonNameKey;

@implementation ViewController (CATEGORY)
- (void)testCategoryMethod{
    NSLog(@"category testCategoryMethod is %p",_cmd);
    self.tableView.backgroundColor = [UIColor grayColor];
    self.view.backgroundColor = [UIColor grayColor];
}

////objc_setAssociatedObject 里可以传任何对象 如block 如delegate等 常见用方法的@selector作为key
- (void)setCategoryProperty:(NSString *)categoryProperty {
    objc_setAssociatedObject(self, PersonNameKey, categoryProperty, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)categoryProperty {
   return objc_getAssociatedObject(self, PersonNameKey);
}
@end
