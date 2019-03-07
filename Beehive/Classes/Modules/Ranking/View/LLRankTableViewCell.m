//
//  LLRankTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/7.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLRankTableViewCell.h"

@interface LLRankTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *rankImageView;
@property (nonatomic, weak) IBOutlet UILabel *rankLabel;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;

@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *leftDesLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightLabel;
@property (nonatomic, weak) IBOutlet UILabel *rightDesLabel;

@end

@implementation LLRankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarImageView.layer.cornerRadius = 16.5;
    self.avatarImageView.layer.masksToBounds = true;
    self.rankLabel.font = [FontConst PingFangSCSemiboldWithSize:13];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    
    self.rankImageView.hidden = false;
    self.rankLabel.hidden = true;
    if (self.indexPath.row == 0) {
        self.rankImageView.image = [UIImage imageNamed:@"rank_1_icon"];
    } else if (self.indexPath.row == 1) {
        self.rankImageView.image = [UIImage imageNamed:@"rank_2_icon"];
    } else if (self.indexPath.row == 2) {
        self.rankImageView.image = [UIImage imageNamed:@"rank_3_icon"];
    } else {
        self.rankImageView.hidden = true;
        self.rankLabel.hidden = false;
    }
    self.rankLabel.text = [NSString stringWithFormat:@"%ld",self.indexPath.row + 1];
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.avatarImageView setbitmapImage:nil];
    self.nickNameLabel.text = @"郑和";
    self.leftDesLabel.text = @"河南省郑州";
    self.rightLabel.text = [NSString stringWithFormat:@"%d人",1000];
    self.rightDesLabel.text = @"蜂群人数";
}

@end