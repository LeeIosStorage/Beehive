//
//  LLFundDetailTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLFundDetailTableViewCell.h"

@interface LLFundDetailTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imgIconConstraintL;
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labDate;
@property (nonatomic, weak) IBOutlet UILabel *labAmount;

@end

@implementation LLFundDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    NSString *imgStr = (NSString *)node;
    self.imgIcon.image = [UIImage imageNamed:imgStr];
    self.labTitle.text = @"抢红包";
    if (imgStr.length > 0) {
        self.imgIconConstraintL.constant = 10;
    } else {
        self.imgIconConstraintL.constant = -10;
        self.labTitle.text = @"提现";
    }
}

@end
