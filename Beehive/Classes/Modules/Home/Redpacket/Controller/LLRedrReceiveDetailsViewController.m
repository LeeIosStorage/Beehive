//
//  LLRedrReceiveDetailsViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLRedrReceiveDetailsViewController.h"
#import "LLRedrReceiveDetailsHeaderView.h"
#import "LLRedReceiveUserTableViewCell.h"
#import "LLRedReceiveDetailNode.h"

@interface LLRedrReceiveDetailsViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) LLRedrReceiveDetailsHeaderView *redReceiveDetailsHeaderView;

@property (nonatomic, strong) LLRedReceiveDetailNode *redReceiveDetailNode;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataLists;
@property (assign, nonatomic) int nextCursor;

@end

@implementation LLRedrReceiveDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
    [self redEnvelopesReceiveDetail];
}

- (void)setup {
    self.title = @"红包详情";
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.dataLists = [NSMutableArray array];
    
    self.redReceiveDetailsHeaderView.height = 238;
    self.tableView.tableHeaderView = self.redReceiveDetailsHeaderView;
    
    self.nextCursor = 1;
    [self addMJ];
}

- (void)refreshData {
    [self.redReceiveDetailsHeaderView updateCellWithData:self.redReceiveDetailNode];
}

#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    WEAKSELF;
    self.tableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        weakSelf.nextCursor = 1;
        [weakSelf getRedEnvelopesReceiveList];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //上啦加载
    self.tableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getRedEnvelopesReceiveList];
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

#pragma mark - Request
- (void)redEnvelopesReceiveDetail {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"RedEnvelopesReceiveDetail"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.redId forKey:@"id"];
    [params setObject:[NSNumber numberWithInteger:1] forKey:@"pageIndex"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"pageSize"];
    
    NSString *caCheKey = @"RedEnvelopesReceiveDetail";
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:[LLRedReceiveDetailNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                weakSelf.redReceiveDetailNode = data[0];
            }
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)getRedEnvelopesReceiveList {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetRedEnvelopesReceiveList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.redId forKey:@"id"];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"pageIndex"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"pageSize"];
    
    NSString *caCheKey = @"GetRedEnvelopesReceiveList";
    BOOL needCache = false;
    if (self.nextCursor == 1) needCache = true;
    [self.networkManager POST:requesUrl needCache:needCache caCheKey:caCheKey parameters:params responseClass:[LLUserInfoNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
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

#pragma mark - set
- (LLRedrReceiveDetailsHeaderView *)redReceiveDetailsHeaderView {
    if (!_redReceiveDetailsHeaderView) {
        _redReceiveDetailsHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LLRedrReceiveDetailsHeaderView" owner:self options:nil] firstObject];
    }
    return _redReceiveDetailsHeaderView;
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
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LLRedReceiveUserTableViewCell";
    LLRedReceiveUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
    
}

@end
