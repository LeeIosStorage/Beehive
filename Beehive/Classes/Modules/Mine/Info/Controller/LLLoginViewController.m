//
//  LLLoginViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/2.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLLoginViewController.h"
#import "LLUserInputView.h"
#import "LLRegisterViewController.h"
#import "LLForgotPasswordViewController.h"
#import "AppDelegate.h"

@interface LLLoginViewController ()

@property (nonatomic, weak) IBOutlet LLUserInputView *phoneInputView;

@property (nonatomic, weak) IBOutlet LLUserInputView *passwordInputView;

@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@end

@implementation LLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"登录";
    self.phoneInputView.inputViewType = LLUserInputViewTypePhone;
    [self.phoneInputView setAttributedPlaceholder:@"输入手机号"];
    self.phoneInputView.typeImageView.image = [UIImage imageNamed:@"user_account"];
    self.passwordInputView.inputViewType = LLUserInputViewTypePassword;
    [self.passwordInputView setAttributedPlaceholder:@"输入密码"];
    self.passwordInputView.typeImageView.image = [UIImage imageNamed:@"user_password"];
    
    self.loginButton.backgroundColor = kAppThemeColor;
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = true;
    
    [self needTapGestureRecognizer];
}

#pragma mark - Action
- (IBAction)loginAction:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate initRootVc];
}

- (IBAction)registereAction:(id)sender {
    LLRegisterViewController *vc = [[LLRegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)forgotAction:(id)sender {
    LLForgotPasswordViewController *vc = [[LLForgotPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)wxLoginAction:(id)sender {
    
}

@end
