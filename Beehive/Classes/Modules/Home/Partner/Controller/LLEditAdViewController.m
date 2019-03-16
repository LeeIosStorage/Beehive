//
//  LLEditAdViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLEditAdViewController.h"
#import "LLUploadAdViewController.h"

@interface LLEditAdViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *adsImageView;
@property (nonatomic, weak) IBOutlet UILabel *adsLabel;

@end

@implementation LLEditAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    
}

- (void)setup {
    self.title = @"广告图";
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.adsImageView setbitmapImage:nil];
    self.adsLabel.text = @"广告位哈哈哈哈";
    
}


- (IBAction)editAction:(id)sender {
    LLUploadAdViewController *vc = [[LLUploadAdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)deleteAction:(id)sender {
    
}

@end
