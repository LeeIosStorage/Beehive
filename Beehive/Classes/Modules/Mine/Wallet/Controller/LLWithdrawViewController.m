//
//  LLWithdrawViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLWithdrawViewController.h"
#import "LLFundHandleHeaderView.h"
#import "LLBeePresentAffirmView.h"
#import "LEAlertMarkView.h"
#import "LLWalletDetailsNode.h"
#import "ZJPayPopupView.h"
#import "LLPayPasswordResetViewController.h"
#import "LELoginAuthManager.h"

@interface LLWithdrawViewController ()
<
ZJPayPopupViewDelegate
>
@property (nonatomic, strong) ZJPayPopupView *payPopupView;

@property (nonatomic, strong) LLFundHandleHeaderView *fundHandleHeaderView;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) LLWalletDetailsNode *walletDetailsNode;

@property (nonatomic, strong) NSString *chooseMoney;

@end

@implementation LLWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
    if (self.vcType == LLFundHandleVCTypeWithdraw) {
        [self getCashWithdrawalExplain];
    } else if (self.vcType == LLFundHandleVCTypePresent) {
        [self getGiveExplain];
    }
}

- (void)setup {
    self.title = @"提现";
    if (self.vcType == LLFundHandleVCTypeDeposit) {
        self.title = @"充值";
    } else if (self.vcType == LLFundHandleVCTypePresent) {
        self.title = @"赠送蜂蜜";
    }
    
    self.tableView.tableHeaderView = self.fundHandleHeaderView;
    [self.fundHandleHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        //top布局一定要加上 不然origin.y可能为负值
        make.top.width.equalTo(self.tableView);
    }];
    [self.tableView reloadData];
    
    WEAKSELF
    self.fundHandleHeaderView.affirmBlock = ^{
        if (weakSelf.vcType == LLFundHandleVCTypeWithdraw) {
            [weakSelf payPopupViewShow];
        } else if (weakSelf.vcType == LLFundHandleVCTypeDeposit) {
            
        } else if (weakSelf.vcType == LLFundHandleVCTypePresent) {
            [weakSelf showBeePresentAffirmView];
        }
    };
    self.fundHandleHeaderView.chooseAmountBlock = ^(NSString * _Nonnull money) {
        weakSelf.chooseMoney = money;
    };
    self.fundHandleHeaderView.bindWXBlock = ^(BOOL needBind) {
        if (needBind) {
            [weakSelf getWxAuthInfo];
        }
    };
}

- (void)refreshData {
    
    self.fundHandleHeaderView.vcType = self.vcType;
    [self.fundHandleHeaderView updateCellWithData:self.walletDetailsNode];
    
    LLFundHandleHeaderView *headView = (LLFundHandleHeaderView *)self.tableView.tableHeaderView;
    [self.tableView layoutIfNeeded];
    self.tableView.tableHeaderView = headView;
    
    [self.tableView reloadData];
}

- (void)showBeePresentAffirmView {
    LLBeePresentAffirmView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"LLBeePresentAffirmView" owner:self options:nil] firstObject];
    tipView.frame = CGRectMake(0, 0, 260, 280);
    [tipView updateCellWithData:nil];
    __weak UIView *weakView = tipView;
    WEAKSELF
    tipView.clickBlock = ^(NSInteger index) {
        if ([weakView.superview isKindOfClass:[LEAlertMarkView class]]) {
            LEAlertMarkView *alert = (LEAlertMarkView *)weakView.superview;
            [alert dismiss];
        }
        if (index == 1) {
            
        }
    };
    LEAlertMarkView *alert = [[LEAlertMarkView alloc] initWithCustomView:tipView type:LEAlertMarkViewTypeCenter];
    [alert show];
}

- (void)payPopupViewShow {
    self.payPopupView = [[ZJPayPopupView alloc] init];
    self.payPopupView.delegate = self;
    [self.payPopupView showPayPopView];
}

#pragma mark -
#pragma mark - Request
- (void)getCashWithdrawalExplain {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetCashWithdrawalExplain"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self.networkManager POST:requesUrl needCache:YES caCheKey:@"GetCashWithdrawalExplain" parameters:params responseClass:[LLWalletDetailsNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                self.walletDetailsNode = data[0];
            }
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)getGiveExplain {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetGiveExplain"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self.networkManager POST:requesUrl needCache:YES caCheKey:@"GetGiveExplain" parameters:params responseClass:[LLWalletDetailsNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                self.walletDetailsNode = data[0];
            }
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)cashWithdrawalRequestPwd:(NSString *)password {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    if (self.chooseMoney.length == 0) {
        [SVProgressHUD showCustomInfoWithStatus:@"请选择提现金额"];
        return;
    }
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"CashWithdrawal"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.chooseMoney forKey:@"money"];
    [params setObject:password forKey:@"payPassWord"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:message];
        NSDictionary *dic = nil;
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                dic = data[0];
            }
        }
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)getWxAuthInfo {
    WEAKSELF
    [[LELoginAuthManager sharedInstance] socialAuthBinding:UMSocialPlatformType_WechatSession presentingController:self success:^(BOOL success, NSDictionary *result) {
        if (success) {
            [weakSelf wxBindRequestWith:result[@"openId"] nickName:result[@"username"]];
        }
    }];
}

- (void)wxBindRequestWith:(NSString *)openId nickName:(NSString *)nickName {
    
    [self.view endEditing:YES];
    [SVProgressHUD showCustomWithStatus:@"登录中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"BindingWechat"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (openId.length > 0) [params setObject:openId forKey:@"openid"];
    if (nickName.length > 0) [params setObject:nickName forKey:@"nickName"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return;
        }
        [SVProgressHUD showCustomSuccessWithStatus:message];
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
            }
        }
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoLoginFaiTitle];
    }];
}

#pragma mark - set
- (LLFundHandleHeaderView *)fundHandleHeaderView {
    if (!_fundHandleHeaderView) {
        _fundHandleHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LLFundHandleHeaderView" owner:self options:nil] firstObject];
    }
    return _fundHandleHeaderView;
}

#pragma mark - ZJPayPopupViewDelegate
- (void)didClickForgetPasswordButton
{
    LLPayPasswordResetViewController *vc = [[LLPayPasswordResetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)didPasswordInputFinished:(NSString *)password
{
    [self.payPopupView hidePayPopView];
    [self cashWithdrawalRequestPwd:password];
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
