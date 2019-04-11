//
//  LLAdsBidDetailsViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/9.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLAdsBidDetailsViewController.h"
#import "LLBeeAffirmBidView.h"
#import "LLRedReceiveUserTableViewCell.h"
#import "LLUserInfoNode.h"
#import "LLHomeNode.h"
#import "LEAlertMarkView.h"
#import "LELoginAuthManager.h"
#import "LLPaymentWayView.h"
#import "WYPayManager.h"
#import "WXApiManager.h"
#import "WXSendPayOrder.h"
#import "LLPublishIDCardViewCell.h"
#import "LLPublishCellNode.h"
#import "LLPublishInputViewCell.h"
#import "LLAreaChooseView.h"
#import "LLBuyAdViewController.h"
#import "ZJPayPopupView.h"
#import "LLPayPasswordResetViewController.h"

@interface LLAdsBidDetailsViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
WXApiManagerDelegate,
ZJPayPopupViewDelegate
>

@property (nonatomic, strong) ZJPayPopupView *payPopupView;

@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UILabel *labCity;
@property (nonatomic, weak) IBOutlet UILabel *labPrice;
@property (nonatomic, weak) IBOutlet UILabel *labDate;
@property (nonatomic, weak) IBOutlet UIView *imageUploadView;
@property (nonatomic, weak) IBOutlet UIView *bidRecordSectionView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bidRecordSectionViewConstraintH;

@property (nonatomic, strong) LLPublishIDCardViewCell *publishImageViewCell;
@property (nonatomic, strong) LLPublishCellNode *publishImageNode;

@property (nonatomic, strong) LLPublishInputViewCell *publishInputViewCell;
@property (nonatomic, strong) LLPublishCellNode *publishUrlAddressNode;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataLists;
@property (nonatomic, assign) int nextCursor;

@property (nonatomic, strong) UIButton *btnBid;

@property (nonatomic, strong) LLBeeAffirmBidView *beeAffirmBidView;

@property (nonatomic, strong) LLAreaChooseView *areaChooseView;

@property (nonatomic, assign) NSInteger paymentWay;
@property (nonatomic, strong) NSString *bidPrice;

@property (nonatomic, strong) LLHomeNode *areaNode;

@property (nonatomic, assign) int buyDays;

@end

@implementation LLAdsBidDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshHeadViewUI];
}

- (void)setup {
    self.title = @"广告位购买";
    
    self.areaNode = [[LLHomeNode alloc] init];
    self.areaNode.ProvinceName = @"全国";
    self.areaNode.CityName = @"";
    self.areaNode.CountyName = @"";
    self.areaNode.ProvinceId = @"0";
    self.areaNode.CityId = @"0";
    self.areaNode.CountyId = @"0";
    
    self.dataLists = [NSMutableArray array];
    
    [self.view addSubview:self.btnBid];
    [self.btnBid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.btnBid.mas_top);
        make.top.equalTo(self.view).offset(0);
    }];
    
    self.publishImageViewCell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 95);
    [self.imageUploadView addSubview:self.publishImageViewCell];
//    [self.publishImageViewCell mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.equalTo(self.imageUploadView);
//    }];
    self.publishImageNode = [[LLPublishCellNode alloc] init];
    self.publishImageNode.cellType = LLPublishCellTypeADImage;
    self.publishImageNode.title = @"上传照片";
    self.publishImageNode.uploadImageDatas = [NSMutableArray array];
    [self.publishImageViewCell updateCellWithData:self.publishImageNode];
    
    self.publishInputViewCell.frame = CGRectMake(0, 105, SCREEN_WIDTH, 120);
    [self.imageUploadView addSubview:self.publishInputViewCell];
    self.publishUrlAddressNode = [[LLPublishCellNode alloc] init];
    self.publishUrlAddressNode.cellType = LLPublishCellTypeLinkAddress;
    self.publishUrlAddressNode.title = @"链接地址";
    self.publishUrlAddressNode.placeholder = @"输入链接地址...";
    [self.publishInputViewCell updateCellWithData:self.publishUrlAddressNode];
    
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        //top布局一定要加上 不然origin.y可能为负值
        make.top.width.equalTo(self.tableView);
    }];
    [self.tableView reloadData];
    
    self.nextCursor = 1;
    [self addMJ];
}

- (void)refreshHeadViewUI {
    
    NSString *price = [NSString stringWithFormat:@"%.2f",self.bidAdvertNode.Money];
    NSString *priceText = [NSString stringWithFormat:@"¥ %@ (%d天)",price, self.bidAdvertNode.Days];
    self.labPrice.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:priceText range:NSMakeRange(2, price.length) font:[FontConst PingFangSCRegularWithSize:20] color:kAppThemeColor];
    
    self.labDate.text = [NSString stringWithFormat:@"竞价时间：%@~%@",[WYCommonUtils dateYearToDayDotDiscriptionFromDate:[WYCommonUtils dateFromUSDateString:self.bidAdvertNode.StartTime]], [WYCommonUtils dateYearToDayDotDiscriptionFromDate:[WYCommonUtils dateFromUSDateString:self.bidAdvertNode.EndTime]]];
    self.labDate.hidden = true;
    self.bidRecordSectionViewConstraintH.constant = 0;
    self.bidRecordSectionView.hidden = true;
    [self.btnBid setTitle:@"立即支付" forState:UIControlStateNormal];
    if (self.bidAdvertNode.IsBidPrice) {
        self.labDate.hidden = false;
        self.bidRecordSectionViewConstraintH.constant = 40;
        self.bidRecordSectionView.hidden = false;
        [self.btnBid setTitle:@"立即出价" forState:UIControlStateNormal];
    }
    
    [self changeCity];
    
    UIView *headView = self.tableView.tableHeaderView;
    [self.tableView layoutIfNeeded];
    self.tableView.tableHeaderView = headView;
    
    [self.tableView reloadData];
}

- (void)changeCity {
    self.labCity.text = [NSString stringWithFormat:@"%@%@%@",self.areaNode.ProvinceName, self.areaNode.CityName, self.areaNode.CountyName];
}

- (void)paymentWayViewShow {
    [self.view endEditing:true];
    LLPaymentWayView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"LLPaymentWayView" owner:self options:nil] firstObject];
    tipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 265);
//    tipView.wayType = LLPaymentWayTypeVIP;
    [tipView updateCellWithData:self.bidPrice];
    __weak UIView *weakView = tipView;
    WEAKSELF
    tipView.paymentBlock = ^(NSInteger type) {
        if ([weakView.superview isKindOfClass:[LEAlertMarkView class]]) {
            LEAlertMarkView *alert = (LEAlertMarkView *)weakView.superview;
            [alert dismiss];
        }
        weakSelf.paymentWay = type;
        if (type == 0) {
            [weakSelf payPopupViewShow];
        } else {
            [weakSelf addAdvertInfoWithPassword:nil];
        }
    };
    LEAlertMarkView *alert = [[LEAlertMarkView alloc] initWithCustomView:tipView type:LEAlertMarkViewTypeBottom];
    [alert show];
}

- (void)payPopupViewShow {
    self.payPopupView = [[ZJPayPopupView alloc] init];
    self.payPopupView.delegate = self;
    [self.payPopupView showPayPopView];
}

#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    WEAKSELF;
    self.tableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        weakSelf.nextCursor = 1;
        [weakSelf getBidAdvertRecord];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //上啦加载
    self.tableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getBidAdvertRecord];
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

#pragma mark - Request
- (void)getBidAdvertRecord {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetBidAdvertRecord"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"pageIndex"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"pageSize"];
    [params setObject:self.bidAdvertNode.Id forKey:@"id"];
    [params setObject:self.areaNode.ProvinceId forKey:@"provinceId"];
    [params setObject:self.areaNode.CityId forKey:@"cityId"];
    [params setObject:self.areaNode.CountyId forKey:@"countyId"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLBidAdvertNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        NSArray *tmpListArray = [NSArray array];
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                weakSelf.bidAdvertNode = data[0];
                tmpListArray = weakSelf.bidAdvertNode.BidPriceList;
            }
            
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

- (void)addAdvertInfoWithPassword:(NSString *)password {
    NSArray *uploadImages = self.publishImageNode.uploadImageDatas;
    if (uploadImages.count == 0) {
        [SVProgressHUD showCustomInfoWithStatus:@"请上传图片"];
        return;
    }
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"AddAdvertInfo"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.bidAdvertNode.Id forKey:@"advertId"];
    [params setObject:self.areaNode.ProvinceId forKey:@"provinceId"];
    [params setObject:self.areaNode.CityId forKey:@"cityId"];
    [params setObject:self.areaNode.CountyId forKey:@"countyId"];
    [params setValue:self.bidPrice forKey:@"money"];
    [params setValue:[NSNumber numberWithInteger:self.paymentWay] forKey:@"payType"];
    [params setObject:[NSNumber numberWithInt:self.buyDays] forKey:@"days"];
    if (password.length == 0) password = @"";
    [params setValue:password forKey:@"payPwd"];
    NSString *linkAddress = self.publishUrlAddressNode.inputText;
    if (linkAddress.length == 0) linkAddress = @"";
    [params setValue:linkAddress forKey:@"urlAddress"];
    
    NSMutableArray *imageDatas = [NSMutableArray array];
    
    for (UIImage *image in uploadImages) {
        NSData *imageData = UIImageJPEGRepresentation(image, WY_IMAGE_COMPRESSION_QUALITY);
        NSString *dataStr = [imageData base64EncodedStringWithOptions:0];
        [imageDatas addObject:[NSString stringWithFormat:@"data:image/jpeg;base64,%@",dataStr]];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:imageDatas options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [params setObject:jsonStr forKey:@"imgUrl"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        if (message.length > 0) {
            [SVProgressHUD showCustomSuccessWithStatus:message];
        }
        NSDictionary *dic = nil;
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                dic = data[0];
            }
        }
        if (weakSelf.paymentWay == 0) {
            return;
        }
        if (weakSelf.paymentWay == 1) {
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [mutDic setObject:@"广告位购买" forKey:@"subject"];
            [[WYPayManager shareInstance] payForAlipayWith:mutDic];
        } else if (weakSelf.paymentWay == 2) {
            NSString *orderPrice = [NSString stringWithFormat:@"%.2f",[dic[@"PayAmount"] floatValue]];
            NSString *notifyURL = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL,dic[@"WxpayNotify"]];
            [WXApiManager sharedManager].delegate = self;
            [WXSendPayOrder wxSendPayOrderWidthName:@"广告位购买" orderNumber:dic[@"BillNumber"] orderPrice:orderPrice notifyURL:notifyURL];
        }
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

#pragma mark - Action
- (IBAction)chooseCityAction:(id)sender {
    self.areaChooseView.areaNode = self.areaNode;
    [self.areaChooseView refreshUI];
    LEAlertMarkView *alert = [[LEAlertMarkView alloc] initWithCustomView:self.areaChooseView type:LEAlertMarkViewTypeBottom];
    [alert show];
}

- (void)bidAction:(id)sender {
    NSArray *uploadImages = self.publishImageNode.uploadImageDatas;
    if (uploadImages.count == 0) {
        [SVProgressHUD showCustomInfoWithStatus:@"请上传图片"];
        return;
    }
    
    if (!self.bidAdvertNode.IsBidPrice) {
        LLBuyAdViewController *vc = [[LLBuyAdViewController alloc] init];
        vc.vcType = 1;
        LLAdvertNode *node = [LLAdvertNode new];
        node.Id = self.bidAdvertNode.Id;
        node.Price = self.bidAdvertNode.Money;
        vc.advertNode = node;
        [self.navigationController pushViewController:vc animated:true];
        WEAKSELF
        vc.chooseDaysBlock = ^(int days) {
            weakSelf.buyDays = days;
            weakSelf.bidPrice = [NSString stringWithFormat:@"%.2f",weakSelf.buyDays * weakSelf.bidAdvertNode.Money];
            [weakSelf paymentWayViewShow];
        };
        return;
    }
    [self.beeAffirmBidView updateViewWithData:self
     .bidAdvertNode];
    LEAlertMarkView *alert = [[LEAlertMarkView alloc] initWithCustomView:self.beeAffirmBidView type:LEAlertMarkViewTypeBottom];
    [alert show];
}

#pragma mark - SetGet
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

- (LLPublishIDCardViewCell *)publishImageViewCell {
    if (!_publishImageViewCell) {
        static NSString *cellIdentifier = @"LLPublishIDCardViewCell";
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        _publishImageViewCell = [cells objectAtIndex:0];
        _publishImageViewCell.vc = self;
    }
    return _publishImageViewCell;
}

- (LLPublishInputViewCell *)publishInputViewCell {
    if (!_publishInputViewCell) {
        static NSString *cellIdentifier = @"LLPublishInputViewCell";
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        _publishInputViewCell = [cells objectAtIndex:0];
    }
    return _publishInputViewCell;
}

- (LLAreaChooseView *)areaChooseView {
    if (!_areaChooseView) {
        _areaChooseView = [[[NSBundle mainBundle] loadNibNamed:@"LLAreaChooseView" owner:self options:nil] firstObject];
        _areaChooseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 306);
        __weak UIView *weakView = _areaChooseView;
        WEAKSELF
        _areaChooseView.chooseBlock = ^(LLHomeNode * _Nonnull areaNode) {
            if ([weakView.superview isKindOfClass:[LEAlertMarkView class]]) {
                LEAlertMarkView *alert = (LEAlertMarkView *)weakView.superview;
                [alert dismiss];
            }
            if (areaNode) {
                weakSelf.areaNode = areaNode;
                [weakSelf changeCity];
                [weakSelf getBidAdvertRecord];
            }
        };
    }
    return _areaChooseView;
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

#pragma mark - ZJPayPopupViewDelegate
- (void)didClickForgetPasswordButton
{
    LLPayPasswordResetViewController *vc = [[LLPayPasswordResetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)didPasswordInputFinished:(NSString *)password
{
    [self addAdvertInfoWithPassword:password];
    [self.payPopupView hidePayPopView];
}

#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvSendPayResponse:(PayResp *)resp {
    switch (resp.errCode) {
        case WXSuccess: {
            [SVProgressHUD showCustomSuccessWithStatus:@"支付成功"];
            [self getBidAdvertRecord];
        }
            break;
        default: {
            [SVProgressHUD showCustomErrorWithStatus:@"支付失败"];
        }
            break;
    }
    
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
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:true];
}

@end
