//
//  LLReceiveRedAlertView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/14.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLReceiveRedAlertView.h"
#import "LLRedpacketNode.h"

@interface LLReceiveRedAlertView ()

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;
@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;

@end

@implementation LLReceiveRedAlertView

- (void)setup {
    [super setup];
    self.backgroundColor = UIColor.clearColor;
}

- (IBAction)clickAction:(id)sender {
    if (self.clickBlock) {
        self.clickBlock(0);
    }
}

- (void)updateCellWithData:(id)node {
    LLRedpacketNode *someNode = (LLRedpacketNode *)node;
    
    self.avatarImageView.hidden = true;
    if (someNode.HeadImg.length > 0) {
        self.avatarImageView.hidden = false;
    }
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:someNode.HeadImg] setImage:self.avatarImageView setbitmapImage:nil];
    
    NSString *url = @"";
    if (someNode.ImgUrls.count > 0) {
        url = someNode.ImgUrls[0];
    }
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:url] setImage:self.imgIcon setbitmapImage:nil];
    self.imgIcon.hidden = true;
    if (url.length > 0) {
        self.imgIcon.hidden = false;
    }
    
    self.nickNameLabel.hidden = true;
    if (someNode.UserName.length > 0) {
        self.nickNameLabel.hidden = false;
    }
    self.nickNameLabel.text = someNode.UserName;
}

@end
