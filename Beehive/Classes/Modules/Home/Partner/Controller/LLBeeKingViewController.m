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
#import "LLBeeAffirmBidView.h"
#import "LEAlertMarkView.h"
#import "ZJUsefulPickerView.h"

@interface LLBeeKingViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) LLSegmentedHeadView *segmentedHeadView;

@property (nonatomic, strong) LLBeeKingAuctionHeadView *beeKingAuctionHeadView;
@property (nonatomic, weak) IBOutlet UIView *pricingHeadView;
@property (nonatomic, weak) IBOutlet UILabel *labCity;

@property (nonatomic, strong) UITableView *auctionTableView;//竞拍
@property (nonatomic, strong) UITableView *pricingTableView;//定价

@property (nonatomic, strong) NSMutableArray *dataLists;
@property (nonatomic, strong) NSMutableArray *pricingDataLists;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UIButton *btnBid;

@property (nonatomic, strong) LLBeeAffirmBidView *beeAffirmBidView;

@end

@implementation LLBeeKingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
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
    
    [self.view addSubview:self.btnBid];
    [self.btnBid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    [self.view addSubview:self.pricingTableView];
    self.pricingTableView.hidden = true;
    [self.pricingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segmentedHeadView.mas_bottom).offset(0);
    }];
    
    [self.view addSubview:self.auctionTableView];
    [self.auctionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.btnBid.mas_top);
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
        self.btnBid.hidden = false;
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
        self.btnBid.hidden = true;
        
        self.pricingDataLists = [NSMutableArray array];
        [self.pricingDataLists addObject:@""];
        [self.pricingDataLists addObject:@""];
        [self.pricingDataLists addObject:@""];
        [self.pricingDataLists addObject:@""];
        
        [self.pricingTableView reloadData];
    }
    
    [self refreshHeadViewUI];
}

- (void)refreshHeadViewUI {
    self.beeKingAuctionHeadView.labTitle.text = @"中原区蜂王";
    
    NSString *price = @"100";
    NSString *priceText = [NSString stringWithFormat:@"¥ %@ (10天)",price];
    self.beeKingAuctionHeadView.labPrice.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:priceText range:NSMakeRange(2, price.length) font:[FontConst PingFangSCRegularWithSize:20] color:kAppThemeColor];
}

- (void)affirmPay {
    [SVProgressHUD showCustomSuccessWithStatus:@"支付成功"];
}

- (void)changeCity:(NSString *)city {
    self.labCity.text = city;
}

- (IBAction)chooseCityAction:(id)sender {
    WEAKSELF
    NSString *provincePath = [[NSBundle mainBundle] pathForResource:@"Province" ofType:@"plist"];
    NSString *cityPath = [[NSBundle mainBundle] pathForResource:@"City" ofType:@"plist"];
    NSArray *provinceArray = [NSArray arrayWithContentsOfFile:provincePath];
    NSDictionary *cityDic = [NSDictionary dictionaryWithContentsOfFile:cityPath];
    
    NSArray *dataArray = @[provinceArray, cityDic];
    [ZJUsefulPickerView showMultipleAssociatedColPickerWithToolBarText:@"切换城市" withDefaultValues:nil withData:dataArray withCancelHandler:^{
        
    } withDoneHandler:^(NSArray *selectedValues) {
        NSString *cityName = [NSString stringWithFormat:@"%@%@",selectedValues[0],selectedValues[1]];
        [weakSelf changeCity:cityName];
    }];
}

- (void)bidAction:(id)sender {
    [self.beeAffirmBidView updateViewWithData:nil];
    LEAlertMarkView *alert = [[LEAlertMarkView alloc] initWithCustomView:self.beeAffirmBidView type:LEAlertMarkViewTypeBottom];
    [alert show];
}

#pragma mark - SetGet
- (LLSegmentedHeadView *)segmentedHeadView {
    if (!_segmentedHeadView) {
        _segmentedHeadView = [[LLSegmentedHeadView alloc] init];
        [_segmentedHeadView setItems:@[@{kllSegmentedTitle:@"竞拍",kllSegmentedType:@(0)},@{kllSegmentedTitle:@"定价",kllSegmentedType:@(0)}]];
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

- (UIButton *)btnBid {
    if (!_btnBid) {
        _btnBid = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnBid.backgroundColor = kAppThemeColor;
        [_btnBid setTitle:@"开始出价" forState:UIControlStateNormal];
        [_btnBid.titleLabel setFont:[FontConst PingFangSCRegularWithSize:13]];
        [_btnBid setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_btnBid addTarget:self action:@selector(bidAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBid;
}

- (LLBeeAffirmBidView *)beeAffirmBidView {
    if (!_beeAffirmBidView) {
        _beeAffirmBidView = [[[NSBundle mainBundle] loadNibNamed:@"LLBeeAffirmBidView" owner:self options:nil] firstObject];
        _beeAffirmBidView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 280);
        __weak UIView *weakView = _beeAffirmBidView;
        WEAKSELF
        _beeAffirmBidView.payBlock = ^(NSString * _Nonnull price) {
            if ([weakView.superview isKindOfClass:[LEAlertMarkView class]]) {
                LEAlertMarkView *alert = (LEAlertMarkView *)weakView.superview;
                [alert dismiss];
            }
            [weakSelf affirmPay];
        };
    }
    return _beeAffirmBidView;
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
