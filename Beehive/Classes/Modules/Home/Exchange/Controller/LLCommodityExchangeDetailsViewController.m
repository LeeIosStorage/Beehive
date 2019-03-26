//
//  LLCommodityExchangeDetailsViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/13.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLCommodityExchangeDetailsViewController.h"
#import "LLExchangeDetailsHeaderView.h"
#import "LLExchangeDetailsBottomView.h"
#import "LEMenuView.h"
#import "LLReportViewController.h"
#import "LEShareSheetView.h"
#import "LLCommodityExchangeconfirmView.h"
#import "LEAlertMarkView.h"
#import "LLCommodityPurchaseSucceedView.h"

@interface LLCommodityExchangeDetailsViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
LEShareSheetViewDelegate
>
{
    LEShareSheetView *_shareSheetView;
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) LLExchangeDetailsHeaderView *exchangeDetailsHeaderView;

@property (nonatomic, strong) LLExchangeDetailsBottomView *exchangeDetailsBottomView;

@property (nonatomic, strong) LLCommodityExchangeconfirmView *commodityExchangeconfirmView;

@end

@implementation LLCommodityExchangeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
}

- (void)setup {
    self.title = @"商品兑换详情";
    [self createBarButtonItemAtPosition:LLNavigationBarPositionRight normalImage:[UIImage imageNamed:@"message_details_more"] highlightImage:[UIImage imageNamed:@"message_details_more"] text:@"" action:@selector(moreAction:)];
    
    self.tableView.backgroundColor = kAppSectionBackgroundColor;
    
    self.tableView.tableHeaderView = self.exchangeDetailsHeaderView;
    [self.exchangeDetailsHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        //top布局一定要加上 不然origin.y可能为负值
        make.top.width.equalTo(self.tableView);
    }];
    [self.tableView reloadData];
    
    [self.view addSubview:self.exchangeDetailsBottomView];
    [self.exchangeDetailsBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    WEAKSELF
    self.exchangeDetailsBottomView.clickBlock = ^(NSInteger index) {
        if (index == 0) {
            [weakSelf shareAction];
        } else if (index == 1) {
            [weakSelf collectAction];
        } else if (index == 2) {
            [weakSelf exchangeAction];
        }
    };
}

- (void)refreshData {
    
    [self.exchangeDetailsHeaderView updateCellWithData:nil];
    
    LLExchangeDetailsHeaderView *headView = (LLExchangeDetailsHeaderView *)self.tableView.tableHeaderView;
    [self.tableView layoutIfNeeded];
    self.tableView.tableHeaderView = headView;
    
    [self.tableView reloadData];
}

#pragma mark - Action
- (void)moreAction:(id)sender {
    LEMenuView *menuView = [[LEMenuView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, HitoTopHeight, 80, 67)];
    [menuView show];
    
    WEAKSELF
    menuView.menuViewClickBlock = ^(NSInteger index) {
        if (index == 0) {
            LLReportViewController *vc = [[LLReportViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:true];
        }
    };
}

- (void)shareAction {
    
    LEShareModel *shareModel = [[LEShareModel alloc] init];
    shareModel.shareTitle = @"超值商品兑换";
    shareModel.shareDescription = @"";
    shareModel.shareWebpageUrl = [NSString stringWithFormat:@"%@/%@",[WYAPIGenerate sharedInstance].baseURL, kLLH5_DownLoad_Html_Url];
//    shareModel.shareImage = [];
    _shareSheetView = [[LEShareSheetView alloc] init];
    _shareSheetView.owner = self;
    _shareSheetView.shareModel = shareModel;
    [_shareSheetView showShareAction];
}

- (void)collectAction {
    
}

- (void)exchangeAction {
    [self.commodityExchangeconfirmView updateCellWithData:nil];
    WEAKSELF
    self.commodityExchangeconfirmView.submitBlock = ^{
        if ([weakSelf.commodityExchangeconfirmView.superview isKindOfClass:[LEAlertMarkView class]]) {
            LEAlertMarkView *alert = (LEAlertMarkView *)weakSelf.commodityExchangeconfirmView.superview;
            [alert dismiss];
        }
        [weakSelf exchangeSucceedView];
    };
    
    LEAlertMarkView *alert = [[LEAlertMarkView alloc] initWithCustomView:self.commodityExchangeconfirmView type:LEAlertMarkViewTypeBottom];
    [alert show];
}

- (void)exchangeSucceedView {
    LLCommodityPurchaseSucceedView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"LLCommodityPurchaseSucceedView" owner:self options:nil] firstObject];
    tipView.frame = CGRectMake(0, 0, 248, 288);
    __weak UIView *weakView = tipView;
    WEAKSELF
    tipView.clickBlock = ^(NSInteger index) {
        if ([weakView.superview isKindOfClass:[LEAlertMarkView class]]) {
            LEAlertMarkView *alert = (LEAlertMarkView *)weakView.superview;
            [alert dismiss];
        }
        if (index == 1) {
            LELog(@"查看订单");
        }
    };
    LEAlertMarkView *alert = [[LEAlertMarkView alloc] initWithCustomView:tipView type:LEAlertMarkViewTypeCenter];
    [alert show];
}

#pragma mark - set
- (LLExchangeDetailsHeaderView *)exchangeDetailsHeaderView {
    if (!_exchangeDetailsHeaderView) {
        _exchangeDetailsHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LLExchangeDetailsHeaderView" owner:self options:nil] firstObject];
    }
    return _exchangeDetailsHeaderView;
}

- (LLExchangeDetailsBottomView *)exchangeDetailsBottomView {
    if (!_exchangeDetailsBottomView) {
        _exchangeDetailsBottomView = [[[NSBundle mainBundle] loadNibNamed:@"LLExchangeDetailsBottomView" owner:self options:nil] firstObject];
    }
    return _exchangeDetailsBottomView;
}

- (LLCommodityExchangeconfirmView *)commodityExchangeconfirmView {
    if (!_commodityExchangeconfirmView) {
        _commodityExchangeconfirmView = [[[NSBundle mainBundle] loadNibNamed:@"LLCommodityExchangeconfirmView" owner:self options:nil] firstObject];
        _commodityExchangeconfirmView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 342);
    }
    return _commodityExchangeconfirmView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    static NSString *cellIdentifier = @"";
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    //    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self.view endEditing:YES];
    }
}

@end
