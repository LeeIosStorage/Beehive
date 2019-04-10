//
//  LLPublishTipViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/10.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPublishTipViewCell.h"

@interface LLPublishTipViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *labTip;

@end

@implementation LLPublishTipViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = kAppSectionBackgroundColor;
    self.contentView.backgroundColor = kAppSectionBackgroundColor;
    
    self.labTip.text = [NSString stringWithFormat:@"*%.0f蜂蜜=1元",1/[LELoginUserManager exchangeRate]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
