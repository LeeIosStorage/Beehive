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

@interface LLPayPasswordResetViewController ()

@property (nonatomic, weak) IBOutlet UILabel *labPhone;
@property (nonatomic, weak) IBOutlet UIView *passwordContView;
@property (nonatomic, strong) ZJPayPasswordView *payPasswordView;
@property (nonatomic, weak) IBOutlet UIButton *btnSendCode;
@property (nonatomic, weak) IBOutlet UIButton *btnNext;

@end

@implementation LLPayPasswordResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"变更支付密码";
//    [self needTapGestureRecognizer];
    self.view.backgroundColor = kAppBackgroundColor;
    
    [self.passwordContView addSubview:self.payPasswordView];
    [self.payPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.passwordContView);
    }];
    
    WEAKSELF
    self.payPasswordView.completionBlock = ^(NSString *password) {
        [weakSelf verifyCode:password];
    };
}

- (void)verifyCode:(NSString *)password {
    if ([password isEqualToString:@"123456"]) {
        [self gotoVerifyIdentity];
    } else {
        [self.payPasswordView didInputPasswordError];
    }
}

- (void)gotoVerifyIdentity {
    LLVerifyIdentityViewController *vc = [[LLVerifyIdentityViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)sendCodeAction:(id)sender {
    
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
