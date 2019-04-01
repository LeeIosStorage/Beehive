//
//  LLBeeQunViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/8.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeQunViewController.h"
#import "LLBeeQunPersonsViewController.h"
#import "LLInvitationCodeViewController.h"
#import "LLBeeQunMoneyNode.h"

@interface LLBeeQunViewController ()

@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UILabel *labEarnings;
@property (nonatomic, weak) IBOutlet UILabel *labTotalEarnings;
@property (nonatomic, weak) IBOutlet UILabel *labOneQunEarnings;
@property (nonatomic, weak) IBOutlet UILabel *labTwoQunEarnings;
@property (nonatomic, weak) IBOutlet UILabel *labOneQunCount;
@property (nonatomic, weak) IBOutlet UILabel *labTwoQunCount;

@property (nonatomic, strong) LLBeeQunMoneyNode *beeQunMoneyNode;

@end

@implementation LLBeeQunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshDataRequest];
}

#pragma mark -
#pragma mark - Private
- (void)setup {
    self.title = @"蜂群";
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(355.5);
    }];
}

- (void)refreshHeadViewUI {
    self.labEarnings.text = [NSString stringWithFormat:@"¥ %.2f",self.beeQunMoneyNode.NowTotalSumMoney];
    self.labTotalEarnings.text = [NSString stringWithFormat:@"¥ %.2f",self.beeQunMoneyNode.TotalSumMoney];
    self.labOneQunEarnings.text = [NSString stringWithFormat:@"¥ %.2f",self.beeQunMoneyNode.ParentSumMoney];
    self.labTwoQunEarnings.text = [NSString stringWithFormat:@"¥ %.2f",self.beeQunMoneyNode.GrandSumMoney];
    self.labOneQunCount.text = [NSString stringWithFormat:@"%d",self.beeQunMoneyNode.ParentSumCount];
    self.labTwoQunCount.text = [NSString stringWithFormat:@"%d",self.beeQunMoneyNode.GrandSumCount];
}

#pragma mark -
#pragma mark - Request
- (void)refreshDataRequest {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetFansMoney"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [self.networkManager POST:requesUrl needCache:YES caCheKey:@"GetFansMoney" parameters:params responseClass:[LLBeeQunMoneyNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                weakSelf.beeQunMoneyNode = data[0];
            }
        }
        [weakSelf refreshHeadViewUI];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)joinMoneyRequest {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"JoinMoney"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLBeeQunMoneyNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        [SVProgressHUD showCustomInfoWithStatus:message];
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
            }
        }
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

#pragma mark - Action
- (IBAction)depositAction:(id)sender {
//    if (self.beeQunMoneyNode.NowTotalSumMoney == 0) {
//        [SVProgressHUD showCustomInfoWithStatus:@"暂时没有未领取的收益，分享好友加入吧"];
//        return;
//    }
    [self joinMoneyRequest];
}

- (IBAction)oneQunAction:(id)sender {
    LLBeeQunPersonsViewController *vc = [[LLBeeQunPersonsViewController alloc] init];
    vc.vcType = 0;
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)twoQunAction:(id)sender {
    LLBeeQunPersonsViewController *vc = [[LLBeeQunPersonsViewController alloc] init];
    vc.vcType = 1;
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)inviteAction:(id)sender {
    LLInvitationCodeViewController *vc = [[LLInvitationCodeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

@end
