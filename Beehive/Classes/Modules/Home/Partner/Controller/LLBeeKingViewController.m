//
//  LLBeeKingViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeKingViewController.h"
#import "LLSegmentedHeadView.h"
#import "LLBeeKingAuctionHeadView.h"
#import "LLAuctionUserTableViewCell.h"
#import "LLPricingTableViewCell.h"
#import "LLRedReceiveUserTableViewCell.h"

@interface LLBeeKingViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) LLSegmentedHeadView *segmentedHeadView;

@property (nonatomic, strong) LLBeeKingAuctionHeadView *beeKingAuctionHeadView;
@property (nonatomic, strong) IBOutlet UIView *pricingHeadView;

@property (nonatomic, strong) UITableView *auctionTableView;//竞拍
@property (nonatomic, strong) UITableView *pricingTableView;//定价

@property (nonatomic, strong) NSMutableArray *dataLists;
@property (nonatomic, strong) NSMutableArray *pricingDataLists;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation LLBeeKingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"成为蜂王";
    self.pricingTableView.backgroundColor = self.view.backgroundColor;
    self.auctionTableView.backgroundColor = self.view.backgroundColor;
    
    self.currentPage = 0;
    self.dataLists = [NSMutableArray array];
    
    [self.view addSubview:self.segmentedHeadView];
    [self.segmentedHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.pricingTableView];
    self.pricingTableView.hidden = true;
    [self.pricingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segmentedHeadView.mas_bottom).offset(0);
    }];
    
    [self.view addSubview:self.auctionTableView];
    [self.auctionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segmentedHeadView.mas_bottom).offset(0);
    }];
    
    self.auctionTableView.tableHeaderView = self.beeKingAuctionHeadView;
    [self.beeKingAuctionHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        //top布局一定要加上 不然origin.y可能为负值
        make.top.width.equalTo(self.auctionTableView);
    }];
    
    self.pricingTableView.tableHeaderView = self.pricingHeadView;
    
    [self.auctionTableView reloadData];
}

- (void)refreshData {
    if (self.currentPage == 0) {
        self.auctionTableView.hidden = false;
        self.pricingTableView.hidden = true;
        self.dataLists = [NSMutableArray array];
        [self.dataLists addObject:@""];
        [self.dataLists addObject:@""];
        [self.dataLists addObject:@""];
        [self.dataLists addObject:@""];
        
        LLBeeKingAuctionHeadView *headView = (LLBeeKingAuctionHeadView *)self.auctionTableView.tableHeaderView;
        [self.auctionTableView layoutIfNeeded];
        self.auctionTableView.tableHeaderView = headView;
        
        [self.auctionTableView reloadData];
    } else if (self.currentPage == 1) {
        
        self.auctionTableView.hidden = true;
        self.pricingTableView.hidden = false;
        
        self.pricingDataLists = [NSMutableArray array];
        [self.pricingDataLists addObject:@""];
        [self.pricingDataLists addObject:@""];
        [self.pricingDataLists addObject:@""];
        [self.pricingDataLists addObject:@""];
        
        [self.pricingTableView reloadData];
    }
}

#pragma mark - SetGet
- (LLSegmentedHeadView *)segmentedHeadView {
    if (!_segmentedHeadView) {
        _segmentedHeadView = [[LLSegmentedHeadView alloc] init];
        [_segmentedHeadView setItems:@[@{kllSegmentedTitle:@"竞拍",kllSegmentedType:@(0)},@{kllSegmentedTitle:@"竞价",kllSegmentedType:@(0)}]];
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

- (LLBeeKingAuctionHeadView *)beeKingAuctionHeadView {
    if (!_beeKingAuctionHeadView) {
        _beeKingAuctionHeadView = [[[NSBundle mainBundle] loadNibNamed:@"LLBeeKingAuctionHeadView" owner:nil options:nil] firstObject];
    }
    return _beeKingAuctionHeadView;
}

- (UITableView *)auctionTableView {
    if (!_auctionTableView) {
        _auctionTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _auctionTableView.backgroundColor = self.view.backgroundColor;
        _auctionTableView.delegate = self;
        _auctionTableView.dataSource = self;
        _auctionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _auctionTableView.estimatedRowHeight = 57;
        _auctionTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _auctionTableView;
}

- (UITableView *)pricingTableView {
    if (!_pricingTableView) {
        _pricingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _pricingTableView.backgroundColor = self.view.backgroundColor;
        _pricingTableView.delegate = self;
        _pricingTableView.dataSource = self;
        _pricingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pricingTableView.estimatedRowHeight = 57;
        _pricingTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _pricingTableView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.pricingTableView == tableView) {
        return self.pricingDataLists.count;
    }
    return self.dataLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pricingTableView == tableView) {
        return 50;
    }
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pricingTableView == tableView) {
        static NSString *cellIdentifier = @"LLPricingTableViewCell";
        LLPricingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        cell.indexPath = indexPath;
        [cell updateCellWithData:nil];
        return cell;
    }
    static NSString *cellIdentifier = @"LLRedReceiveUserTableViewCell";
    LLRedReceiveUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
