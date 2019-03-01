//
//  LLBeeHomeViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/2/27.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeHomeViewController.h"
#import "LLBeeMineViewController.h"
#import "UIViewController+LLNavigationBar.h"

@interface LLBeeHomeViewController ()

@end

@implementation LLBeeHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.navigationItem.title = @"首页";
    [self createBarButtonItemAtPosition:LLNavigationBarPositionRight normalImage:nil highlightImage:nil text:@"发布" action:@selector(testClickAction:)];
}

- (IBAction)testClickAction:(id)sender {
    LLBeeMineViewController *mineVc = [[LLBeeMineViewController alloc] init];
    [self.navigationController pushViewController:mineVc animated:true];
}

@end
