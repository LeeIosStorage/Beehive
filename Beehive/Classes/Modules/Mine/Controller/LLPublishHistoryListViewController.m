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

@interface LLPublishHistoryListViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataLists;

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
}

- (void)refreshData {
    self.dataLists = [NSMutableArray array];
    [self.dataLists addObject:@[@""]];
    [self.dataLists addObject:@[@"",@"",@"",@""]];
    [self.dataLists addObject:@[@""]];
    
    [self.tableView reloadData];
}

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
    NSArray *array = self.dataLists[section];
    return array.count;
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
    label.text = @"2019.1.20";
    
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
        [cell updateCellWithData:nil];
        return cell;
    }
    static NSString *cellIdentifier = @"LLMineCollectTableViewCell";
    LLMineCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    cell.indexPath = indexPath;
    [cell updateCellWithData:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    NSArray *array = self.dataLists[indexPath.section];
    
    if (self.publishVcType == LLPublishViewcTypeRedpacket) {
        LLRedpacketDetailsViewController *vc = [[LLRedpacketDetailsViewController alloc] init];
        vc.vcType = 1;
        [self.navigationController pushViewController:vc animated:true];
    } else if (self.publishVcType == LLPublishViewcTypeExchange) {
        LLCommodityExchangeDetailsViewController *vc = [[LLCommodityExchangeDetailsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    } else if (self.publishVcType == LLPublishViewcTypeAsk) {
        LLRedpacketDetailsViewController *vc = [[LLRedpacketDetailsViewController alloc] init];
        vc.vcType = 0;
        [self.navigationController pushViewController:vc animated:true];
    } else if (self.publishVcType == LLPublishViewcTypeConvenience) {
        LLMessageDetailsViewController *vc = [[LLMessageDetailsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    }
}

@end
