//
//  LLBeeHomeViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/2/27.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeHomeViewController.h"
#import "LLBeeMineViewController.h"

@interface LLBeeHomeViewController ()

@end

@implementation LLBeeHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.navigationItem.title = @"首页是吧";
}

- (IBAction)testClickAction:(id)sender {
    LLBeeMineViewController *mineVc = [[LLBeeMineViewController alloc] init];
    mineVc.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:mineVc animated:true];
}

@end
