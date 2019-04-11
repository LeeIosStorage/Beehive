//
//  LLMineCollectionHeaderView.m
//  Beehive
//
//  Created by liguangjun on 2019/3/7.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLMineCollectionHeaderView.h"
#import "LELoginModel.h"

@interface LLMineCollectionHeaderView ()

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *sexImageView;

@property (nonatomic, weak) IBOutlet UIView *viewRank;

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
    
    UIImage *sexImage = [UIImage imageNamed:@"user_sex_man"];
    if ([[LELoginUserManager sex] intValue] == 1) {
        sexImage = [UIImage imageNamed:@"user_sex_woman"];
    }
    self.sexImageView.image = sexImage;
    
    self.incomeLabel.text = [NSString stringWithFormat:@"我的总收益：¥ %.2f",[LELoginUserManager income]];
    
    [self updateUserRankMark];
}

- (void)updateUserRankMark {
    [self.viewRank removeAllSubviews];
    NSMutableArray *rankImages = [NSMutableArray array];
    
    if ([LELoginUserManager loginModel].IsBigQueen) {
        [rankImages addObject:@"bee_rank8"];
    } else {
        if ([LELoginUserManager loginModel].IsQueen) {
            [rankImages addObject:@"bee_rank7"];
        }
    }
    if ([LELoginUserManager loginModel].IsVip) {
        [rankImages addObject:@"bee_rank9"];
    }
    if ([LELoginUserManager loginModel].IsPromotion) {
        [rankImages addObject:@"bee_rank10"];
    }
    if ([LELoginUserManager loginModel].Rank > 0) {
        NSString *str = [NSString stringWithFormat:@"bee_rank%d", [LELoginUserManager loginModel].Rank];
        [rankImages addObject:str];
    }
    
    CGFloat left = 0;
    for (int i = 0; i < rankImages.count; i ++) {
        UIImageView *img = [[UIImageView alloc] init];
        img.image = [UIImage imageNamed:rankImages[i]];
        [self.viewRank addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.viewRank).offset(left);
            make.centerY.equalTo(self.viewRank);
            make.size.mas_equalTo(CGSizeMake(19, 19));
        }];
        left += 19;
        left += 4;
    }
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
