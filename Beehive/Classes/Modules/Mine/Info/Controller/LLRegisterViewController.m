//
//  LLRegisterViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/4.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLRegisterViewController.h"
#import "LLUserInputView.h"
#import "LEWebViewController.h"

@interface LLRegisterViewController ()

@property (nonatomic, weak) IBOutlet LLUserInputView *phoneInputView;
@property (nonatomic, weak) IBOutlet LLUserInputView *smsCodeInputView;
@property (nonatomic, weak) IBOutlet LLUserInputView *passwordInputView;
@property (nonatomic, weak) IBOutlet LLUserInputView *passwordConfirmInputView;
@property (nonatomic, weak) IBOutlet LLUserInputView *inviteCodeInputView;

@property (nonatomic, weak) IBOutlet UIButton *registerButton;
@property (nonatomic, weak) IBOutlet UIButton *agreementButton;

@end

@implementation LLRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"注册";
    self.phoneInputView.inputViewType = LLUserInputViewTypePhone;
    [self.phoneInputView setAttributedPlaceholder:@"输入手机号"];
    self.phoneInputView.typeImageView.image = [UIImage imageNamed:@"user_account"];
    
    self.smsCodeInputView.inputViewType = LLUserInputViewTypeSMS;
    [self.smsCodeInputView setAttributedPlaceholder:@"输入验证码"];
    self.smsCodeInputView.typeImageView.image = [UIImage imageNamed:@"user_smscode"];
    
    self.passwordInputView.inputViewType = LLUserInputViewTypeSetPassword;
    [self.passwordInputView setAttributedPlaceholder:@"设置登录密码"];
    self.passwordInputView.typeImageView.image = [UIImage imageNamed:@"user_password"];
    
    self.passwordConfirmInputView.inputViewType = LLUserInputViewTypeSetPassword;
    [self.passwordConfirmInputView setAttributedPlaceholder:@"确认登录密码"];
    self.passwordConfirmInputView.typeImageView.image = [UIImage imageNamed:@"user_password"];
    
    self.inviteCodeInputView.inputViewType = LLUserInputViewTypeInviteCode;
    [self.inviteCodeInputView setAttributedPlaceholder:@"邀请码"];
    self.inviteCodeInputView.typeImageView.image = [UIImage imageNamed:@"user_invitecode"];
    
    self.registerButton.backgroundColor = kAppThemeColor;
    self.registerButton.layer.cornerRadius = 5;
    self.registerButton.layer.masksToBounds = true;
    
    [self.agreementButton setTitleColor:kAppThemeColor forState:UIControlStateNormal];
    NSString *attStr = @"注册即表示同意《蜂巢用户注册协议》";
    [self.agreementButton setAttributedTitle:[WYCommonUtils stringToColorAndFontAttributeString:attStr range:NSMakeRange(0, 7) font:[FontConst PingFangSCRegularWithSize:14] color:[UIColor colorWithHexString:@"a9a9aa"]] forState:UIControlStateNormal];
    
    [self needTapGestureRecognizer];
}

#pragma mark - Action
- (IBAction)registerAction:(id)sender {
    
}

- (IBAction)agreementAction:(id)sender {
    LEWebViewController *vc = [[LEWebViewController alloc] initWithURLString:@"https://www.weibo.com"];
    [self.navigationController pushViewController:vc animated:true];
}

@end
