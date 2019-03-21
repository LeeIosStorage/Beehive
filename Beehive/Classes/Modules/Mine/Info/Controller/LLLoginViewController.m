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
    
    [self loginRequest];
}

- (void)setup {
    self.title = @"登录";
    self.phoneInputView.inputViewType = LLUserInputViewTypePhone;
    [self.phoneInputView setAttributedPlaceholder:@"输入手机号"];
    self.phoneInputView.typeImageView.image = [UIImage imageNamed:@"user_account"];
    self.passwordInputView.inputViewType = LLUserInputViewTypePassword;
    [self.passwordInputView setAttributedPlaceholder:@"输入密码"];
    self.passwordInputView.typeImageView.image = [UIImage imageNamed:@"user_password"];
    
    self.phoneInputView.textField.text = @"13803833433";
    self.passwordInputView.textField.text = @"123123";
    
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
    
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"Login"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneInputView.textField.text forKey:@"Phone"];
    [params setObject:self.passwordInputView.textField.text forKey:@"Password"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        if ([dataObject isKindOfClass:[NSDictionary class]]) {
            [LELoginUserManager setUserID:dataObject[@"uid"]];
            
            id token = dataObject[@"token"];
            if ([token isKindOfClass:[NSString class]]) {
                NSData *data = [token dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                id tokenObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if ([tokenObject isKindOfClass:[NSDictionary class]]) {
                    [LELoginUserManager setAuthToken:tokenObject[@"access_token"]];
                }
            }
//            [WeakSelf refreshUserInfoRequest];
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate initRootVc];
        }
        
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoLoginFaiTitle];
    }];
    
}
#pragma mark - Action
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
    
}

@end
