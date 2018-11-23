//
//  ViewController+CATEGORY.h
//  TestRuntime
//
//  Created by liujing on 2018/10/31.
//  Copyright © 2018 jean. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (CATEGORY)
{
//    NSString * categoryIvar;          //编译错误
}
@property (nonatomic, copy)NSString * categoryProperty;
@end
