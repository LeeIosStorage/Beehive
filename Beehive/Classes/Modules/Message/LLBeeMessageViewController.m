//
//  LLBeeMessageViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/2/28.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeMessageViewController.h"
#import "UIViewController+LLNavigationBar.h"
#import "LESearchBar.h"
#import "LLSegmentedHeadView.h"
#import "LLMessageTimeLineViewCell.h"
#import "LLMessageDetailsViewController.h"
#import "LLFilterDistanceView.h"
#import "CYLTabBarController.h"

@interface LLBeeMessageViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UIView *customTitleView;
@property (nonatomic, strong) LESearchBar *searchBar;

@property (nonatomic, strong) LLSegmentedHeadView *segmentedHeadView;

@property (nonatomic, strong) LLFilterDistanceView *filterDistanceView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *messageLists;

@end

@implementation LLBeeMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
//    self.navigationItem.title = @"信息";
    self.view.backgroundColor = kAppSectionBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.messageLists = [NSMutableArray array];
    
    [self createBarButtonItemAtPosition:LLNavigationBarPositionRight normalImage:nil highlightImage:nil text:@"搜索" action:@selector(searchAction:)];
    
    self.navigationItem.titleView = self.customTitleView;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchBarResign)];
//    [self.view addGestureRecognizer:tap];
    
    [self.view addSubview:self.segmentedHeadView];
    [self.segmentedHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segmentedHeadView.mas_bottom).offset(10);
    }];

    [self.tableView reloadData];
    
    
}

- (void)showFilterDistanceView {
    if (self.filterDistanceView.superview) {
        [self.filterDistanceView dismiss];
        return;
    }
    CYLTabBarController *tabBarController = [self cyl_tabBarController];
    [tabBarController.view addSubview:self.filterDistanceView];
    [self.filterDistanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(tabBarController.view);
        make.top.mas_equalTo(40 + HitoTopHeight);
    }];
    [self.filterDistanceView show];
}

#pragma mark - Action
- (void)searchBarResign {
    [self.searchBar resignFirstResponder];
}

- (void)searchAction:(id)sender {
    [self searchBarResign];
//    [SVProgressHUD showCustomWithStatus:@"搜索中"];
}

#pragma mark - SetAndGet
- (UIView *)customTitleView {
    if (!_customTitleView) {
        _customTitleView = [[UIView alloc] init];
        _customTitleView.backgroundColor = kAppSectionBackgroundColor;
        _customTitleView.frame = CGRectMake(0, 0, 220, 26);
        _customTitleView.layer.cornerRadius = 13;
        _customTitleView.layer.masksToBounds = true;
        
        self.searchBar = [[LESearchBar alloc] initWithFrame:_customTitleView.frame];
        NSString *placeholder = @"输入信息内容";
        self.searchBar.attributedPlaceholder = [WYCommonUtils stringToColorAndFontAttributeString:placeholder range:NSMakeRange(0, placeholder.length) font:[FontConst PingFangSCRegularWithSize:14] color:[UIColor colorWithHexString:@"a9a9aa"]];
        [_customTitleView addSubview:self.searchBar];
    }
    return _customTitleView;
}

- (LLSegmentedHeadView *)segmentedHeadView {
    if (!_segmentedHeadView) {
        _segmentedHeadView = [[LLSegmentedHeadView alloc] init];
        [_segmentedHeadView setItems:@[@{kllSegmentedTitle:@"附近信息",kllSegmentedType:@(0)},@{kllSegmentedTitle:@"附近距离",kllSegmentedType:@(1)}]];
        WEAKSELF
        _segmentedHeadView.clickBlock = ^(NSInteger index) {
            if (index == 0) {
                if (weakSelf.filterDistanceView.superview) {
                    [weakSelf.filterDistanceView dismiss];
                }
            } else if (index == 1) {
                [weakSelf showFilterDistanceView];
            }
        };
    }
    return _segmentedHeadView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (LLFilterDistanceView *)filterDistanceView {
    if (!_filterDistanceView) {
        _filterDistanceView = [[LLFilterDistanceView alloc] init];
        [_filterDistanceView setHidden:true];
    }
    return _filterDistanceView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LLMessageTimeLineViewCell";
    LLMessageTimeLineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    [cell updateCellWithData:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
//    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    LLMessageDetailsViewController *vc = [[LLMessageDetailsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self searchBarResign];
    }
}

@end
