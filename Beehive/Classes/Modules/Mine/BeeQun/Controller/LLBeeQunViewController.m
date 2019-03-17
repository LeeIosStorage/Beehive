//
//  LLBeeQunViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/8.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeQunViewController.h"
#import "LLBeeQunPersonsViewController.h"

@interface LLBeeQunViewController ()

@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UILabel *labEarnings;
@property (nonatomic, weak) IBOutlet UILabel *labTotalEarnings;
@property (nonatomic, weak) IBOutlet UILabel *labOneQunEarnings;
@property (nonatomic, weak) IBOutlet UILabel *labTwoQunEarnings;
@property (nonatomic, weak) IBOutlet UILabel *labOneQunCount;
@property (nonatomic, weak) IBOutlet UILabel *labTwoQunCount;

@end

@implementation LLBeeQunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
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

- (IBAction)depositAction:(id)sender {
    [SVProgressHUD showCustomInfoWithStatus:@"暂时没有未领取的收益，分享好友加入吧"];
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
    
}

@end
