//
//  LLPartnerHeaderView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPartnerHeaderView.h"

@interface LLPartnerHeaderView ()

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *sexImageView;

@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *partnerTipLabel;
@property (nonatomic, weak) IBOutlet UILabel *incomeLabel;

@property (nonatomic, weak) IBOutlet UIImageView *adsImageView;
@property (nonatomic, weak) IBOutlet UILabel *adsLabel;

@end

@implementation LLPartnerHeaderView

- (void)setup {
    [super setup];
    self.backgroundColor = kAppSectionBackgroundColor;
}

- (void)updateCellWithData:(id)node {
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.avatarImageView setbitmapImage:nil];
    self.nickNameLabel.text = @"11";
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.adsImageView setbitmapImage:nil];
    self.adsLabel.text = @"广告位";
    
}

- (IBAction)buyAdAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.buyAdBlock) {
        self.buyAdBlock(btn.tag);
    }
}

- (IBAction)uploadAdAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.uploadAdBlock) {
        self.uploadAdBlock(btn.tag);
    }
}

- (IBAction)editAdAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.editAdBlock) {
        self.editAdBlock(btn.tag);
    }
}

@end
