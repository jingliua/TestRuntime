//
//  ViewController.h
//  TestRuntime
//
//  Created by liujing on 2018/10/23.
//  Copyright © 2018 jean. All rights reserved.
//
@class Person;

#import <UIKit/UIKit.h>
@interface ViewController : UITableViewController
@property (nonatomic, strong) Person *p;
- (void)testKVO;
@end

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
- (void)printInfo;
@end
