//
//  LLNavigationController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/2/27.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLNavigationController.h"

@interface LLNavigationController ()

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
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

@end
