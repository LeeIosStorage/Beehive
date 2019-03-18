//
//  LLAdsBidViewController.m
//  Beehive
//
//  Created by liguangjun on 2019/3/18.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLAdsBidViewController.h"
#import "LLUploadAdViewController.h"

@interface LLAdsBidViewController ()

@property (nonatomic, weak) IBOutlet UIView *adsView1;
@property (nonatomic, weak) IBOutlet UIView *adsView2;
@property (nonatomic, weak) IBOutlet UIView *adsView3;

@end

@implementation LLAdsBidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"竞价广告位";
    self.adsView1.layer.borderColor = LineColor.CGColor;
    self.adsView1.layer.borderWidth = 0.5;
    self.adsView2.layer.borderColor = LineColor.CGColor;
    self.adsView2.layer.borderWidth = 0.5;
    self.adsView3.layer.borderColor = LineColor.CGColor;
    self.adsView3.layer.borderWidth = 0.5;
}

- (IBAction)launchAdsAction:(id)sender {
    LLUploadAdViewController *vc = [[LLUploadAdViewController alloc] init];
    vc.vcType = LLUploadAdTypeLaunch;
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)homeAdsAction:(id)sender {
    LLUploadAdViewController *vc = [[LLUploadAdViewController alloc] init];
    vc.vcType = LLUploadAdTypeHome;
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)popupAdsAction:(id)sender {
    LLUploadAdViewController *vc = [[LLUploadAdViewController alloc] init];
    vc.vcType = LLUploadAdTypePopup;
    [self.navigationController pushViewController:vc animated:true];
}

@end
