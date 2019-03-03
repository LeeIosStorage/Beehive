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
#import "LLRedRuleViewController.h"
#import "LLCityOptionHeaderView.h"
#import <MAMapKit/MAMapKit.h>

@interface LLBeeHomeViewController ()

@property (nonatomic, strong) LLCityOptionHeaderView *cityOptionHeaderView;

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation LLBeeHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)injected {
}

#pragma mark -
#pragma mark - Methods
- (void)setup {
    
    [self createBarButtonItemAtPosition:LLNavigationBarPositionRight normalImage:[UIImage imageNamed:@"home_nav_help"] highlightImage:nil text:@"" action:@selector(ruleClickAction:)];
    
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.cityOptionHeaderView];
    [self.cityOptionHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(65);
    }];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.cityOptionHeaderView.mas_bottom);
    }];
    
    self.mapView.showsUserLocation = true;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}

#pragma mark -
#pragma mark - Action
- (void)ruleClickAction:(id)sender {
    LLRedRuleViewController *vc = [[LLRedRuleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark -
#pragma mark - SettingAndGetting
- (LLCityOptionHeaderView *)cityOptionHeaderView {
    if (!_cityOptionHeaderView) {
        _cityOptionHeaderView = [[LLCityOptionHeaderView alloc] init];
    }
    return _cityOptionHeaderView;
}

- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] init];
    }
    return _mapView;
}

@end
