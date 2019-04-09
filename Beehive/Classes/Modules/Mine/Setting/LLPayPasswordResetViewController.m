//
//  LLPayPasswordResetViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPayPasswordResetViewController.h"
#import "ZJPayPasswordView.h"
#import "LLVerifyIdentityViewController.h"
#import "LLSetPayPasswordViewController.h"

@interface LLPayPasswordResetViewController ()

@property (nonatomic, weak) IBOutlet UILabel *labPhone;
@property (nonatomic, weak) IBOutlet UIView *passwordContView;
@property (nonatomic, strong) ZJPayPasswordView *payPasswordView;
@property (nonatomic, weak) IBOutlet UIButton *btnSendCode;
@property (nonatomic, weak) IBOutlet UIButton *btnNext;

@property (nonatomic, strong) NSString *verifyCode;

@end

@implementation LLPayPasswordResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self smsCodeRequest];
}

- (void)setup {
    self.title = @"变更支付密码";
//    [self needTapGestureRecognizer];
    self.view.backgroundColor = kAppBackgroundColor;
    
    NSString *phone = [LELoginUserManager mobile];
    if (phone.length > 7) {
        NSString *numberString = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.labPhone.text = numberString;
    }
    
    [self.passwordContView addSubview:self.payPasswordView];
    [self.payPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.passwordContView);
    }];
    
    WEAKSELF
    self.payPasswordView.completionBlock = ^(NSString *password) {
        [weakSelf verifyCode:password];
    };
}

#pragma mark - Request
- (void)smsCodeRequest {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    //    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"SendSms"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[LELoginUserManager mobile] forKey:@"Phone"];
    //Method：1：注册；2：重置密码；3：修改手机号(第二次)；4：修改支付密码；5：修改手机号（第一次）
    [params setObject:@"4" forKey:@"Method"];
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

- (void)verifyCode:(NSString *)password {
    self.verifyCode = password;
    [self gotoVerifyIdentity];
//    if ([password isEqualToString:@"123456"]) {
//        [self gotoVerifyIdentity];
//    } else {
//        [self.payPasswordView didInputPasswordError];
//    }
}

- (void)gotoVerifyIdentity {
    if (self.verifyCode.length < 6) {
        [SVProgressHUD showCustomInfoWithStatus:@"请输入验证码"];
        return;
    }
    LLSetPayPasswordViewController *vc = [[LLSetPayPasswordViewController alloc] init];
    vc.verifyCode = self.verifyCode;
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)sendCodeAction:(id)sender {
    [self smsCodeRequest];
}

- (IBAction)nextAction:(id)sender {
    [self gotoVerifyIdentity];
}

#pragma mark - setget
- (ZJPayPasswordView *)payPasswordView
{
    if (!_payPasswordView)
    {
        _payPasswordView = [[ZJPayPasswordView alloc] init];
    }
    return _payPasswordView;
}

@end
