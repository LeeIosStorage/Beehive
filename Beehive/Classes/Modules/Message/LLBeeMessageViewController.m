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
#import "LLMessageListNode.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "LLLocationManager.h"
#import "LLPersonalHomeViewController.h"

@interface LLBeeMessageViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
AMapLocationManagerDelegate,
UISearchBarDelegate
>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;

@property (nonatomic, strong) UIView *customTitleView;
@property (nonatomic, strong) LESearchBar *searchBar;

@property (nonatomic, strong) LLSegmentedHeadView *segmentedHeadView;

@property (nonatomic, strong) LLFilterDistanceView *filterDistanceView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *messageLists;

@property (assign, nonatomic) int nextCursor;

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
    
    self.currentCoordinate = [LLLocationManager sharedInstance].currentCoordinate;
    [self.locationManager startUpdatingLocation];
    
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
    
    self.nextCursor = 1;
    [self addMJ];
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

- (void)avatarWithCell:(LLMessageTimeLineViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        LLMessageListNode *node = self.messageLists[indexPath.row];
        LLPersonalHomeViewController *vc = [[LLPersonalHomeViewController alloc] init];
        vc.userId = [node.UserId description];
        [self.navigationController pushViewController:vc animated:true];
    }
}

#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    WEAKSELF;
    self.tableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        weakSelf.nextCursor = 1;
        [weakSelf getMessageList];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //上啦加载
    self.tableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getMessageList];
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

#pragma mark - Request
- (void)getMessageList {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetMessageList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"pageIndex"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"pageSize"];
    [params setObject:[NSNumber numberWithInteger:self.filterDistanceView.selectIndex + 1] forKey:@"type"];
    NSString *searchName = @"";
    if (self.searchBar.text.length > 0) {
        searchName = self.searchBar.text;
    }
    [params setValue:searchName forKey:@"searchName"];
    [params setValue:[NSNumber numberWithDouble:self.currentCoordinate.latitude] forKey:@"latitude"];
    [params setValue:[NSNumber numberWithDouble:self.currentCoordinate.longitude] forKey:@"longitude"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLMessageListNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        NSArray *tmpListArray = [NSArray array];
        if ([dataObject isKindOfClass:[NSArray class]]) {
            tmpListArray = (NSArray *)dataObject;
        }
        if (weakSelf.nextCursor == 1) {
            weakSelf.messageLists = [NSMutableArray array];
        }
        [weakSelf.messageLists addObjectsFromArray:tmpListArray];
        
        if (!isCache) {
            if (tmpListArray.count < DATA_LOAD_PAGESIZE_COUNT) {
                [weakSelf.tableView.mj_footer setHidden:YES];
            }else{
                [weakSelf.tableView.mj_footer setHidden:NO];
                weakSelf.nextCursor ++;
            }
        }
        
        [weakSelf.tableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Action
- (void)searchBarResign {
    [self.searchBar resignFirstResponder];
}

- (void)searchAction:(id)sender {
    [self searchBarResign];
    self.nextCursor = 1;
    [SVProgressHUD showCustomWithStatus:@"请求中"];
    [self getMessageList];
}

#pragma mark - SetAndGet
- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 200;
    }
    return _locationManager;
}

- (UIView *)customTitleView {
    if (!_customTitleView) {
        _customTitleView = [[UIView alloc] init];
        _customTitleView.backgroundColor = kAppSectionBackgroundColor;
        _customTitleView.frame = CGRectMake(0, 0, 220, 26);
        _customTitleView.layer.cornerRadius = 13;
        _customTitleView.layer.masksToBounds = true;
        
        self.searchBar = [[LESearchBar alloc] initWithFrame:_customTitleView.frame];
        self.searchBar.delegate = self;
        NSString *placeholder = @"输入信息内容";
        self.searchBar.attributedPlaceholder = [WYCommonUtils stringToColorAndFontAttributeString:placeholder range:NSMakeRange(0, placeholder.length) font:[FontConst PingFangSCRegularWithSize:14] color:[UIColor colorWithHexString:@"a9a9aa"]];
        [_customTitleView addSubview:self.searchBar];
    }
    return _customTitleView;
}

- (LLSegmentedHeadView *)segmentedHeadView {
    if (!_segmentedHeadView) {
        _segmentedHeadView = [[LLSegmentedHeadView alloc] init];
        [_segmentedHeadView setItems:@[@{kllSegmentedTitle:@"分类选择",kllSegmentedType:@(0)},@{kllSegmentedTitle:@"附近距离",kllSegmentedType:@(1)}]];
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
        WEAKSELF
        _filterDistanceView.selectBlock = ^(NSInteger index) {
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    return _filterDistanceView;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchAction:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.messageLists removeAllObjects];
    [self.tableView reloadData];
    [self searchAction:nil];
//    if (searchText.length == 0) {
//
//    }
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    self.currentCoordinate = location.coordinate;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageLists.count;
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
    WEAKSELF
    cell.avatarBlock = ^(id  _Nonnull cell) {
        [weakSelf avatarWithCell:cell];
    };
    [cell updateCellWithData:self.messageLists[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
//    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    LLMessageListNode *node = self.messageLists[indexPath.row];
    LLMessageDetailsViewController *vc = [[LLMessageDetailsViewController alloc] init];
    vc.messageListNode = node;
    [self.navigationController pushViewController:vc animated:true];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self searchBarResign];
    }
}

@end
