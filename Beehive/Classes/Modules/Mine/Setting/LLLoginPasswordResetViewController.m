//
//  LLLoginPasswordResetViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLLoginPasswordResetViewController.h"

@interface LLLoginPasswordResetViewController ()

@property (nonatomic, weak) IBOutlet UITextField *tfOldPwd;
@property (nonatomic, weak) IBOutlet UITextField *tfNewPwd;
@property (nonatomic, weak) IBOutlet UITextField *tfAffirmPwd;

@end

@implementation LLLoginPasswordResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"修改登录密码";
    [self needTapGestureRecognizer];
}

- (IBAction)affirmAction:(id)sender {
    
}

@end
