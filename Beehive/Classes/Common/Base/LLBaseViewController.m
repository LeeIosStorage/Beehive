//
//  LLBaseViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/2/27.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"
#import "UIViewController+LLNavigationBar.h"

@interface LLBaseViewController ()

@end

@implementation LLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.navigationController.viewControllers.count > 1) {
        [self createBarButtonItemAtPosition:LLNavigationBarPositionLeft normalImage:[UIImage imageNamed:@"light_nav_back"] highlightImage:[UIImage imageNamed:@"light_nav_back"] text:@"" action:@selector(backAction:)];
    } else {
    }
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

//- (void)injected {
//    NSLog(@"I've been injected: %@", self);
//    self.view.backgroundColor = UIColor.darkGrayColor;
//    self.navigationItem.title = @"我又来了1111222111";
//}

@end
