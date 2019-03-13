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

@interface LLMessageViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) LLSegmentedHeadView *segmentedHeadView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *attentionTableView;

@property (nonatomic, strong) NSMutableArray *dataLists;
@property (nonatomic, strong) NSMutableArray *attentionLists;

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
    [_dataLists addObject:@[@{@"title":@"收到的评论", @"icon":@"1_1_0.1", @"action":@"comment"}, @{@"title":@"收到的赞", @"icon":@"1_1_0.2", @"action":@"favour"}, @{@"title":@"蜂巢客服", @"icon":@"1_1_0.3", @"action":@"service"}]];
    [self.tableView reloadData];
    
    [self refreshData];
}

- (void)refreshData {
    if (self.currentPage == 0) {
        self.tableView.hidden = false;
        self.attentionTableView.hidden = true;
        [self.dataLists addObject:@[@"",@""]];
        [self.tableView reloadData];
        return;
    }
    
    self.tableView.hidden = true;
    self.attentionTableView.hidden = false;
    
    self.attentionLists = [NSMutableArray array];
    [self.attentionLists addObject:@""];
    [self.attentionLists addObject:@""];
    [self.attentionLists addObject:@""];
    [self.attentionLists addObject:@""];
    
    [self.attentionTableView reloadData];
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
        }
        [cell updateCellWithData:nil];
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
        return cell;
    } else {
        static NSString *cellIdentifier = @"LLMsgTickTableViewCell";
        LLMsgTickTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        [cell updateCellWithData:nil];
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

@end
