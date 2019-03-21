//
//  LLForgotPasswordViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/4.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLForgotPasswordViewController.h"
#import "LLUserInputView.h"

@interface LLForgotPasswordViewController ()

@property (nonatomic, weak) IBOutlet LLUserInputView *phoneInputView;
@property (nonatomic, weak) IBOutlet LLUserInputView *smsCodeInputView;
@property (nonatomic, weak) IBOutlet LLUserInputView *passwordInputView;
@property (nonatomic, weak) IBOutlet LLUserInputView *passwordConfirmInputView;

@property (nonatomic, weak) IBOutlet UIButton *submitButton;

@end

@implementation LLForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"重置密码";
    self.view.backgroundColor = kAppBackgroundColor;
    self.phoneInputView.inputViewType = LLUserInputViewTypePhone;
    [self.phoneInputView setAttributedPlaceholder:@"输入手机号"];
    self.phoneInputView.typeImageView.image = [UIImage imageNamed:@"user_account"];
    
    self.smsCodeInputView.inputViewType = LLUserInputViewTypeSMS;
    [self.smsCodeInputView setAttributedPlaceholder:@"输入验证码"];
    self.smsCodeInputView.typeImageView.image = [UIImage imageNamed:@"user_smscode"];
    
    self.passwordInputView.inputViewType = LLUserInputViewTypeSetPassword;
    [self.passwordInputView setAttributedPlaceholder:@"设置新密码"];
    self.passwordInputView.typeImageView.image = [UIImage imageNamed:@"user_password"];
    
    self.passwordConfirmInputView.inputViewType = LLUserInputViewTypeSetPassword;
    [self.passwordConfirmInputView setAttributedPlaceholder:@"确认新密码"];
    self.passwordConfirmInputView.typeImageView.image = [UIImage imageNamed:@"user_password"];
    
    self.submitButton.backgroundColor = kAppThemeColor;
    self.submitButton.layer.cornerRadius = 5;
    self.submitButton.layer.masksToBounds = true;
    
    [self needTapGestureRecognizer];
}

#pragma mark - Action
- (IBAction)submitAction:(id)sender {
    
}

@end
