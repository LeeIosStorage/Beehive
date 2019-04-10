//
//  LLAmendPhoneViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLAmendPhoneViewController.h"

@interface LLAmendPhoneViewController ()
{
    NSTimer *_waitTimer;
    int _waitSecond;
}
@property (nonatomic, weak) IBOutlet UITextField *tfPhone;
@property (nonatomic, weak) IBOutlet UITextField *tfSmsCode;

@property (nonatomic, weak) IBOutlet UIButton *btnSmsCode;

@end

@implementation LLAmendPhoneViewController

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
}

- (void)setup {
    self.title = @"修改手机号";
    [self needTapGestureRecognizer];
}

- (void)changePhoneRequest{
    
    [SVProgressHUD showCustomWithStatus:HitoRequestLoadingTitle];
    
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"UpdatePhone"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.tfPhone.text forKey:@"phone"];
    [params setObject:self.tfSmsCode.text forKey:@"validateCode"];
    
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

- (void)smsCodeRequest {
    if (self.tfPhone.text.length == 0) {
        [SVProgressHUD showCustomInfoWithStatus:@"请输入手机号"];
        return;
    }
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"SendSms"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.tfPhone.text forKey:@"Phone"];
    //Method：1：注册；2：重置密码；3：修改手机号(第二次)；4：修改支付密码；5：修改手机号（第一次）
    [params setObject:@"5" forKey:@"Method"];
    [self addTimer];
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

#pragma mark - Action
- (IBAction)affirmAction:(id)sender {
    if (self.tfPhone.text.length == 0) {
        [SVProgressHUD showCustomInfoWithStatus:@"请输入手机号"];
        return;
    }
    if (self.tfSmsCode.text.length == 0) {
        [SVProgressHUD showCustomInfoWithStatus:@"请输入验证码"];
        return;
    }
    [self changePhoneRequest];
}

- (IBAction)smsCodeAction:(id)sender {
    [self smsCodeRequest];
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
    self.btnSmsCode.enabled = true;
    [self.btnSmsCode setTitle:@"获取" forState:UIControlStateNormal];
    [self.btnSmsCode setTitle:@"获取" forState:UIControlStateDisabled];
}
- (void)waitTimerInterval:(NSTimer *)aTimer{
    LELog(@"a Timer with WYSettingConfig waitRegisterTimerInterval = %d",_waitSecond);
    if (_waitSecond <= 0) {
        [aTimer invalidate];
        _waitTimer = nil;
        self.btnSmsCode.enabled = true;
        [self.btnSmsCode setTitle:@"获取" forState:UIControlStateNormal];
        [self.btnSmsCode setTitle:@"获取" forState:UIControlStateDisabled];
        return;
    }
    _waitSecond--;
    
    self.btnSmsCode.enabled = false;
    [self.btnSmsCode setTitle:[NSString stringWithFormat:@"(%d)",_waitSecond] forState:UIControlStateNormal];
    [self.btnSmsCode setTitle:[NSString stringWithFormat:@"(%d)",_waitSecond] forState:UIControlStateDisabled];
}

@end
