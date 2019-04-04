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
#import "LELoginModel.h"
#import "LELoginAuthManager.h"

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
    
    [self createBarButtonItemAtPosition:LLNavigationBarPositionLeft normalImage:[UIImage imageNamed:@"light_nav_back"] highlightImage:[UIImage imageNamed:@"light_nav_back"] text:@"" action:@selector(backAction:)];
    
    self.view.backgroundColor = kAppBackgroundColor;
    self.phoneInputView.inputViewType = LLUserInputViewTypePhone;
    [self.phoneInputView setAttributedPlaceholder:@"输入手机号"];
    self.phoneInputView.typeImageView.image = [UIImage imageNamed:@"user_account"];
    self.passwordInputView.inputViewType = LLUserInputViewTypePassword;
    [self.passwordInputView setAttributedPlaceholder:@"输入密码"];
    self.passwordInputView.typeImageView.image = [UIImage imageNamed:@"user_password"];
    
    self.phoneInputView.textField.text = @"13803833466";
    self.passwordInputView.textField.text = @"2";
    
    self.loginButton.backgroundColor = kAppThemeColor;
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = true;
    
    [self needTapGestureRecognizer];
}

- (void)loginRequest{
    
    if (self.phoneInputView.textField.text.length == 0 || self.passwordInputView.textField.text.length == 0) {
        [SVProgressHUD showCustomInfoWithStatus:@"请输入手机号和登录密码"];
        return;
    }
    [SVProgressHUD showCustomWithStatus:@"登录中..."];
    
    [self.view endEditing:YES];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"Login"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneInputView.textField.text forKey:@"Phone"];
    [params setObject:self.passwordInputView.textField.text forKey:@"Password"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LELoginModel class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                LELoginModel *model = data[0];
                [LELoginUserManager updateUserInfoWithLoginModel:model];
                [LELoginUserManager setAuthToken:model.sessionToken];
            }
        }
        if ([LELoginUserManager hasAccoutLoggedin]) {
            [SVProgressHUD showCustomSuccessWithStatus:message];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate initRootVc];
            });
        }
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoLoginFaiTitle];
    }];
    
}

- (void)getWxAuthInfo {
    WEAKSELF
    [[LELoginAuthManager sharedInstance] socialAuthBinding:UMSocialPlatformType_WechatSession presentingController:self success:^(BOOL success, NSDictionary *result) {
        if (success) {
            [weakSelf wxLoginRequestWith:result[@"openId"] nickName:result[@"username"]];
        }
    }];
}

- (void)wxLoginRequestWith:(NSString *)openId nickName:(NSString *)nickName {
    
    [self.view endEditing:YES];
    [SVProgressHUD showCustomWithStatus:@"登录中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"WeChatLogin"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (openId.length > 0) [params setObject:openId forKey:@"openid"];
    if (nickName.length > 0) [params setObject:nickName forKey:@"nickName"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LELoginModel class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return;
        }
        [SVProgressHUD dismiss];
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                LELoginModel *model = data[0];
                [LELoginUserManager updateUserInfoWithLoginModel:model];
                [LELoginUserManager setAuthToken:model.sessionToken];
            }
        }
        if ([LELoginUserManager hasAccoutLoggedin]) {
            [SVProgressHUD showCustomSuccessWithStatus:message];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                [appDelegate initRootVc];
                [self backAction:nil];
            });
        }
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoLoginFaiTitle];
    }];
}

#pragma mark - Action
- (void)backAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)loginAction:(id)sender {
    [self loginRequest];
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
    [self getWxAuthInfo];
}

@end
