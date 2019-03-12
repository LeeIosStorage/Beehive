//
//  LLMessageViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/8.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMessageViewController.h"
#import "LLSegmentedHeadView.h"

@interface LLMessageViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) LLSegmentedHeadView *segmentedHeadView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataLists;

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
}

- (void)refreshData {
    self.dataLists = [NSMutableArray array];
    [self.dataLists addObject:@""];
    [self.dataLists addObject:@""];
    [self.dataLists addObject:@""];
    [self.dataLists addObject:@""];
    
    [self.tableView reloadData];
}

#pragma mark - SetGet
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = self.view.backgroundColor;
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 57;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

@end
