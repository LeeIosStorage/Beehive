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
#import "LLRedRuleViewController.h"
#import "LELoginAuthManager.h"
#import "LLPaymentWayView.h"
#import "LEAlertMarkView.h"
#import "WYPayManager.h"

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

@property (nonatomic, strong) UIButton *btnBid;

@property (nonatomic, strong) LLBeeAffirmBidView *beeAffirmBidView;

@property (nonatomic, strong) NSMutableArray *allAreaNameList;

@property (nonatomic, assign) NSInteger paymentWay;
@property (nonatomic, strong) NSString *bidPrice;

@property (assign, nonatomic) int nextCursor;

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
    
    [self createBarButtonItemAtPosition:LLNavigationBarPositionRight normalImage:[UIImage imageNamed:@"home_nav_help"] highlightImage:nil text:@"" action:@selector(ruleClickAction:)];
    
//    self.currentPage = 1;
    self.dataLists = [NSMutableArray array];
    
//    [self.view addSubview:self.segmentedHeadView];
//    [self.segmentedHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(self.view);
//        make.height.mas_equalTo(40);
//    }];
    
    [self.view addSubview:self.btnBid];
    [self.btnBid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    [self.view addSubview:self.pricingTableView];
    self.pricingTableView.hidden = true;
    [self.pricingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(0);
    }];
    
    [self.view addSubview:self.auctionTableView];
    [self.auctionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.btnBid.mas_top);
        make.top.equalTo(self.view).offset(0);
    }];
    
    self.auctionTableView.tableHeaderView = self.beeKingAuctionHeadView;
    [self.beeKingAuctionHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        //top布局一定要加上 不然origin.y可能为负值
        make.top.width.equalTo(self.auctionTableView);
    }];
    
    self.pricingTableView.tableHeaderView = self.pricingHeadView;
    
    [self.auctionTableView reloadData];
    
    if (self.currentPage == 0) {
        self.nextCursor = 1;
        [self addMJ];
    }
}

- (void)refreshData {
    if (self.currentPage == 0) {
        self.auctionTableView.hidden = false;
        self.pricingTableView.hidden = true;
        self.btnBid.hidden = false;
        
        LLBeeKingAuctionHeadView *headView = (LLBeeKingAuctionHeadView *)self.auctionTableView.tableHeaderView;
        [self.auctionTableView layoutIfNeeded];
        self.auctionTableView.tableHeaderView = headView;
        
        [self.auctionTableView reloadData];
    } else if (self.currentPage == 1) {
        
        self.auctionTableView.hidden = true;
        self.pricingTableView.hidden = false;
        self.btnBid.hidden = true;
        
        [self.pricingTableView reloadData];
    }
    
    [self refreshHeadViewUI];
}

- (void)refreshHeadViewUI {
    self.beeKingAuctionHeadView.labTitle.text = [NSString stringWithFormat:@"%@蜂王",self.beeKingNode.AreaName];
    
    NSString *price = [NSString stringWithFormat:@"%.0f",self.beeKingNode.StartPrice];
    NSString *priceText = [NSString stringWithFormat:@"¥ %@ (%d天)",price, self.beeKingNode.Days];
    self.beeKingAuctionHeadView.labPrice.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:priceText range:NSMakeRange(2, price.length) font:[FontConst PingFangSCRegularWithSize:20] color:kAppThemeColor];
    
    self.beeKingAuctionHeadView.labDate.text = [NSString stringWithFormat:@"竞价时间：%@~%@",[WYCommonUtils dateYearToDayDotDiscriptionFromDate:[WYCommonUtils dateFromUSDateString:self.beeKingNode.StartTime]], [WYCommonUtils dateYearToDayDotDiscriptionFromDate:[WYCommonUtils dateFromUSDateString:self.beeKingNode.EndTime]]];
    
    [self changeCity];
}

- (void)affirmPay {
    [SVProgressHUD showCustomSuccessWithStatus:@"支付成功"];
}

- (void)changeCity {
    if (self.areaNode.ProvinceName.length > 0 && self.areaNode.CityName.length > 0) {
        self.labCity.text = [NSString stringWithFormat:@"%@%@",self.areaNode.ProvinceName, self.areaNode.CityName];
    } else {
        self.labCity.text = @"";
    }
}

- (void)paymentWayViewShow {
    [self.view endEditing:true];
    LLPaymentWayView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"LLPaymentWayView" owner:self options:nil] firstObject];
    tipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 265);
    tipView.wayType = LLPaymentWayTypeVIP;
    [tipView updateCellWithData:nil];
    __weak UIView *weakView = tipView;
    WEAKSELF
    tipView.paymentBlock = ^(NSInteger type) {
        if ([weakView.superview isKindOfClass:[LEAlertMarkView class]]) {
            LEAlertMarkView *alert = (LEAlertMarkView *)weakView.superview;
            [alert dismiss];
        }
        weakSelf.paymentWay = type;
        if (weakSelf.currentPage == 0) {
            [weakSelf bidPriceQueenBee];
        } else if (weakSelf.currentPage == 1) {
            [weakSelf buyQueenBee];
        }
    };
    LEAlertMarkView *alert = [[LEAlertMarkView alloc] initWithCustomView:tipView type:LEAlertMarkViewTypeBottom];
    [alert show];
}

#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    WEAKSELF;
    self.auctionTableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        weakSelf.nextCursor = 1;
        [weakSelf getBidQueenList];
    }];
    [self.auctionTableView.mj_header beginRefreshing];
    
    //上啦加载
    self.auctionTableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getBidQueenList];
    }];
    self.auctionTableView.mj_footer.hidden = YES;
    
}

#pragma mark - Request
- (void)getQueenList {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetQueenList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.areaNode.ProvinceId forKey:@"provinceId"];
    [params setValue:self.areaNode.CityId forKey:@"cityId"];
    //    NSString *caCheKey = @"GetQueenList";
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLBeeKingNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            weakSelf.pricingDataLists = [NSMutableArray arrayWithArray:data];
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)buyQueenBee {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"BuyQueenBee"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.beeKingNode.Id forKey:@"id"];
    [params setValue:[NSNumber numberWithInteger:self.paymentWay] forKey:@"payType"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLBeeKingNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            weakSelf.pricingDataLists = [NSMutableArray arrayWithArray:data];
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)bidPriceQueenBee {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"BidPriceQueenBee"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.beeKingNode.Id forKey:@"id"];
    [params setValue:self.bidPrice forKey:@"money"];
    [params setValue:[NSNumber numberWithInteger:self.paymentWay] forKey:@"payType"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLBeeKingNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            weakSelf.pricingDataLists = [NSMutableArray arrayWithArray:data];
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)getBidQueenList {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetBidQueenList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"pageIndex"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"pageSize"];
    [params setObject:self.beeKingNode.CountyId forKey:@"id"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLUserInfoNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [weakSelf.auctionTableView.mj_header endRefreshing];
        [weakSelf.auctionTableView.mj_footer endRefreshing];
        
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
                [weakSelf.auctionTableView.mj_footer setHidden:YES];
            }else{
                [weakSelf.auctionTableView.mj_footer setHidden:NO];
                weakSelf.nextCursor ++;
            }
        }
        
        [weakSelf.auctionTableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
        [weakSelf.auctionTableView.mj_header endRefreshing];
        [weakSelf.auctionTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Action
- (IBAction)chooseCityAction:(id)sender {
    WEAKSELF
    [ZJUsefulPickerView showMultipleAssociatedColPickerWithToolBarText:@"切换城市" withDefaultValues:nil withData:self.allAreaNameList withCancelHandler:^{
        
    } withDoneHandler:^(NSArray *selectedValues) {
        NSString *provinceName = selectedValues[0];
        NSString *cityName = selectedValues[1];
//        NSString *countyName = selectedValues[2];
        NSString *provinceId = @"";
        NSString *cityId = @"";
//        NSString *countyId = @"";
        for (LLAreaNode *provinceNode in [LELoginAuthManager sharedInstance].allAreaList) {
            if ([provinceNode.FullName isEqualToString:provinceName]) {
                provinceId = provinceNode.Id;
                for (LLAreaNode *cityNode in provinceNode.Children) {
                    if ([cityNode.FullName isEqualToString:cityName]) {
                        cityId = cityNode.Id;
//                        for (LLAreaNode *areaNode in cityNode.Children) {
//                            if ([areaNode.FullName isEqualToString:countyName]) {
//                                countyId = areaNode.Id;
//                                break;
//                            }
//                        }
                    }
                }
            }
        }
        weakSelf.areaNode = [[LLHomeNode alloc] init];
        weakSelf.areaNode.ProvinceName = provinceName;
        weakSelf.areaNode.ProvinceId = provinceId;
        weakSelf.areaNode.CityName = cityName;
        weakSelf.areaNode.CityId = cityId;
//        weakSelf.areaNode.CountyName = countyName;
//        weakSelf.areaNode.CountyId = countyId;
        
        [weakSelf getQueenList];
    }];
}

- (void)bidAction:(id)sender {
    [self.beeAffirmBidView updateViewWithData:self
     .beeKingNode];
    LEAlertMarkView *alert = [[LEAlertMarkView alloc] initWithCustomView:self.beeAffirmBidView type:LEAlertMarkViewTypeBottom];
    [alert show];
}

- (void)ruleClickAction:(id)sender {
    LLRedRuleViewController *vc = [[LLRedRuleViewController alloc] init];
    vc.vcType = LLInfoDetailsVcTypeQueenBeeExplain;
    [self.navigationController pushViewController:vc animated:true];
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

- (NSMutableArray *)allAreaNameList {
    if (!_allAreaNameList) {
        _allAreaNameList = [NSMutableArray array];
        
        NSMutableArray *provinceArray = [NSMutableArray array];
        NSMutableDictionary *cityDic = [NSMutableDictionary dictionary];
//        NSMutableDictionary *areaDic = [NSMutableDictionary dictionary];
        for (LLAreaNode *provinceNode in [LELoginAuthManager sharedInstance].allAreaList) {
            NSMutableArray *cityArray = [NSMutableArray array];
            for (LLAreaNode *cityNode in provinceNode.Children) {
//                NSMutableArray *areaArray = [NSMutableArray array];
//                for (LLAreaNode *areaNode in cityNode.Children) {
//                    [areaArray addObject:areaNode.FullName];
//                }
                [cityArray addObject:cityNode.FullName];
//                [areaDic setObject:areaArray forKey:cityNode.FullName];
            }
            [provinceArray addObject:provinceNode.FullName];
            [cityDic setObject:cityArray forKey:provinceNode.FullName];
        }
        
        _allAreaNameList = [NSMutableArray arrayWithArray:@[provinceArray, cityDic]];
    }
    return _allAreaNameList;
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
            weakSelf.bidPrice = price;
            [weakSelf paymentWayViewShow];
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
            [cell.buyButton addTarget:self action:@selector(handleClickAt:event:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.indexPath = indexPath;
        [cell updateCellWithData:self.pricingDataLists[indexPath.row]];
        return cell;
    }
    static NSString *cellIdentifier = @"LLRedReceiveUserTableViewCell";
    LLRedReceiveUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    LLUserInfoNode *node = self.dataLists[indexPath.row];
    [cell updateCellWithData:node];
    
    cell.moneyLabel.textColor = kAppLightTitleColor;
    NSString *price = [NSString stringWithFormat:@"¥%.2f",node.Money];
    cell.moneyLabel.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:[NSString stringWithFormat:@"出价%@",price] range:NSMakeRange(2, price.length) font:cell.moneyLabel.font color:kAppThemeColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
}

-(void)handleClickAt:(id)sender event:(id)event{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.pricingTableView];
    NSIndexPath *indexPath = [self.pricingTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath) {
        self.beeKingNode = self.pricingDataLists[indexPath.row];
        if (self.beeKingNode.IsBiddingPrice == true) {
            LLBeeKingViewController *vc = [[LLBeeKingViewController alloc] init];
            vc.areaNode = self.areaNode;
            vc.beeKingNode = self.beeKingNode;
            vc.currentPage = 0;
            [self.navigationController pushViewController:vc animated:true];
        } else {
            [self paymentWayViewShow];
        }
    }
}

@end
