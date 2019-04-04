//
//  LLCollectListViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLCollectListViewController.h"
#import "LLMineCollectTableViewCell.h"
#import "LLSegmentedHeadView.h"
#import "LLCollectionListNode.h"
#import "LLCommodityExchangeDetailsViewController.h"
#import "LLRedpacketDetailsViewController.h"
#import "LLMessageDetailsViewController.h"

@interface LLCollectListViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) LLSegmentedHeadView *segmentedHeadView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataLists;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) int nextCursor;

@end

@implementation LLCollectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
}

- (void)setup {
    self.title = @"我的收藏";
    self.view.backgroundColor = kAppSectionBackgroundColor;
    
    self.currentPage = 0;
    self.dataLists = [NSMutableArray array];
    
    [self.view addSubview:self.segmentedHeadView];
    [self.segmentedHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segmentedHeadView.mas_bottom).offset(0);
    }];
    
    [self.tableView reloadData];
    
    self.nextCursor = 1;
    [self addMJ];
}

- (void)refreshData {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    WEAKSELF;
    self.tableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        weakSelf.nextCursor = 1;
        [weakSelf getMyCollectionList];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //上啦加载
    self.tableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getMyCollectionList];
    }];
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - Request
- (void)getMyCollectionList {
    //type:类别（0：商品；1：红包；2：便民信息）
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetMyCollectionList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"pageIndex"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"pageSize"];
    [params setObject:[NSNumber numberWithInteger:self.currentPage] forKey:@"type"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLCollectionListNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
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
            weakSelf.dataLists = [NSMutableArray array];
        }
        [weakSelf.dataLists addObjectsFromArray:tmpListArray];
        
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

#pragma mark - setget
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 57;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (LLSegmentedHeadView *)segmentedHeadView {
    if (!_segmentedHeadView) {
        _segmentedHeadView = [[LLSegmentedHeadView alloc] init];
        [_segmentedHeadView setItems:@[@{kllSegmentedTitle:@"商品",kllSegmentedType:@(0)},@{kllSegmentedTitle:@"红包",kllSegmentedType:@(0)},@{kllSegmentedTitle:@"便民信息",kllSegmentedType:@(0)}]];
        WEAKSELF
        _segmentedHeadView.clickBlock = ^(NSInteger index) {
            if (index == 0) {
                weakSelf.currentPage = 0;
                [weakSelf refreshData];
            } else if (index == 1) {
                weakSelf.currentPage = 1;
                [weakSelf refreshData];
            } else if (index == 2) {
                weakSelf.currentPage = 2;
                [weakSelf refreshData];
            }
        };
    }
    return _segmentedHeadView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LLMineCollectTableViewCell";
    LLMineCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    cell.indexPath = indexPath;
    [cell updateCellWithData:self.dataLists[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    LLCollectionListNode *cellNode = self.dataLists[indexPath.row];
    if (self.currentPage == 0) {
        LLExchangeGoodsNode *node = [[LLExchangeGoodsNode alloc] init];
        node.Id = cellNode.DataId;
        LLCommodityExchangeDetailsViewController *vc = [[LLCommodityExchangeDetailsViewController alloc] init];
        vc.exchangeGoodsNode = node;
        [self.navigationController pushViewController:vc animated:true];
    } else if (self.currentPage == 1) {
        LLRedpacketNode *node = [[LLRedpacketNode alloc] init];
        node.Id = cellNode.DataId;
        LLRedpacketDetailsViewController *vc = [[LLRedpacketDetailsViewController alloc] init];
        vc.redpacketNode = node;
        vc.vcType = 1;
        [self.navigationController pushViewController:vc animated:true];
    } else if (self.currentPage == 2) {
        LLMessageListNode *node = [[LLMessageListNode alloc] init];
        node.Id = cellNode.DataId;
        LLMessageDetailsViewController *vc = [[LLMessageDetailsViewController alloc] init];
        vc.messageListNode = node;
        [self.navigationController pushViewController:vc animated:true];
    }
}

@end
