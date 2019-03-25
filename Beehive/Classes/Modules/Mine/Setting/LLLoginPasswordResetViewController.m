//
//  LLLoginPasswordResetViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLLoginPasswordResetViewController.h"

@interface LLLoginPasswordResetViewController ()

@property (nonatomic, weak) IBOutlet UITextField *tfOldPwd;
@property (nonatomic, weak) IBOutlet UITextField *tfNewPwd;
@property (nonatomic, weak) IBOutlet UITextField *tfAffirmPwd;

@end

@implementation LLLoginPasswordResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"修改登录密码";
    [self needTapGestureRecognizer];
}

- (void)resetPwdRequest{
    
    if (self.tfOldPwd.text.length == 0 || self.tfNewPwd.text.length == 0 || self.tfAffirmPwd.text.length == 0) {
        [SVProgressHUD showCustomInfoWithStatus:@"请输入密码"];
        return;
    }
    if (![self.tfNewPwd.text isEqualToString:self.tfAffirmPwd.text]) {
        [SVProgressHUD showCustomInfoWithStatus:@"两次新密码不一致"];
        return;
    }
    [SVProgressHUD showCustomWithStatus:HitoRequestLoadingTitle];
    
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"UpdatePwd"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.tfOldPwd.text forKey:@"oldPwd"];
    [params setObject:self.tfAffirmPwd.text forKey:@"newPwd"];
    
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

- (IBAction)affirmAction:(id)sender {
    [self resetPwdRequest];
}

@end
