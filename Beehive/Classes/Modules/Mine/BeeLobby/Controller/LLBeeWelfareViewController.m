//
//  LLBeeWelfareViewController.m
//  Beehive
//
//  Created by liguangjun on 2019/3/18.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLBeeWelfareViewController.h"

@interface LLBeeWelfareViewController ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewContentH;
@property (nonatomic, weak) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, weak) IBOutlet UIView *viewContent;
@property (nonatomic, weak) IBOutlet UILabel *labDes1;
@property (nonatomic, weak) IBOutlet UILabel *labDes2;
@property (nonatomic, weak) IBOutlet UILabel *labDes3;

@end

@implementation LLBeeWelfareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self getQueenWelfareExplain];
}

- (void)setup {
    self.title = @"蜂王福利一";
    self.view.backgroundColor = kAppThemeColor;
    
    self.labDes1.text = @"分享蜂王邀请码，\n推荐好友成功购买即可获得10%推荐佣金";
    self.labDes2.text = @"蜂王分轮次售卖，首轮城寨售价1450元，\n后续依次递增，最高3250元！\n\n推荐1名蜂巢蜂王，您最高能获得\n3250*10%*1=325元\n\n推荐5名蜂巢蜂王，您最高能获得\n3250*10%*5=1625元\n\n推荐10名蜂巢蜂王，您最高能获得\n3250*10%*10=3250元\n\n推荐的蜂王越多，您赚取的推荐佣金也就越多!";
    self.labDes3.text = @"您还将享有以下高额收益:\n\n1, 租户收益：租户抢多少，您就得多少\n2, 广告位收益：最高417元/天；\n3, 格子铺收益：约100元/天；\n4, 区域线下服务收益：约200元/天；\n5, 区域发红包总金额抽成：约53元/天。";
    
    CGFloat height = [self.viewContent systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.viewContentH.constant = height;
}

- (void)refreshData {
    
}

- (void)getQueenWelfareExplain {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetQueenWelfareExplain"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *caCheKey = @"GetQueenWelfareExplain";
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                NSDictionary *dic = data[0];
                NSString *welfareOne = dic[@"WelfareOne"];
                NSString *welfareTwo = dic[@"WelfareTwo"];
                NSString *welfareThree = dic[@"WelfareThree"];
                weakSelf.labDes1.attributedText = [WYCommonUtils HTMLStringToColorAndFontAttributeString:welfareOne font:[FontConst PingFangSCRegularWithSize:13] color:kAppTitleColor];
                weakSelf.labDes2.attributedText = [WYCommonUtils HTMLStringToColorAndFontAttributeString:welfareTwo font:[FontConst PingFangSCRegularWithSize:13] color:kAppTitleColor];
                weakSelf.labDes3.attributedText = [WYCommonUtils HTMLStringToColorAndFontAttributeString:welfareThree font:[FontConst PingFangSCRegularWithSize:13] color:kAppTitleColor];
            }
        }
//        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

@end
