//
//  LLRedTaskHistoryViewController.m
//  Beehive
//
//  Created by liguangjun on 2019/3/12.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLRedTaskHistoryViewController.h"
#import "LLSegmentedHeadView.h"
#import "LLRedTaskHistoryTableViewCell.h"
#import "LLRedTaskHistoryHeaderView.h"
#import "LLRedTaskHistoryNode.h"
#import "LLRedpacketDetailsViewController.h"

@interface LLRedTaskHistoryViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) LLSegmentedHeadView *segmentedHeadView;

@property (nonatomic, strong) LLRedTaskHistoryHeaderView *redTaskHistoryHeaderView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LLRedTaskHistoryNode *redTaskHistoryNode;
@property (nonatomic, strong) NSMutableArray *dataLists;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) int nextCursor;

@end

@implementation LLRedTaskHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshHeaderViewUI];
}

- (void)setup {
    self.title = @"红包任务历史";
    
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
    
    self.redTaskHistoryHeaderView.height = 116;
    self.tableView.tableHeaderView = self.redTaskHistoryHeaderView;
    
    [self.tableView reloadData];
    
    self.nextCursor = 1;
    [self addMJ];
}

- (void)refreshData {
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshHeaderViewUI {
    if (self.currentPage == 0) {
        self.redTaskHistoryHeaderView.labTotalAmount.text = [NSString stringWithFormat:@"%.2f",self.redTaskHistoryNode.SumGrabMoney];
        self.redTaskHistoryHeaderView.labTotalType.text = @"元";
        self.redTaskHistoryHeaderView.labTotalTip.text = @"抢到的总金额";
        self.redTaskHistoryHeaderView.labDayAmount.text = [NSString stringWithFormat:@"%.2f",self.redTaskHistoryNode.DaySumGrabMoney];
        self.redTaskHistoryHeaderView.labDayType.text = @"元";
        self.redTaskHistoryHeaderView.labDayTip.text = @"当日抢金额";
    } else {
        self.redTaskHistoryHeaderView.labTotalAmount.text = [NSString stringWithFormat:@"%.2f",self.redTaskHistoryNode.SumMoney];
        self.redTaskHistoryHeaderView.labTotalType.text = @"元";
        self.redTaskHistoryHeaderView.labTotalTip.text = @"发布总金额";
        self.redTaskHistoryHeaderView.labDayAmount.text = [NSString stringWithFormat:@"%d",self.redTaskHistoryNode.SumUserCount];
        self.redTaskHistoryHeaderView.labDayType.text = @"人";
        self.redTaskHistoryHeaderView.labDayTip.text = @"累计影响人数";
    }
}

#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    WEAKSELF;
    self.tableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        weakSelf.nextCursor = 1;
        [weakSelf getRedEnvelopesHistoryList];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //上啦加载
    self.tableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getRedEnvelopesHistoryList];
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

#pragma mark - Request
- (void)getRedEnvelopesHistoryList {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetRedEnvelopesHistoryList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"pageIndex"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"pageSize"];
    [params setObject:[NSNumber numberWithInteger:self.currentPage] forKey:@"type"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLRedTaskHistoryNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        NSArray *tmpListArray = [NSArray array];
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                weakSelf.redTaskHistoryNode = data[0];
                tmpListArray = weakSelf.redTaskHistoryNode.RedEnvelopeList;
            }
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
        
        [weakSelf refreshHeaderViewUI];
        [weakSelf.tableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - SetGet
- (LLSegmentedHeadView *)segmentedHeadView {
    if (!_segmentedHeadView) {
        _segmentedHeadView = [[LLSegmentedHeadView alloc] init];
        [_segmentedHeadView setItems:@[@{kllSegmentedTitle:@"抢到的红包",kllSegmentedType:@(0)},@{kllSegmentedTitle:@"发出的红包",kllSegmentedType:@(0)}]];
        WEAKSELF
        _segmentedHeadView.clickBlock = ^(NSInteger index) {
            if (index == 0) {
                weakSelf.currentPage = 0;
                [weakSelf refreshData];
            } else if (index == 1) {
                weakSelf.currentPage = 1;
                [weakSelf refreshData];
            }
        };
    }
    return _segmentedHeadView;
}

- (LLRedTaskHistoryHeaderView *)redTaskHistoryHeaderView {
    if (!_redTaskHistoryHeaderView) {
        _redTaskHistoryHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LLRedTaskHistoryHeaderView" owner:self options:nil] firstObject];
    }
    return _redTaskHistoryHeaderView;
}

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
    static NSString *cellIdentifier = @"LLRedTaskHistoryTableViewCell";
    LLRedTaskHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
    LLRedpacketNode *cellNode = self.dataLists[indexPath.row];
    LLRedpacketDetailsViewController *vc = [[LLRedpacketDetailsViewController alloc] init];
    vc.redpacketNode = cellNode;
    vc.vcType = 1;
    [self.navigationController pushViewController:vc animated:true];
}

@end
