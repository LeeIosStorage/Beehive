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
@property (nonatomic, weak) IBOutlet UILabel *adsPriceLabel;

@end

@implementation LLEditAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    
}

- (void)setup {
    self.title = @"广告图";
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:self.advertNode.DataImg] setImage:self.adsImageView setbitmapImage:nil];
    self.adsLabel.text = self.advertNode.DataTitle;
    self.adsPriceLabel.text = [NSString stringWithFormat:@"（%.0f元/天）", self.advertNode.Price];
    
}

- (IBAction)editAction:(id)sender {
    LLUploadAdViewController *vc = [[LLUploadAdViewController alloc] init];
    vc.advertNode = self.advertNode;
    vc.vcType = LLUploadAdTypeEdit;
    [self.navigationController pushViewController:vc animated:true];
    WEAKSELF
    vc.successBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:true];
    };
}

- (IBAction)deleteAction:(id)sender {
    [self deleteAdvert];
}

- (void)deleteAdvert {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"DeleteAdvert"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.advertNode.Id forKey:@"id"];
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:true];
        });
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

@end
