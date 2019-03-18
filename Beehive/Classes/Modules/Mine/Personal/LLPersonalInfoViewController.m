//
//  LLPersonalInfoViewController.m
//  Beehive
//
//  Created by liguangjun on 2019/3/18.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLPersonalInfoViewController.h"

@interface LLPersonalInfoViewController ()

@end

@implementation LLPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"个人信息";
    [self createBarButtonItemAtPosition:LLNavigationBarPositionRight normalImage:nil highlightImage:nil text:@"保存" action:@selector(saveAction)];
}


- (void)saveAction {
    
}

@end
