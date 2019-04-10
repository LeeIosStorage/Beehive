//
//  LLRegisterViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/4.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLRegisterViewController.h"
#import "LLUserInputView.h"
#import "LELinkerHandler.h"

@interface LLRegisterViewController ()
{
    NSTimer *_waitTimer;
    int _waitSecond;
}
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self invalidateTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
//    [self getUserAgreement];
}

- (void)setup {
    self.title = @"注册";
    if (self.vcType == LLAmendPhoneVcTypeBind) {
        self.title = @"绑定手机号";
        self.agreementButton.hidden = true;
    }
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
    
//    self.phoneInputView.textField.text = @"13803833466";
//    self.smsCodeInputView.textField.text = @"123456";
//    self.passwordInputView.textField.text = @"1";
//    self.passwordConfirmInputView.textField.text = @"1";
    
    self.registerButton.backgroundColor = kAppThemeColor;
    self.registerButton.layer.cornerRadius = 5;
    self.registerButton.layer.masksToBounds = true;
    
    NSString *attStr = @"注册即表示同意《蜂巢用户注册协议》";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:attStr];
    NSDictionary *attributes = @{NSFontAttributeName:[FontConst PingFangSCRegularWithSize:14], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"a9a9aa"]};
    [attributedString addAttributes:attributes range:NSMakeRange(0, 7)];
    NSDictionary *attributes2 = @{NSFontAttributeName:[FontConst PingFangSCRegularWithSize:14], NSForegroundColorAttributeName:kAppThemeColor};
    [attributedString addAttributes:attributes2 range:NSMakeRange(7, 10)];
    [self.agreementButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    [self needTapGestureRecognizer];
}

- (void)registerRequest{
    
    if (self.phoneInputView.textField.text.length == 0 || self.passwordInputView.textField.text.length == 0 || self.smsCodeInputView.textField.text.length == 0) {
        [SVProgressHUD showCustomInfoWithStatus:@"请输入手机号、验证码、密码"];
        return;
    }
//    if (self.inviteCodeInputView.textField.text.length == 0) {
//        [SVProgressHUD showCustomInfoWithStatus:@"请输入邀请码"];
//        return;
//    }
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
    
    NSString *inviteCode = @"";
    if (self.inviteCodeInputView.textField.text.length > 0) {
        inviteCode = self.inviteCodeInputView.textField.text;
    }
    [params setObject:inviteCode forKey:@"inviteCode"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:message];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:true];
        });
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
    
}

- (void)bindPhoneRequest {
    [SVProgressHUD showCustomWithStatus:HitoRequestLoadingTitle];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"BindPhone"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneInputView.textField.text forKey:@"Phone"];
    [params setObject:self.smsCodeInputView.textField.text forKey:@"smsCode"];
    [params setObject:self.passwordInputView.textField.text forKey:@"Password"];
    NSString *inviteCode = @"";
    if (self.inviteCodeInputView.textField.text.length > 0) {
        inviteCode = self.inviteCodeInputView.textField.text;
    }
    [params setObject:inviteCode forKey:@"inviteCode"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:message];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf dismissViewControllerAnimated:true completion:nil];
        });
        
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
    NSInteger method = 1;
//    if (self.vcType == LLAmendPhoneVcTypeBind) {
//        method = 3;
//    }
    [self addTimer];
    [params setObject:[NSNumber numberWithInteger:method] forKey:@"Method"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            [weakSelf removeTimer];
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:message];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoLoginFaiTitle];
        [weakSelf removeTimer];
    }];
}

- (void)getUserAgreement {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetUserAgreement"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self.networkManager POST:requesUrl needCache:true caCheKey:@"GetUserAgreement" parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
//            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *object = (NSArray *)dataObject;
            if (object.count > 0) {
                weakSelf.agreementContentHtmlText = object[0];
            }
        }
//        [SVProgressHUD showCustomSuccessWithStatus:message];
        
    } failure:^(id responseObject, NSError *error) {
//        [SVProgressHUD showCustomErrorWithStatus:HitoLoginFaiTitle];
    }];
}

#pragma mark - Action
- (IBAction)registerAction:(id)sender {
    if (self.vcType == LLAmendPhoneVcTypeBind) {
        [self bindPhoneRequest];
    } else {
        [self registerRequest];
    }
}

- (IBAction)agreementAction:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@/Agreement.html",[WYAPIGenerate sharedInstance].baseURL];
    [LELinkerHandler handleDealWithHref:url From:self.navigationController];
}

#pragma mark - Timer
-(void)addTimer {
    if(_waitTimer){
        [_waitTimer invalidate];
        _waitTimer = nil;
    }
    _waitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(waitTimerInterval:) userInfo:nil repeats:YES];
    if (_waitSecond <= 0) {
        _waitSecond = 60;
    }
    [self waitTimerInterval:_waitTimer];
}
-(void)resetTimer {
    if (_waitSecond <= 0) {
        return;
    }
    [self addTimer];
}
-(void)invalidateTimer {
    if(_waitTimer){
        [_waitTimer invalidate];
        _waitTimer = nil;
    }
}
-(void)removeTimer{
    if(_waitTimer){
        [_waitTimer invalidate];
        _waitTimer = nil;
    }
    _waitSecond = 0;
    self.smsCodeInputView.smsCodeButton.enabled = true;
    [self.smsCodeInputView.smsCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.smsCodeInputView.smsCodeButton setTitle:@"获取验证码" forState:UIControlStateDisabled];
}
- (void)waitTimerInterval:(NSTimer *)aTimer{
    LELog(@"a Timer with WYSettingConfig waitRegisterTimerInterval = %d",_waitSecond);
    if (_waitSecond <= 0) {
        [aTimer invalidate];
        _waitTimer = nil;
        self.smsCodeInputView.smsCodeButton.enabled = true;
        [self.smsCodeInputView.smsCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.smsCodeInputView.smsCodeButton setTitle:@"获取验证码" forState:UIControlStateDisabled];
        return;
    }
    _waitSecond--;
    
    self.smsCodeInputView.smsCodeButton.enabled = false;
    [self.smsCodeInputView.smsCodeButton setTitle:[NSString stringWithFormat:@"(%d)重新获取",_waitSecond] forState:UIControlStateNormal];
    [self.smsCodeInputView.smsCodeButton setTitle:[NSString stringWithFormat:@"(%d)重新获取",_waitSecond] forState:UIControlStateDisabled];
}

@end
