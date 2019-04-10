//
//  LLSetPayPasswordViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLSetPayPasswordViewController.h"
#import "ZJPayPasswordView.h"

@interface LLSetPayPasswordViewController ()

@property (nonatomic, strong) UILabel *labTip;
@property (nonatomic, strong) ZJPayPasswordView *payPasswordView;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *onePwd;

@end

@implementation LLSetPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"重置密码";
    self.view.backgroundColor = kAppBackgroundColor;
    self.onePwd = @"";
    
    [self.view addSubview:self.labTip];
    [self.labTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(85);
    }];
    
    [self.view addSubview:self.payPasswordView];
    [self.payPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTip.mas_bottom).offset(19);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self refreshUI];
    
    WEAKSELF
    self.payPasswordView.completionBlock = ^(NSString *password) {
        [weakSelf verifyCode:password];
    };
}

- (void)refreshUI {
    if (self.type == 0) {
        self.labTip.text = @"设置支付密码";
    } else {
        self.labTip.text = @"确认支付密码";
    }
}

- (void)verifyCode:(NSString *)password {
    if (self.type == 0) {
        self.type = 1;
        self.onePwd = password;
        [self refreshUI];
        [self.payPasswordView clearAllLabelText];
    } else {
        if ([password isEqualToString:self.onePwd]) {
            [self setPwdRequest];
        } else {
            [SVProgressHUD showCustomErrorWithStatus:@"两次密码不一致，请重新输入"];
            [self.payPasswordView didInputPasswordError];
            self.type = 0;
            self.onePwd = @"";
            [self refreshUI];
            [self.payPasswordView clearAllLabelText];
        }
    }
}

- (void)setPwdRequest {
    [SVProgressHUD showCustomWithStatus:@"设置中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"UpdatePayPwd"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.onePwd forKey:@"newPwd"];
    
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

#pragma mark - setget
- (UILabel *)labTip {
    if (!_labTip) {
        _labTip = [[UILabel alloc] init];
        _labTip.textColor = kAppTitleColor;
        _labTip.font = [FontConst PingFangSCRegularWithSize:13];
        _labTip.text = @"设置支付密码";
    }
    return _labTip;
}

- (ZJPayPasswordView *)payPasswordView
{
    if (!_payPasswordView)
    {
        _payPasswordView = [[ZJPayPasswordView alloc] init];
    }
    return _payPasswordView;
}

@end
