//
//  LLInvitationCodeViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLInvitationCodeViewController.h"

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
}

- (void)setup {
    self.title = @"邀请码";
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:[LELoginUserManager headImgUrl]] setImage:self.imgAvatar setbitmapImage:nil];
    
    self.labNickName.text = [NSString stringWithFormat:@"%@的二维码", [LELoginUserManager nickName]];
    self.labInvitationCode.text = [NSString stringWithFormat:@"邀请码:%@",[LELoginUserManager invitationCode]];
    self.imgQRCode.image = [WYCommonUtils getHDQRImgWithString:[LELoginUserManager invitationCode] size:CGSizeMake(170, 170)];
}

- (void)saveImage {
    UIImage *image = [WYCommonUtils cutImageWithView:self.viewQRContainer];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (IBAction)shareAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag;
    if (index == 4) {
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
