//
//  LLReceiveRedAlertView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/14.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLReceiveRedAlertView.h"

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
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.avatarImageView setbitmapImage:nil];
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.imgIcon setbitmapImage:nil];
    self.nickNameLabel.text = @"郑和";
}

@end
