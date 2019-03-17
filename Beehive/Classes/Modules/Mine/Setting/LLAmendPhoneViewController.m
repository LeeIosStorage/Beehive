//
//  LLAmendPhoneViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLAmendPhoneViewController.h"

@interface LLAmendPhoneViewController ()

@end

@implementation LLAmendPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"修改手机号";
    [self needTapGestureRecognizer];
}

@end
