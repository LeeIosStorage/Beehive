//
//  LLBeeVIPViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/18.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeVIPViewController.h"
#import "LLPaymentWayView.h"
#import "LEAlertMarkView.h"
#import "WYPayManager.h"
#import "LLPromotionExplainNode.h"
#import "WXApiManager.h"
#import "WXSendPayOrder.h"
#import "ZJPayPopupView.h"
#import "LLPayPasswordResetViewController.h"

@interface LLBeeVIPViewController ()
<
WXApiManagerDelegate,
ZJPayPopupViewDelegate
>

@property (nonatomic, strong) ZJPayPopupView *payPopupView;

@property (nonatomic, strong) LLPromotionExplainNode *promotionExplainNode;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UILabel *labVIPPrice;
@property (nonatomic, weak) IBOutlet UILabel *labEquity;
@property (nonatomic, weak) IBOutlet UILabel *labEquityDes;

@property (nonatomic, weak) IBOutlet UIButton *btnSubmit;

@property (nonatomic, assign) NSInteger paymentWay;

@end

@implementation LLBeeVIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
//    [self getVipPrice];
    [self getVipExplain];
}

- (void)setup {
    self.title = @"勋章VIP";
    self.tableView.backgroundColor = kAppBackgroundColor;
    
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.0),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)[[UIColor colorWithHexString:@"#7680fe"] CGColor],(id)[[UIColor colorWithHexString:@"#a779ff"] CGColor]]];//渐变数组
    [self.btnSubmit.layer addSublayer:gradientLayer];
    
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        //top布局一定要加上 不然origin.y可能为负值
        make.top.width.equalTo(self.tableView);
    }];
    [self.tableView reloadData];
}

- (void)refreshData {
    
    self.labEquity.text = @"领取红包无限\n邀请注册返佣金";
    self.labEquityDes.attributedText = [WYCommonUtils HTMLStringToColorAndFontAttributeString:self.promotionExplainNode.VipExplain font:[FontConst PingFangSCRegularWithSize:12] color:kAppSubTitleColor];
    
    self.labVIPPrice.text = [NSString stringWithFormat:@"¥ %@", self.promotionExplainNode.VipPrice];
    
    UIView *headView = self.tableView.tableHeaderView;
    [self.tableView layoutIfNeeded];
    self.tableView.tableHeaderView = headView;
    
    [self.tableView reloadData];
}

- (void)paymentWayViewShow {
    [self.view endEditing:true];
    LLPaymentWayView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"LLPaymentWayView" owner:self options:nil] firstObject];
    tipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 265);
//    tipView.wayType = LLPaymentWayTypeVIP;
    [tipView updateCellWithData:nil];
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
            [weakSelf buyVIPReqeustWithPassword:nil];
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

#pragma mark - Reqeust
- (void)getVipExplain {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetVipExplain"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *caCheKey = @"GetPromotionExplain";
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:[LLPromotionExplainNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                weakSelf.promotionExplainNode = data[0];
            }
        }
        
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)getVipPrice {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetVipPrice"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *caCheKey = @"GetVipPrice";
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                NSString *price = data[0];
                self.labVIPPrice.text = [NSString stringWithFormat:@"¥ %@", price];
            }
        }
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)buyVIPReqeustWithPassword:(NSString *)password {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"BuyVIP"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:self.paymentWay] forKey:@"payType"];
    if (password.length == 0) password = @"";
    [params setObject:password forKey:@"payPwd"];
    
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
        if (weakSelf.paymentWay == 1) {
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [mutDic setObject:@"勋章VIP购买" forKey:@"subject"];
            [[WYPayManager shareInstance] payForAlipayWith:mutDic];
        } else if (weakSelf.paymentWay == 2) {
//            [[WYPayManager shareInstance] payForWinxinWith:dic];
            NSString *orderPrice = [NSString stringWithFormat:@"%.2f",[dic[@"PayAmount"] floatValue]];
            NSString *notifyURL = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL,dic[@"WxpayNotify"]];
            [WXApiManager sharedManager].delegate = self;
            [WXSendPayOrder wxSendPayOrderWidthName:@"勋章VIP购买" orderNumber:dic[@"BillNumber"] orderPrice:orderPrice notifyURL:notifyURL];
        }
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (IBAction)submitAction:(id)sender {
    [self paymentWayViewShow];
}

#pragma mark - ZJPayPopupViewDelegate
- (void)didClickForgetPasswordButton
{
    LLPayPasswordResetViewController *vc = [[LLPayPasswordResetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)didPasswordInputFinished:(NSString *)password
{
    [self buyVIPReqeustWithPassword:password];
    [self.payPopupView hidePayPopView];
}

#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvSendPayResponse:(PayResp *)resp {
    switch (resp.errCode) {
        case WXSuccess: {
            [SVProgressHUD showCustomSuccessWithStatus:@"支付成功"];
        }
            break;
        default: {
            [SVProgressHUD showCustomErrorWithStatus:@"支付失败"];
        }
            break;
    }
    
}

@end
