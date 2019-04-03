//
//  LLPublishHistoryListViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPublishHistoryListViewController.h"
#import "LLMineCollectTableViewCell.h"
#import "LLCommodityExchangeTableViewCell.h"
#import "LLRedpacketDetailsViewController.h"
#import "LLCommodityExchangeDetailsViewController.h"
#import "LLMessageDetailsViewController.h"
#import "LLPublishHistoryTimeNode.h"

@interface LLPublishHistoryListViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataLists;

@property (assign, nonatomic) int nextCursor;

@end

@implementation LLPublishHistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
}

- (void)setup {
    self.title = @"红包任务";
    if (self.publishVcType == LLPublishViewcTypeExchange) {
        self.title = @"兑换商品";
    } else if (self.publishVcType == LLPublishViewcTypeAsk) {
        self.title = @"提问红包";
    } else if (self.publishVcType == LLPublishViewcTypeConvenience) {
        self.title = @"便民信息";
    }
    self.view.backgroundColor = kAppSectionBackgroundColor;
    
    self.dataLists = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [self.tableView reloadData];
    
    self.nextCursor = 1;
    [self addMJ];
}

- (void)refreshData {
    if (self.publishVcType == LLPublishViewcTypeExchange) {
        [self getExchangeList];
    } else if (self.publishVcType == LLPublishViewcTypeAsk) {
        [self getAskRedList];
    } else if (self.publishVcType == LLPublishViewcTypeConvenience) {
        [self getFacilitateList];
    } else {
        [self getRedTaskList];
    }
}

#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    WEAKSELF;
    self.tableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        weakSelf.nextCursor = 1;
        [weakSelf refreshData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //上啦加载
    self.tableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

#pragma mark - Request
- (void)getExchangeList {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetGoodHistoryList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"pageIndex"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"pageSize"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLPublishHistoryTimeNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
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

- (void)getAskRedList {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetAskRedList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"pageIndex"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"pageSize"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLPublishHistoryTimeNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
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

- (void)getRedTaskList {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetRedTaskList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"pageIndex"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"pageSize"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLPublishHistoryTimeNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
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
//                [weakSelf.tableView.mj_footer setHidden:NO];
//                weakSelf.nextCursor ++;
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

- (void)getFacilitateList {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetFacilitateList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"pageIndex"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"pageSize"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLPublishHistoryTimeNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
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
//                [weakSelf.tableView.mj_footer setHidden:NO];
//                weakSelf.nextCursor ++;
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
        _tableView.estimatedRowHeight = 80;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataLists.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LLPublishHistoryTimeNode *node = self.dataLists[section];
    if (self.publishVcType == LLPublishViewcTypeConvenience) {
        return node.FacList.count;
    } else if (self.publishVcType == LLPublishViewcTypeRedpacket || self.publishVcType == LLPublishViewcTypeAsk) {
        return node.RedList.count;
    } else if (self.publishVcType == LLPublishViewcTypeExchange) {
        return node.GoodList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *headerIdentifier = @"UITableViewHeaderFooterView";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
        header.backgroundColor = self.view.backgroundColor;
        header.contentView.backgroundColor = self.view.backgroundColor;
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kAppSubTitleColor;
        label.font = [FontConst PingFangSCRegularWithSize:11];
        label.textAlignment = NSTextAlignmentLeft;
        label.tag = 201;
        [header addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header).offset(10);
            make.right.equalTo(header).offset(-10);
            make.top.bottom.equalTo(header);
        }];
        
        UIImageView *imgLine = [UIImageView new];
        imgLine.backgroundColor = LineColor;
        [header addSubview:imgLine];
        [imgLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(header);
            make.height.mas_equalTo(0.5);
        }];
    }
    UILabel *label = (UILabel *)[header viewWithTag:201];
    LLPublishHistoryTimeNode *node = self.dataLists[section];
    if (self.publishVcType == LLPublishViewcTypeConvenience) {
        label.text = node.TimeName;
    } else {
        label.text = node.YearName;
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.publishVcType == LLPublishViewcTypeExchange) {
        return UITableViewAutomaticDimension;
    }
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.publishVcType == LLPublishViewcTypeExchange) {
        static NSString *cellIdentifier = @"LLCommodityExchangeTableViewCell";
        LLCommodityExchangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        LLPublishHistoryTimeNode *node = self.dataLists[indexPath.section];
        [cell updateCellWithData:node.GoodList[indexPath.row]];
        return cell;
    }
    static NSString *cellIdentifier = @"LLMineCollectTableViewCell";
    LLMineCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    cell.indexPath = indexPath;
    LLPublishHistoryTimeNode *node = self.dataLists[indexPath.section];
    id cellNode;
    if (self.publishVcType == LLPublishViewcTypeConvenience) {
        cellNode = node.FacList[indexPath.row];
    } else if (self.publishVcType == LLPublishViewcTypeRedpacket || self.publishVcType == LLPublishViewcTypeAsk) {
        cellNode = node.RedList[indexPath.row];
    }
    [cell updateCellWithData:cellNode];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    LLPublishHistoryTimeNode *node = self.dataLists[indexPath.section];
    
    if (self.publishVcType == LLPublishViewcTypeRedpacket) {
        LLRedpacketNode *cellNode = node.RedList[indexPath.row];
        LLRedpacketDetailsViewController *vc = [[LLRedpacketDetailsViewController alloc] init];
        vc.redpacketNode = cellNode;
        vc.vcType = 1;
        [self.navigationController pushViewController:vc animated:true];
    } else if (self.publishVcType == LLPublishViewcTypeExchange) {
        LLCommodityExchangeDetailsViewController *vc = [[LLCommodityExchangeDetailsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    } else if (self.publishVcType == LLPublishViewcTypeAsk) {
        LLRedpacketNode *cellNode = node.RedList[indexPath.row];
        LLRedpacketDetailsViewController *vc = [[LLRedpacketDetailsViewController alloc] init];
        vc.vcType = 0;
        vc.redpacketNode = cellNode;
        [self.navigationController pushViewController:vc animated:true];
    } else if (self.publishVcType == LLPublishViewcTypeConvenience) {
        LLMessageListNode *cellNode = node.FacList[indexPath.row];
        LLMessageDetailsViewController *vc = [[LLMessageDetailsViewController alloc] init];
        vc.messageListNode = cellNode;
        [self.navigationController pushViewController:vc animated:true];
    }
}

@end
