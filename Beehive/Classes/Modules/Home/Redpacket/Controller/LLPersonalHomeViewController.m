//
//  LLPersonalHomeViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPersonalHomeViewController.h"
#import "LLPersonalHomeHeaderView.h"
#import "LLRedTaskHistoryTableViewCell.h"
#import "LLRedpacketNode.h"
#import "LLPersonalHomeNode.h"

@interface LLPersonalHomeViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) LLPersonalHomeHeaderView *personalHomeHeaderView;

@property (nonatomic, strong) LLPersonalHomeNode *personalHomeNode;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataLists;
@property (assign, nonatomic) int nextCursor;

@end

@implementation LLPersonalHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
    [self getPublisherInfo];
}

- (void)setup {
    self.title = @"个人主页";
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.dataLists = [NSMutableArray array];
    
    self.personalHomeHeaderView.height = 228;
    self.tableView.tableHeaderView = self.personalHomeHeaderView;
    
    self.nextCursor = 1;
    [self addMJ];
}

- (void)refreshData {
    [self.personalHomeHeaderView updateCellWithData:self.personalHomeNode];
}

#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    WEAKSELF;
    self.tableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        weakSelf.nextCursor = 1;
        [weakSelf getRedEnvelopesReleaseList];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //上啦加载
    self.tableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getRedEnvelopesReleaseList];
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

#pragma mark - Request
- (void)getPublisherInfo {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetPublisherInfo"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.userId forKey:@"id"];
    [params setObject:[NSNumber numberWithInteger:1] forKey:@"pageIndex"];
    [params setObject:[NSNumber numberWithInteger:1] forKey:@"pageSize"];
    
    NSString *caCheKey = @"GetPublisherInfo";
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:[LLPersonalHomeNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                weakSelf.personalHomeNode = data[0];
            }
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)getRedEnvelopesReleaseList {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetRedEnvelopesReleaseList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.userId forKey:@"id"];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"pageIndex"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"pageSize"];
    
    NSString *caCheKey = @"GetRedEnvelopesReleaseList";
    BOOL needCache = false;
    if (self.nextCursor == 1) needCache = true;
    [self.networkManager POST:requesUrl needCache:needCache caCheKey:caCheKey parameters:params responseClass:[LLRedpacketNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
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
- (LLPersonalHomeHeaderView *)personalHomeHeaderView {
    if (!_personalHomeHeaderView) {
        _personalHomeHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LLPersonalHomeHeaderView" owner:self options:nil] firstObject];
    }
    return _personalHomeHeaderView;
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
    
}

@end
