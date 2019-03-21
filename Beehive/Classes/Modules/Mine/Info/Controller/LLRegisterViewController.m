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

@property (nonatomic, strong) NSString *agreementContentHtmlText;

@end

@implementation LLRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self getUserAgreement];
}

- (void)setup {
    self.title = @"注册";
    self.view.backgroundColor = kAppBackgroundColor;
    self.phoneInputView.inputViewType = LLUserInputViewTypePhone;
    [self.phoneInputView setAttributedPlaceholder:@"输入手机号"];
    self.phoneInputView.typeImageView.image = [UIImage imageNamed:@"user_account"];
    
    self.smsCodeInputView.inputViewType = LLUserInputViewTypeSMS;
    [self.smsCodeInputView setAttributedPlaceholder:@"输入验证码"];
    self.smsCodeInputView.typeImageView.image = [UIImage imageNamed:@"user_smscode"];
    [self.smsCodeInputView.smsCodeButton addTarget:self action:@selector(smsCodeAction) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)registerRequest{
    
    if (self.phoneInputView.textField.text.length == 0 || self.passwordInputView.textField.text.length == 0 || self.smsCodeInputView.textField.text.length == 0) {
        [SVProgressHUD showCustomInfoWithStatus:@"请输入手机号、验证码、密码"];
        return;
    }
    if (![self.passwordInputView.textField.text isEqualToString:self.passwordConfirmInputView.textField.text]) {
        [SVProgressHUD showCustomInfoWithStatus:@"两次密码不一致"];
        return;
    }
    [SVProgressHUD showCustomWithStatus:@"注册中..."];
    
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"Register"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneInputView.textField.text forKey:@"Phone"];
    [params setObject:self.smsCodeInputView.textField.text forKey:@"smsCode"];
    [params setObject:self.passwordInputView.textField.text forKey:@"Password"];
    if (self.inviteCodeInputView.textField.text.length > 0) {
        [params setObject:self.passwordInputView.textField.text forKey:@"inviteCode"];
    }
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
//        if ([dataObject isKindOfClass:[NSDictionary class]]) {
//            [LELoginUserManager setUserID:dataObject[@"uid"]];
//            
//            id token = dataObject[@"token"];
//            if ([token isKindOfClass:[NSString class]]) {
//                NSData *data = [token dataUsingEncoding:NSUTF8StringEncoding];
//                NSError *error = nil;
//                id tokenObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//                if ([tokenObject isKindOfClass:[NSDictionary class]]) {
//                    [LELoginUserManager setAuthToken:tokenObject[@"access_token"]];
//                }
//            }
//            //            [WeakSelf refreshUserInfoRequest];
//        }
        
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
    
}

- (void)smsCodeAction {
    if (self.phoneInputView.textField.text.length == 0) {
        [SVProgressHUD showCustomInfoWithStatus:@"请输入手机号"];
        return;
    }
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"SendSms"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneInputView.textField.text forKey:@"Phone"];
    //Method：1：注册；2：重置密码；3：修改手机号(第二次)；4：修改支付密码；5：修改手机号（第一次）
    [params setObject:@"1" forKey:@"Method"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:message];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoLoginFaiTitle];
    }];
}

- (void)getUserAgreement {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetUserAgreement"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
//            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *object = (NSArray *)dataObject;
            if (object.count > 0) {
                self.agreementContentHtmlText = object[0];
            }
        }
//        [SVProgressHUD showCustomSuccessWithStatus:message];
        
    } failure:^(id responseObject, NSError *error) {
//        [SVProgressHUD showCustomErrorWithStatus:HitoLoginFaiTitle];
    }];
}

#pragma mark - Action
- (IBAction)registerAction:(id)sender {
    [self registerRequest];
}

- (IBAction)agreementAction:(id)sender {
    LEWebViewController *vc = [[LEWebViewController alloc] initWithHtmlString:self.agreementContentHtmlText];
    [self.navigationController pushViewController:vc animated:true];
}

@end
