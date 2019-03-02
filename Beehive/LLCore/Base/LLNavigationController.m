//
//  LLNavigationController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/2/27.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLNavigationController.h"
#import "UIViewController+LLNavigationBar.h"

@interface LLNavigationController ()
<
UINavigationControllerDelegate,
UIGestureRecognizerDelegate
>

@end

@implementation LLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.tintColor = UIColor.blackColor;
    self.navigationBar.barTintColor = UIColor.whiteColor;
    self.navigationBar.translucent = false;
    self.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.blackColor, NSFontAttributeName: [FontConst PingFangSCMediumWithSize:17]};
    self.navigationBar.shadowImage = [UIImage imageWithColor:LineColor size:CGSizeMake(SCREEN_WIDTH, 0.5)];
    
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return true;
    }
    return false;
}

// FIX: 侧滑手势与UIScrollView冲突的问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.interactivePopGestureRecognizer setEnabled:(self.viewControllers.count > 1)];
}

@end
