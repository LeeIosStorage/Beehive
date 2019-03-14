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

@interface LLRedTaskHistoryViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) LLSegmentedHeadView *segmentedHeadView;

@property (nonatomic, strong) LLRedTaskHistoryHeaderView *redTaskHistoryHeaderView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataLists;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation LLRedTaskHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
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
}

- (void)refreshData {
    self.dataLists = [NSMutableArray array];
    [self.dataLists addObject:@""];
    [self.dataLists addObject:@""];
    [self.dataLists addObject:@""];
    [self.dataLists addObject:@""];
    
    [self refreshHeaderViewUI];
    [self.tableView reloadData];
}

- (void)refreshHeaderViewUI {
    if (self.currentPage == 0) {
        self.redTaskHistoryHeaderView.labTotalAmount.text = @"12.08";
        self.redTaskHistoryHeaderView.labTotalType.text = @"元";
        self.redTaskHistoryHeaderView.labTotalTip.text = @"抢到的总金额";
        self.redTaskHistoryHeaderView.labDayAmount.text = @"1.08";
        self.redTaskHistoryHeaderView.labDayType.text = @"元";
        self.redTaskHistoryHeaderView.labDayTip.text = @"当日抢金额";
    } else {
        self.redTaskHistoryHeaderView.labTotalAmount.text = @"12.08";
        self.redTaskHistoryHeaderView.labTotalType.text = @"元";
        self.redTaskHistoryHeaderView.labTotalTip.text = @"发布总金额";
        self.redTaskHistoryHeaderView.labDayAmount.text = @"99";
        self.redTaskHistoryHeaderView.labDayType.text = @"人";
        self.redTaskHistoryHeaderView.labDayTip.text = @"累计影响人数";
    }
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
    [cell updateCellWithData:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
}

@end
