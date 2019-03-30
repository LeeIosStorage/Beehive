//
//  LLTuiSpecialistViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/18.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLTuiSpecialistViewController.h"

@interface LLTuiSpecialistViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UILabel *labEquity;
@property (nonatomic, weak) IBOutlet UILabel *labEquityDes;

@property (nonatomic, weak) IBOutlet UIButton *btnSubmit;

@property (nonatomic, weak) IBOutlet UIView *rejectView;
@property (nonatomic, weak) IBOutlet UILabel *labReject;

@end

@implementation LLTuiSpecialistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
}

- (void)setup {
    self.title = @"推广专员";
    self.tableView.backgroundColor = kAppBackgroundColor;
    self.rejectView.hidden = true;
    
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.0),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)[[UIColor colorWithHexString:@"#ff512f"] CGColor],(id)[[UIColor colorWithHexString:@"#de2475"] CGColor]]];//渐变数组
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
    self.labEquityDes.text = @"权益说明权益说明权益说明权益说明权益说明权益说明权益说明权益说明权益说明权益说明权益说明权益说明权益说明权益说明权益说明权益说明权益说明权益说明权益说明";
    
    UIView *headView = self.tableView.tableHeaderView;
    [self.tableView layoutIfNeeded];
    self.tableView.tableHeaderView = headView;
    
    [self.tableView reloadData];
}

#pragma mark - Reqeust
- (void)applyPromotionReqeust {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"ApplyPromotion"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:message];
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:true];
        });
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (IBAction)submitAction:(id)sender {
    [self applyPromotionReqeust];
//    self.labReject.text = @"申请被绝  拒绝原因：原因是";
//    self.rejectView.hidden = false;
}

@end
