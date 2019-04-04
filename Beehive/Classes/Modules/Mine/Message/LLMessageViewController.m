//
//  LLMessageViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/8.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMessageViewController.h"
#import "LLSegmentedHeadView.h"
#import "LLMessageWarnTableViewCell.h"
#import "LLAttentionTableViewCell.h"
#import "LLMsgTickTableViewCell.h"
#import "LLReceiveCommentViewController.h"
#import "LLReceiveFavourViewController.h"
#import "LLMineMessageNode.h"
#import "LLFollowUserNode.h"

@interface LLMessageViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) LLSegmentedHeadView *segmentedHeadView;

@property (nonatomic, strong) LLMineMessageNode *mineMessageNode;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *attentionTableView;

@property (nonatomic, strong) NSMutableArray *dataLists;
@property (nonatomic, strong) NSMutableArray *attentionLists;
@property (nonatomic, assign) int nextCursor;
@property (nonatomic, assign) int attentionNextCursor;

@property (nonatomic, assign) NSInteger currentPage;


@end

@implementation LLMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

#pragma mark -
#pragma mark - Private
- (void)setup {
    self.title = @"消息";
    
    self.view.backgroundColor = kAppSectionBackgroundColor;
    
    self.currentPage = 0;
    
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
    
    [self.view addSubview:self.attentionTableView];
    [self.attentionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segmentedHeadView.mas_bottom).offset(0);
    }];
    self.attentionTableView.hidden = true;

    self.dataLists = [NSMutableArray array];
    [self.dataLists addObject:@[@{@"title":@"收到的评论", @"icon":@"1_1_0.1", @"action":@"comment"}, @{@"title":@"收到的赞", @"icon":@"1_1_0.2", @"action":@"favour"}]];
    [self.dataLists addObject:@[]];
    [self.tableView reloadData];
    
    self.nextCursor = 1;
    self.attentionNextCursor = 1;
    [self addMJ];
    
    [self refreshData];
}

- (void)refreshData {
    if (self.currentPage == 0) {
        self.tableView.hidden = false;
        self.attentionTableView.hidden = true;
        [self.tableView.mj_header beginRefreshing];
        return;
    }
    
    self.tableView.hidden = true;
    self.attentionTableView.hidden = false;
    
    [self.attentionTableView.mj_header beginRefreshing];
}

#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    WEAKSELF;
    self.tableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        weakSelf.nextCursor = 1;
        [weakSelf getMessage];
    }];
    [self.tableView.mj_header beginRefreshing];
    //上拉加载
//    self.tableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
//        [weakSelf getMessage];
//    }];
//    self.tableView.mj_footer.hidden = YES;
    
    self.attentionTableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        weakSelf.attentionNextCursor = 1;
        [weakSelf getFollowList];
    }];
    self.attentionTableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getFollowList];
    }];
    self.attentionTableView.mj_footer.hidden = YES;
    
}

#pragma mark - Request
- (void)getMessage {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetMessage"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"pageIndex"];
//    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"pageSize"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLMineMessageNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
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
            if (tmpListArray.count > 0) {
                self.mineMessageNode = tmpListArray[0];
            }
        }
        
        [self.dataLists replaceObjectAtIndex:1 withObject:self.mineMessageNode.NoticeList];
        
//        if (weakSelf.nextCursor == 1) {
//            weakSelf.dataLists = [NSMutableArray array];
//        }
//        [weakSelf.dataLists addObjectsFromArray:tmpListArray];
        
//        if (!isCache) {
//            if (tmpListArray.count < DATA_LOAD_PAGESIZE_COUNT) {
//                [weakSelf.tableView.mj_footer setHidden:YES];
//            }else{
//                [weakSelf.tableView.mj_footer setHidden:NO];
//                weakSelf.nextCursor ++;
//            }
//        }
        
        [weakSelf.tableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)getFollowList {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetFollowList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:self.attentionNextCursor] forKey:@"pageIndex"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"pageSize"];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"type"];
    
    NSString *caCheKey = [NSString stringWithFormat:@"GetFollowList-1"];
    BOOL needCache = false;
    if (self.attentionNextCursor == 1) needCache = true;
    [self.networkManager POST:requesUrl needCache:needCache caCheKey:caCheKey parameters:params responseClass:[LLFollowUserNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [weakSelf.attentionTableView.mj_header endRefreshing];
        [weakSelf.attentionTableView.mj_footer endRefreshing];
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        NSArray *tmpListArray = [NSArray array];
        if ([dataObject isKindOfClass:[NSArray class]]) {
            tmpListArray = (NSArray *)dataObject;
        }
        if (weakSelf.attentionNextCursor == 1) {
            weakSelf.attentionLists = [NSMutableArray array];
        }
        [weakSelf.attentionLists addObjectsFromArray:tmpListArray];
        
        if (!isCache) {
            if (tmpListArray.count < DATA_LOAD_PAGESIZE_COUNT) {
                [weakSelf.tableView.mj_footer setHidden:YES];
            }else{
                [weakSelf.tableView.mj_footer setHidden:NO];
                weakSelf.nextCursor ++;
            }
        }
        
        [weakSelf.attentionTableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
        [weakSelf.attentionTableView.mj_header endRefreshing];
        [weakSelf.attentionTableView.mj_footer endRefreshing];
    }];
}

- (void)followRequest:(LLFollowUserNode *)userNode {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"FollowUser"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:userNode.UserId forKey:@"userId"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
            }
        }
        userNode.IsMutualFollow = !userNode.IsMutualFollow;
        [weakSelf.attentionTableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

#pragma mark - SetGet
- (NSMutableArray *)dataLists {
    if (!_dataLists) {
        _dataLists = [NSMutableArray array];
    }
    return _dataLists;
}

- (LLSegmentedHeadView *)segmentedHeadView {
    if (!_segmentedHeadView) {
        _segmentedHeadView = [[LLSegmentedHeadView alloc] init];
        [_segmentedHeadView setItems:@[@{kllSegmentedTitle:@"消息提醒",kllSegmentedType:@(0)},@{kllSegmentedTitle:@"关注动态",kllSegmentedType:@(0)}]];
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 60;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (UITableView *)attentionTableView {
    if (!_attentionTableView) {
        _attentionTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _attentionTableView.backgroundColor = self.view.backgroundColor;
        _attentionTableView.delegate = self;
        _attentionTableView.dataSource = self;
        _attentionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _attentionTableView.estimatedRowHeight = 60;
        _attentionTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _attentionTableView;
}

#pragma mark -
#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.attentionTableView) {
        return 1;
    }
    return self.dataLists.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.attentionTableView) {
        return self.attentionLists.count;
    }
    NSArray *array = self.dataLists[section];
    return array.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewAutomaticDimension;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerIdentifier = @"UITableViewHeaderFooterView";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
        header.backgroundColor = kAppSectionBackgroundColor;
        header.contentView.backgroundColor = kAppSectionBackgroundColor;
        
        UIImageView *imgLine = [UIImageView new];
        imgLine.backgroundColor = LineColor;
        [header addSubview:imgLine];
        [imgLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(header);
            make.height.mas_equalTo(0.5);
        }];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *header = [UIView new];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.attentionTableView) {
        static NSString *cellIdentifier = @"LLAttentionTableViewCell";
        LLAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
            [cell.rightButton addTarget:self action:@selector(handleClickAt:event:) forControlEvents:UIControlEventTouchUpInside];
        }
        [cell updateCellWithData:self.attentionLists[indexPath.row]];
        return cell;
    }
    NSArray *array = self.dataLists[indexPath.section];
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"LLMessageWarnTableViewCell";
        LLMessageWarnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        NSDictionary *dic = array[indexPath.row];
        [cell updateCellWithData:dic];
        if (indexPath.row == 0) {
            [cell.badgeNumberView setBadge:self.mineMessageNode.CommentCount];
        } else if (indexPath.row == 1) {
            [cell.badgeNumberView setBadge:self.mineMessageNode.GoodCount];
        }
        return cell;
    } else {
        static NSString *cellIdentifier = @"LLMsgTickTableViewCell";
        LLMsgTickTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        [cell updateCellWithData:array[indexPath.row]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    if (tableView == self.attentionTableView) {
        return;
    }
    NSArray *array = self.dataLists[indexPath.section];
    if (indexPath.section == 0) {
        NSDictionary *dic = array[indexPath.row];
        NSString *action = dic[@"action"];
        if ([action isEqualToString:@"comment"]) {
            LLReceiveCommentViewController *vc = [[LLReceiveCommentViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        } else if ([action isEqualToString:@"favour"]) {
            LLReceiveFavourViewController *vc = [[LLReceiveFavourViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        } else if ([action isEqualToString:@"service"]) {
            
        }
    } else {
        
    }
}

-(void)handleClickAt:(id)sender event:(id)event{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath) {
        LLFollowUserNode *node = self.attentionLists[indexPath.row];
        [self followRequest:node];
    }
}

@end
