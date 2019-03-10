//
//  LLMapAddressViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/11.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMapAddressViewController.h"
#import "LLMapAddressSearchViewController.h"

@interface LLMapAddressViewController ()

@end

@implementation LLMapAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"选择地址";
    //3_2_4.1
    [self createBarButtonItemAtPosition:LLNavigationBarPositionRight normalImage:[UIImage imageNamed:@"3_2_4.1"] highlightImage:[UIImage imageNamed:@"3_2_4.1"] text:nil action:@selector(searchAddress)];
}

- (void)searchAddress {
    LLMapAddressSearchViewController *vc = [[LLMapAddressSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

@end
