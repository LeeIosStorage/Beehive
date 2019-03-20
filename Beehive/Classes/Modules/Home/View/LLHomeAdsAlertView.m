//
//  LLHomeAdsAlertView.m
//  Beehive
//
//  Created by liguangjun on 2019/3/20.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLHomeAdsAlertView.h"

@implementation LLHomeAdsAlertView

- (void)setup {
    [super setup];
    self.backgroundColor = UIColor.clearColor;
//    self.adsImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.adsImageView.clipsToBounds = true;
}

- (IBAction)imgAction:(id)sender {
    if (self.actionBlock) {
        self.actionBlock(1);
    }
}

- (IBAction)closeAction:(id)sender {
    if (self.actionBlock) {
        self.actionBlock(0);
    }
}

- (void)updateCellWithData:(id)node {
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.adsImageView setbitmapImage:nil];
}

@end
