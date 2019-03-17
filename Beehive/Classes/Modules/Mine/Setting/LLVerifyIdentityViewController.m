//
//  LLVerifyIdentityViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLVerifyIdentityViewController.h"
#import "LLSetPayPasswordViewController.h"

@interface LLVerifyIdentityViewController ()

@property (nonatomic, weak) IBOutlet UITextField *tfName;
@property (nonatomic, weak) IBOutlet UITextField *tfIDCode;

@end

@implementation LLVerifyIdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setup {
    self.title = @"变更支付密码";
    [self needTapGestureRecognizer];
}

- (IBAction)nextAction:(id)sender {
    [self gotoSetPayPwdVc];
}

- (void)gotoSetPayPwdVc {
    LLSetPayPasswordViewController *vc = [[LLSetPayPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

@end
