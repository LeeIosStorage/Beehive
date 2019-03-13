//
//  LLCommodityExchangeViewController.m
//  Beehive
//
//  Created by liguangjun on 2019/3/12.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLCommodityExchangeViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "LLSegmentedHeadView.h"
#import "LLExchangeBaseViewController.h"
#import <HJTabViewController/HJTabViewBar.h>
#import <HJTabViewController/HJTabViewControllerPlugin_TabViewBar.h>
#import <HJTabViewController/HJTabViewControllerPlugin_HeaderScroll.h>
#import "UIViewController+LLNavigationBar.h"

@interface LLCommodityExchangeViewController ()
<
HJTabViewControllerDelagate,
HJTabViewControllerDataSource,
SDCycleScrollViewDelegate
>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) LLSegmentedHeadView *segmentedHeadView;

@end

@implementation LLCommodityExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"商品兑换中心";
    
    [self createBarButtonItemAtPosition:LLNavigationBarPositionLeft normalImage:[UIImage imageNamed:@"light_nav_back"] highlightImage:[UIImage imageNamed:@"light_nav_back"] text:@"" action:@selector(backAction:)];
    
    self.tabDataSource = self;
    self.tabDelegate = self;
    
    self.bannerView.imageURLStringsGroup = @[kLLAppTestHttpURL,kLLAppTestHttpURL,kLLAppTestHttpURL];
    
//    HJDefaultTabViewBar *tabViewBar = [HJDefaultTabViewBar new];
//    tabViewBar.normalColor = kAppTitleColor;
//    tabViewBar.highlightedColor = kAppThemeColor;
//    tabViewBar.delegate = self;
//    HJTabViewBar *tabViewBar = [HJTabViewBar new];
//    HJTabViewControllerPlugin_TabViewBar *tabViewBarPlugin = [[HJTabViewControllerPlugin_TabViewBar alloc] initWithTabViewBar:tabViewBar delegate:nil];
//    [self enablePlugin:tabViewBarPlugin];
    [self enablePlugin:[HJTabViewControllerPlugin_HeaderScroll new]];
//    [self reloadData];
}

#pragma mark - Action
- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - setget
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        
        [_headerView addSubview:self.bannerView];
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self->_headerView);
            make.height.mas_equalTo(160);
        }];
        
        [_headerView addSubview:self.segmentedHeadView];
        [self.segmentedHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self->_headerView);
            make.top.equalTo(self.bannerView.mas_bottom);
            make.height.mas_equalTo(40);
        }];
    }
    return _headerView;
}

- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[SDCycleScrollView alloc] init];
        _bannerView.delegate = self;
    }
    return _bannerView;
}

- (LLSegmentedHeadView *)segmentedHeadView {
    if (!_segmentedHeadView) {
        _segmentedHeadView = [[LLSegmentedHeadView alloc] init];
        [_segmentedHeadView setItems:@[@{kllSegmentedTitle:@"热门商品",kllSegmentedType:@(0)},@{kllSegmentedTitle:@"今日推荐",kllSegmentedType:@(0)}]];
        WEAKSELF
        _segmentedHeadView.clickBlock = ^(NSInteger index) {
            [weakSelf scrollToIndex:index animated:NO];
        };
    }
    return _segmentedHeadView;
}

#pragma mark -
#pragma mark - HJTabViewControllerDataSource
- (void)tabViewController:(HJTabViewController *)tabViewController scrollViewVerticalScroll:(CGFloat)contentPercentY {
    
}

- (void)tabViewController:(HJTabViewController *)tabViewController scrollViewDidScrollToIndex:(NSInteger)index {
    self.segmentedHeadView.selectIndex = index;
}

- (NSInteger)numberOfViewControllerForTabViewController:(HJTabViewController *)tabViewController {
    return 2;
}

- (UIViewController *)tabViewController:(HJTabViewController *)tabViewController viewControllerForIndex:(NSInteger)index {
    LLExchangeBaseViewController *vc = [[LLExchangeBaseViewController alloc] init];
    vc.vcType = index;
    return vc;
}

- (UIView *)tabHeaderViewForTabViewController:(HJTabViewController *)tabViewController {
    self.headerView.frame = CGRectMake(0, 0, 0, 200);
    return self.headerView;
}

- (CGFloat)tabHeaderBottomInsetForTabViewController:(HJTabViewController *)tabViewController {
    return 40;
}

- (UIEdgeInsets)containerInsetsForTabViewController:(HJTabViewController *)tabViewController {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    LELog(@"点击了图片%ld",index);
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    //    LELog(@"图片滑动到%ld",index);
}

@end
