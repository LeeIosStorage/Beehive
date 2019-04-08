//
//  LLInvitationCodeViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLInvitationCodeViewController.h"
#import "WYShareManager.h"

@interface LLInvitationCodeViewController ()

@property (nonatomic, weak) IBOutlet UIView *viewQRContainer;
@property (nonatomic, weak) IBOutlet UIImageView *imgAvatar;
@property (nonatomic, weak) IBOutlet UILabel *labNickName;
@property (nonatomic, weak) IBOutlet UILabel *labInvitationCode;
@property (nonatomic, weak) IBOutlet UIImageView *imgQRCode;

@end

@implementation LLInvitationCodeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:true animated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
}

- (void)setup {
    self.title = @"邀请码";
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:[LELoginUserManager headImgUrl]] setImage:self.imgAvatar setbitmapImage:nil];
    
    self.labNickName.text = [NSString stringWithFormat:@"%@的二维码", [LELoginUserManager nickName]];
    self.labInvitationCode.text = [NSString stringWithFormat:@"邀请码:%@",[LELoginUserManager invitationCode]];
    self.imgQRCode.image = [WYCommonUtils getHDQRImgWithString:[LELoginUserManager invitationCode] size:CGSizeMake(170, 170)];
}

- (void)refreshData {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetInvitationInfo"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                NSDictionary *dic = data[0];
                weakSelf.labInvitationCode.text = [NSString stringWithFormat:@"邀请码:%@",dic[@"InvitationCode"]];
                [WYCommonUtils setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, dic[@"QrCodeImg"]]] setImage:weakSelf.imgQRCode setbitmapImage:nil];
//                weakSelf.imgQRCode.image = [WYCommonUtils getHDQRImgWithString:[LELoginUserManager invitationCode] size:CGSizeMake(170, 170)];
            }
        }
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)saveImage {
    UIImage *image = [WYCommonUtils cutImageWithView:self.viewQRContainer];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (IBAction)shareAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag;
    UIImage *image = [WYCommonUtils cutImageWithView:self.viewQRContainer];
    if (index == 0) {
        [[WYShareManager shareInstance] shareToWXWithImage:image scene:WXSceneSession];
    } else if (index == 1) {
        [[WYShareManager shareInstance] shareToWXWithImage:image scene:WXSceneTimeline];
    } else if (index == 2) {
        [[WYShareManager shareInstance] shareToQQWithImage:image isQZone:NO];
    } else if (index == 3) {
        [[WYShareManager shareInstance] shareToQQWithImage:image isQZone:YES];
    } else if (index == 4) {
        [self saveImage];
    }
}


#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error){
        [SVProgressHUD showCustomSuccessWithStatus:@"保存失败"];
    }else{
        [SVProgressHUD showCustomSuccessWithStatus:@"保存成功"];
    }
}

@end
