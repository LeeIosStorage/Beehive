//
//  LLRedReceiveUserTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLRedReceiveUserTableViewCell.h"
#import "LLUserInfoNode.h"

@interface LLRedReceiveUserTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;

@end

@implementation LLRedReceiveUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    LLUserInfoNode *userInfo = (LLUserInfoNode *)node;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:userInfo.HeadImg] setImage:self.avatarImageView setbitmapImage:nil];
    self.nickNameLabel.text = userInfo.UserName;
    self.timeLabel.text = userInfo.AddTime;
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",userInfo.Money];
}

@end
