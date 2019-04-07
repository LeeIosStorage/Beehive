//
//  LLBeeKingIntroViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/20.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeKingIntroViewController.h"
#import "LLBeeKingViewController.h"

@interface LLBeeKingIntroViewController ()

@property (nonatomic, weak) IBOutlet UILabel *labDes1;
@property (nonatomic, weak) IBOutlet UILabel *labDes2;
@property (nonatomic, weak) IBOutlet UILabel *labDes3;
@property (nonatomic, weak) IBOutlet UILabel *labDes4;

@end

@implementation LLBeeKingIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"成为蜂王";
    
    self.labDes1.text = @"广告位收益、推荐收益";
    self.labDes2.text = @"成功推荐他人购买广告位";
    self.labDes3.text = @"1. 格子店铺收益\n2. 格子店铺收益";
    self.labDes4.text = @"除上述收益外，平台将创造更多收益渠道和形式，为蜂王打造“家人级”服务。优秀蜂王有机会获得蜂巢APP平台收益和股权！";
}

- (IBAction)beeKingAction:(id)sender {
    LLBeeKingViewController *vc = [[LLBeeKingViewController alloc] init];
    vc.currentPage = 1;
    [self.navigationController pushViewController:vc animated:true];
}

@end
