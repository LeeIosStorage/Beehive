//
//  LLBeeLobbyViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeLobbyViewController.h"
#import "LLBeeLobbyHeaderView.h"
#import "LLBeeLobbyTableViewCell.h"
#import "LLBeeKingViewController.h"
#import "LEWebViewController.h"
#import "LLBeeWelfareViewController.h"
#import "LLAdsBidViewController.h"
#import "LLQueenBeeInfoNode.h"

@interface LLBeeLobbyViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSMutableArray *dataLists;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) LLQueenBeeInfoNode *queenBeeInfoNode;
@property (nonatomic, strong) LLBeeLobbyHeaderView *beeLobbyHeaderView;

@end

@implementation LLBeeLobbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
    [self getQueenBeeInfo];
}

- (void)setup {
    self.title = @"蜂王大厅";
    self.tableView.backgroundColor = kAppBackgroundColor;
    
    self.dataLists = [NSMutableArray array];
    
    CGFloat height = 235 + 10*2;
    height += (7/30.0)*(SCREEN_WIDTH-10*2);
    height += (14/29.0)*((SCREEN_WIDTH-10*3)/2);
    self.beeLobbyHeaderView.height = height;
    self.tableView.tableHeaderView = self.beeLobbyHeaderView;
//    [self.beeLobbyHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        //top布局一定要加上 不然origin.y可能为负值
//        make.top.width.equalTo(self.tableView);
//    }];
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView reloadData];
    
    WEAKSELF
    self.beeLobbyHeaderView.beeKingBlock = ^{
        LLBeeKingViewController *vc = [[LLBeeKingViewController alloc] init];
        vc.currentPage = 1;
        [weakSelf.navigationController pushViewController:vc animated:true];
    };
    self.beeLobbyHeaderView.handleBlock = ^(NSInteger index) {
        if (index == 0) {
            [weakSelf adsBidVc];
        } else if (index == 1) {
            [weakSelf beeWelfareVc];
        } else if (index == 2) {
            
        }
    };
}

- (void)refreshData {
    
    [self.beeLobbyHeaderView updateHeadViewWithData:self.queenBeeInfoNode];
    
//    LLBeeLobbyHeaderView *headView = (LLBeeLobbyHeaderView *)self.tableView.tableHeaderView;
//    [self.tableView layoutIfNeeded];
//    self.tableView.tableHeaderView = headView;
    
    self.dataLists = [NSMutableArray arrayWithArray:self.queenBeeInfoNode.AdvertList];
    
    [self.tableView reloadData];
}

- (void)adsBidVc {
    LLAdsBidViewController *vc = [[LLAdsBidViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)beeWelfareVc {
    LLBeeWelfareViewController *vc = [[LLBeeWelfareViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)getQueenBeeInfo {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetQueenBeeInfo"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *caCheKey = @"GetQueenBeeInfo";
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:[LLQueenBeeInfoNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                weakSelf.queenBeeInfoNode = data[0];
            }
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

#pragma mark - setget
- (LLBeeLobbyHeaderView *)beeLobbyHeaderView {
    if (!_beeLobbyHeaderView) {
        _beeLobbyHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LLBeeLobbyHeaderView" owner:nil options:nil] firstObject];
    }
    return _beeLobbyHeaderView;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LLBeeLobbyTableViewCell";
    LLBeeLobbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    [cell updateCellWithData:self.dataLists[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
//    LEWebViewController *vc = [[LEWebViewController alloc] initWithURLString:@"http://www.baidu.com"];
//    [self.navigationController pushViewController:vc animated:true];
}

@end
