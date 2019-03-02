//
//  LELoginManager.m
//  XWAPP
//
//  Created by hys on 2018/5/22.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LELoginManager.h"
#import "LLNavigationController.h"

@interface LELoginManager ()

@property (copy, nonatomic) LELoginSuccessBlock         loginSuccessBlock;
@property (copy, nonatomic) LELoginFailureBlock         loginFailureBlock;
@property (copy, nonatomic) LELoginCancelBlock          loginCancelBlock;
@property (strong, nonatomic) LLLoginViewController     *loginViewController;

@property (weak, nonatomic) UIViewController *fromViewController;

@end

@implementation LELoginManager

+ (LELoginManager *)sharedInstance{
    
    static LELoginManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark -
#pragma mark - Public
- (void)showLoginViewControllerFromPresentViewController:(UIViewController *)fromViewController
                                        showCancelButton:(BOOL)showCancel
                                                 success:(LELoginSuccessBlock)success
                                                 failure:(LELoginFailureBlock)failure
                                                  cancel:(LELoginCancelBlock)cancel{
    if (!fromViewController) {
        cancel();
        return;
    }
    if (![fromViewController isKindOfClass:[UIViewController class]]) {
        cancel();
        return;
    }
    self.isShowLogin = YES;
    self.loginSuccessBlock = success;
    self.loginFailureBlock = failure;
    self.loginCancelBlock = cancel;
    
//    PhoneLogin *phoneVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PhoneLogin"];
    LLLoginViewController *loginVc = [[LLLoginViewController alloc] init];
    loginVc.hidesBottomBarWhenPushed = YES;
    if (!self.fromViewController) {
        self.fromViewController = fromViewController;
    }
    
    LLNavigationController *nav = [[LLNavigationController alloc] initWithRootViewController:loginVc];
    nav.navigationBarHidden = YES;
    
    [fromViewController presentViewController:nav animated:YES completion:^{
        
    }];
    
    self.loginViewController = loginVc;
    WEAKSELF;
    loginVc.loginSuccessBlock = ^(void) {
        [weakSelf didLoginSuccess];
        [weakSelf.loginViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    loginVc.loginCancelBlock = ^{
        [weakSelf doCancel];
        [weakSelf.loginViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    
}

- (BOOL)needUserLogin:(UIViewController *)fromViewController{
    
//    HitoWeakSelf;
    if (![LELoginUserManager hasAccoutLoggedin]) {
        __weak UIViewController *currentVC = fromViewController;
        [self showLoginViewControllerFromPresentViewController:fromViewController showCancelButton:YES success:^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUILoginNotificationKey object:nil];
            if ([currentVC isKindOfClass:[LLBaseViewController class]]) {
                LLBaseViewController *superVc = (LLBaseViewController *)currentVC;
                [superVc refreshViewWithObject:nil];
            }
            
        } failure:^(NSString *errorMessage) {
            
        } cancel:^{
            
        }];
        return YES;
    }
    return NO;

}

#pragma mark -
#pragma mark - Private
- (void)didLoginSuccess {
    if (self.loginSuccessBlock) {
        self.isShowLogin = NO;
        self.loginSuccessBlock();
    }
}

- (void)doCancel
{
    if (self.loginCancelBlock) {
        self.isShowLogin = NO;
        self.loginCancelBlock();
    }
}

@end
