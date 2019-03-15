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
#import "LEWebViewController.h"
#import "LLCommodityExchangeViewController.h"
#import "LLRedTaskViewController.h"
#import "LLRedTaskHistoryViewController.h"
#import "LLAwardRecordViewController.h"
#import "LLReceiveRedAlertView.h"
#import "LEAlertMarkView.h"
#import "LLRedpacketDetailsViewController.h"
#import "LLPartnerViewController.h"
#import "UIButton+WebCache.h"

@interface LLBeeHomeViewController ()

@property (nonatomic, strong) LLCityOptionHeaderView *cityOptionHeaderView;

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) UIButton *btnExchange;
@property (nonatomic, strong) UIButton *btnSingin;
@property (nonatomic, strong) UIButton *btnRefresh;
@property (nonatomic, strong) UIButton *btnRedTask;
@property (nonatomic, strong) UIButton *btnRedHistory;
@property (nonatomic, strong) UIButton *btnShare;

@property (nonatomic, strong) UIButton *btnBottomAds;

@end

@implementation LLBeeHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self addBottomAds:kLLAppTestHttpURL];
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
    
    [self.view addSubview:self.btnExchange];
    [self.btnExchange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.cityOptionHeaderView.mas_bottom).offset(80);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
    [self.view addSubview:self.btnSingin];
    [self.btnSingin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.btnExchange.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
    [self.view addSubview:self.btnRefresh];
    [self.btnRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.btnSingin.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
    [self.view addSubview:self.btnRedTask];
    [self.btnRedTask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.cityOptionHeaderView.mas_bottom).offset(80);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
    [self.view addSubview:self.btnRedHistory];
    [self.btnRedHistory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.btnExchange.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
    [self.view addSubview:self.btnShare];
    [self.btnShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.btnSingin.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
    
    self.mapView.showsCompass = false;
    self.mapView.showsUserLocation = true;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}

- (void)receiveRedAlertViewShow {
    LLReceiveRedAlertView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"LLReceiveRedAlertView" owner:self options:nil] firstObject];
    tipView.frame = CGRectMake(0, 0, 186, 280);
    [tipView updateCellWithData:nil];
    __weak UIView *weakView = tipView;
    WEAKSELF
    tipView.clickBlock = ^(NSInteger index) {
        if ([weakView.superview isKindOfClass:[LEAlertMarkView class]]) {
            LEAlertMarkView *alert = (LEAlertMarkView *)weakView.superview;
            [alert dismiss];
        }
        if (index == 0) {
            [weakSelf gotoRedpacketDetailsVc];
        }
    };
    LEAlertMarkView *alert = [[LEAlertMarkView alloc] initWithCustomView:tipView type:LEAlertMarkViewTypeCenter];
    [alert show];
}

- (void)gotoRedpacketDetailsVc {
    LLRedpacketDetailsViewController *vc = [[LLRedpacketDetailsViewController alloc] init];
    vc.vcType = 1;
    [self.navigationController pushViewController:vc animated:true];
}

- (void)addBottomAds:(NSString *)url {
    [self.mapView addSubview:self.btnBottomAds];
    [self.btnBottomAds mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.mapView);
        make.height.mas_equalTo(50);
    }];
    [self.btnBottomAds sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark - Action
- (void)ruleClickAction:(id)sender {
    LLRedRuleViewController *vc = [[LLRedRuleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)exchangeAction:(id)sender {
    LLCommodityExchangeViewController *vc = [[LLCommodityExchangeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)singinAction:(id)sender {
    LEWebViewController *vc = [[LEWebViewController alloc] initWithURLString:@"http://www.baidu.com"];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)refreshAction:(id)sender {
    LLAwardRecordViewController *vc = [[LLAwardRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)redTaskAction:(id)sender {
    LLRedTaskViewController *vc = [[LLRedTaskViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)redHistoryAction:(id)sender {
    LLRedTaskHistoryViewController *vc = [[LLRedTaskHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)shareAction:(id)sender {
    [self receiveRedAlertViewShow];
}

- (void)adsBtnAction {
    LLPartnerViewController *vc = [[LLPartnerViewController alloc] init];
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

- (UIButton *)btnExchange {
    if (!_btnExchange) {
        _btnExchange = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnExchange setImage:[UIImage imageNamed:@"home_store_exchange"] forState:UIControlStateNormal];
        [_btnExchange addTarget:self action:@selector(exchangeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnExchange;
}
- (UIButton *)btnSingin {
    if (!_btnSingin) {
        _btnSingin = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSingin setImage:[UIImage imageNamed:@"home_signin"] forState:UIControlStateNormal];
        [_btnSingin addTarget:self action:@selector(singinAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSingin;
}
- (UIButton *)btnShare {
    if (!_btnShare) {
        _btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnShare setImage:[UIImage imageNamed:@"home_share"] forState:UIControlStateNormal];
        [_btnShare addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnShare;
}
- (UIButton *)btnRefresh {
    if (!_btnRefresh) {
        _btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRefresh setImage:[UIImage imageNamed:@"home_redpacket_refresh"] forState:UIControlStateNormal];
        [_btnRefresh addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRefresh;
}
- (UIButton *)btnRedTask {
    if (!_btnRedTask) {
        _btnRedTask = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRedTask setImage:[UIImage imageNamed:@"home_redpacket_task"] forState:UIControlStateNormal];
        [_btnRedTask addTarget:self action:@selector(redTaskAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRedTask;
}
- (UIButton *)btnRedHistory {
    if (!_btnRedHistory) {
        _btnRedHistory = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRedHistory setImage:[UIImage imageNamed:@"home_redpacket_history"] forState:UIControlStateNormal];
        [_btnRedHistory addTarget:self action:@selector(redHistoryAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRedHistory;
}

- (UIButton *)btnBottomAds {
    if (!_btnBottomAds) {
        _btnBottomAds = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnBottomAds addTarget:self action:@selector(adsBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBottomAds;
}

@end
