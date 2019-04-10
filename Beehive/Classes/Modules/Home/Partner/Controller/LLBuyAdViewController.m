//
//  LLBuyAdViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBuyAdViewController.h"
#import "ZJPayPopupView.h"
#import "LLPayPasswordResetViewController.h"
#import "LLPaymentWayView.h"
#import "LEAlertMarkView.h"
#import "WYPayManager.h"
#import "WXApiManager.h"
#import "WXSendPayOrder.h"

@interface LLBuyAdViewController ()
<
ZJPayPopupViewDelegate,
WXApiManagerDelegate
>
@property (nonatomic, strong) ZJPayPopupView *payPopupView;

@property (nonatomic, weak) IBOutlet UILabel *labUnitPrice;
@property (nonatomic, weak) IBOutlet UILabel *labMoney;
@property (nonatomic, weak) IBOutlet UILabel *labMaxDay;
@property (nonatomic, weak) IBOutlet UILabel *labBuyTip;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@property (nonatomic, assign) int maxDayCount;
@property (nonatomic, assign) int dayCount;

@property (nonatomic, assign) NSInteger paymentWay;

@end

@implementation LLBuyAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self getBuyAdvertisingInfo];
}

- (void)setup {
    self.title = @"租广告位";
    if (self.vcType == 1) {
        self.title = @"广告位购买";
    }
    
    self.dayCount = 1;
    self.maxDayCount = 10;
    self.textField.text = @"1";
    
    [self refreshData];
}

- (void)refreshData {
    self.labUnitPrice.text = [NSString stringWithFormat:@"每天单价为%.2f元",self.advertNode.Price];
    self.labMoney.text = [NSString stringWithFormat:@"%.2f",self.advertNode.Price];
    
    self.labMaxDay.text = [NSString stringWithFormat:@"最多可购买%d天",self.maxDayCount];
}

- (void)paymentWayViewShow {
    [self.view endEditing:true];
    LLPaymentWayView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"LLPaymentWayView" owner:self options:nil] firstObject];
    tipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 265);
    NSString *moneyText = [NSString stringWithFormat:@"%.2f",self.dayCount*self.advertNode.Price];
    [tipView updateCellWithData:moneyText];
    __weak UIView *weakView = tipView;
    WEAKSELF
    tipView.paymentBlock = ^(NSInteger type) {
        if ([weakView.superview isKindOfClass:[LEAlertMarkView class]]) {
            LEAlertMarkView *alert = (LEAlertMarkView *)weakView.superview;
            [alert dismiss];
        }
        if (type == 0) {
            [weakSelf payPopupViewShow];
        } else if (type == 1) {
            weakSelf.paymentWay = 1;
            [weakSelf buyAdvertWithPassword:nil];
        } else if (type == 2) {
            weakSelf.paymentWay = 2;
            [weakSelf buyAdvertWithPassword:nil];
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

#pragma mark - Request
- (void)getBuyAdvertisingInfo {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetBuyAdvertisingInfo"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.advertNode.Id forKey:@"id"];
    NSString *caCheKey = @"GetBuyAdvertisingInfo";
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        NSDictionary *dic = nil;
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                dic = data[0];
                weakSelf.maxDayCount = [dic[@"MaxBuyDays"] intValue];
            }
        }
        [self refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
    
}

- (void)buyAdvertWithPassword:(NSString *)password {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"BuyAdvert"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:self.paymentWay] forKey:@"payType"];
    [params setValue:self.advertNode.Id forKey:@"id"];
    [params setValue:[NSNumber numberWithInt:self.dayCount] forKey:@"days"];
    [params setValue:password forKey:@"payPwd"];
    
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
            [mutDic setObject:@"租用广告位" forKey:@"subject"];
            [[WYPayManager shareInstance] payForAlipayWith:mutDic];
        } else if (weakSelf.paymentWay == 2) {
//            [[WYPayManager shareInstance] payForWinxinWith:dic];
            NSString *orderPrice = [NSString stringWithFormat:@"%.2f",[dic[@"PayAmount"] floatValue]];
            NSString *notifyURL = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL,dic[@"WxpayNotify"]];
            [WXApiManager sharedManager].delegate = self;
            [WXSendPayOrder wxSendPayOrderWidthName:@"租用广告位" orderNumber:dic[@"BillNumber"] orderPrice:orderPrice notifyURL:notifyURL];
        }
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
    
}

#pragma mark - Action
- (IBAction)minusAction:(id)sender {
    self.dayCount --;
    if (self.dayCount < 0) {
        self.dayCount = 0;
    }
    self.textField.text = [NSString stringWithFormat:@"%d",self.dayCount];
}

- (IBAction)addAction:(id)sender {
    self.dayCount ++;
    if (self.dayCount > 123) {
        self.dayCount = 123;
    }
    self.textField.text = [NSString stringWithFormat:@"%d",self.dayCount];
}

- (IBAction)bugAction:(id)sender {
    if (self.textField.text.length == 0 || self.dayCount <= 0) {
        [SVProgressHUD showCustomInfoWithStatus:@"请输入购买天数"];
        return;
    }
    if (self.dayCount > 123) {
        [SVProgressHUD showCustomInfoWithStatus:@"超出购买天数"];
        return;
    }
    if (self.vcType == 1) {
        if (self.chooseDaysBlock) {
            self.chooseDaysBlock(self.dayCount);
        }
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    [self paymentWayViewShow];
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

#pragma mark - ZJPayPopupViewDelegate
- (void)didClickForgetPasswordButton
{
    LLPayPasswordResetViewController *vc = [[LLPayPasswordResetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)didPasswordInputFinished:(NSString *)password
{
    [self buyAdvertWithPassword:password];
    [self.payPopupView hidePayPopView];
    
//    if ([password isEqualToString:@"147258"])
//    {
//        NSLog(@"输入的密码正确");
//    }
//    else
//    {
//        NSLog(@"输入错误:%@",password);
//        [self.payPopupView didInputPayPasswordError];
//    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        return false;
    }
    //    if (!string.length && range.length > 0) {
    //        return true;
    //    }
    NSString *oldString = [textField.text copy];
    NSString *newString = [oldString stringByReplacingCharactersInRange:range withString:string];
    self.dayCount = [newString intValue];
    
    if (textField == self.textField && textField.markedTextRange == nil) {
        
    }
    return true;
}

@end
