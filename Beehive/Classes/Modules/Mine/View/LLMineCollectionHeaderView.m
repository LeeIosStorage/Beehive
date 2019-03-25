//
//  LLMineCollectionHeaderView.m
//  Beehive
//
//  Created by liguangjun on 2019/3/7.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLMineCollectionHeaderView.h"

@interface LLMineCollectionHeaderView ()

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *sexImageView;

@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *desLabel;
@property (nonatomic, weak) IBOutlet UILabel *incomeLabel;

@property (nonatomic, weak) IBOutlet UIView *handleView;

@end

@implementation LLMineCollectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = kAppSectionBackgroundColor;
    
    self.avatarImageView.layer.cornerRadius = 30;
    self.avatarImageView.layer.masksToBounds = true;
    
    self.handleView.layer.cornerRadius = 4;
    self.handleView.layer.masksToBounds = true;
}

- (void)updateHeadViewWithData:(id)node {
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:[LELoginUserManager headImgUrl]] setImage:self.avatarImageView setbitmapImage:nil];
    self.nickNameLabel.text = [LELoginUserManager nickName];
    self.desLabel.text = [LELoginUserManager introduction];
    
    self.incomeLabel.text = [NSString stringWithFormat:@"我的总收益：¥ %.2f",[LELoginUserManager income]];
}

- (IBAction)messageAction:(id)sender {
    if (self.headerViewClickBlock) {
        self.headerViewClickBlock(0);
    }
}

- (IBAction)avatarAction:(id)sender {
    if (self.headerViewClickBlock) {
        self.headerViewClickBlock(4);
    }
}

- (IBAction)mineCollectAction:(id)sender {
    if (self.headerViewClickBlock) {
        self.headerViewClickBlock(1);
    }
}

- (IBAction)mineAttentionAction:(id)sender {
    if (self.headerViewClickBlock) {
        self.headerViewClickBlock(2);
    }
}

- (IBAction)historyAction:(id)sender {
    if (self.headerViewClickBlock) {
        self.headerViewClickBlock(3);
    }
}

@end
