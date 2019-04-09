//
//  LLAdsBidViewController.m
//  Beehive
//
//  Created by liguangjun on 2019/3/18.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLAdsBidViewController.h"
#import "LLUploadAdViewController.h"
#import "LLBidAdvertNode.h"
#import "LLAdsBidDetailsViewController.h"

@interface LLAdsBidViewController ()

@property (nonatomic, strong) NSMutableArray *dataLists;

@property (nonatomic, weak) IBOutlet UIView *adsView1;
@property (nonatomic, weak) IBOutlet UIView *adsView2;
@property (nonatomic, weak) IBOutlet UIView *adsView3;
@property (nonatomic, weak) IBOutlet UIView *adsView4;

@end

@implementation LLAdsBidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
    [self getBidAdvertList];
}

- (void)setup {
    self.title = @"竞价广告位";
    self.adsView1.layer.borderColor = LineColor.CGColor;
    self.adsView1.layer.borderWidth = 0.5;
    self.adsView2.layer.borderColor = LineColor.CGColor;
    self.adsView2.layer.borderWidth = 0.5;
    self.adsView3.layer.borderColor = LineColor.CGColor;
    self.adsView3.layer.borderWidth = 0.5;
    self.adsView4.layer.borderColor = LineColor.CGColor;
    self.adsView4.layer.borderWidth = 0.5;
}

- (void)refreshData {
//    self.adsView1.hidden = true;
//    self.adsView2.hidden = true;
//    self.adsView3.hidden = true;
//    self.adsView4.hidden = true;
    
}

- (void)getBidAdvertList {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetBidAdvertList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *caCheKey = @"GetBidAdvertList";
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:[LLBidAdvertNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            weakSelf.dataLists = [NSMutableArray arrayWithArray:data];
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (IBAction)launchAdsAction:(id)sender {
    if (self.dataLists.count <= 0) {
        return;
    }
    LLAdsBidDetailsViewController *vc = [[LLAdsBidDetailsViewController alloc] init];
    vc.bidAdvertNode = self.dataLists[0];
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)homeAdsAction:(id)sender {
    if (self.dataLists.count <= 1) {
        return;
    }
    LLAdsBidDetailsViewController *vc = [[LLAdsBidDetailsViewController alloc] init];
    vc.bidAdvertNode = self.dataLists[1];
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)popupAdsAction:(id)sender {
    if (self.dataLists.count <= 2) {
        return;
    }
    LLAdsBidDetailsViewController *vc = [[LLAdsBidDetailsViewController alloc] init];
    vc.bidAdvertNode = self.dataLists[2];
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)drawAdsAction:(id)sender {
    if (self.dataLists.count <= 3) {
        return;
    }
    LLAdsBidDetailsViewController *vc = [[LLAdsBidDetailsViewController alloc] init];
    vc.bidAdvertNode = self.dataLists[3];
    [self.navigationController pushViewController:vc animated:true];
}

@end
