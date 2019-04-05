//
//  LLFundDetailTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLFundDetailTableViewCell.h"
#import "LLFundHistoryNode.h"
#import "LLWithdrawHistoryNode.h"

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
    if ([node isKindOfClass:[LLFundHistoryNode class]]) {
        self.imgIconConstraintL.constant = 10;
        LLFundHistoryNode *someNode = (LLFundHistoryNode *)node;
        self.labTitle.text = someNode.RecordTypeStr;
        self.labDate.text = someNode.AddTime;
        
        NSString *money = [NSString stringWithFormat:@"%.2f",[someNode.Money floatValue]];
        self.labAmount.text = money;
        
        UIImage *iconImage = [UIImage imageNamed:@"5_5_6.4"];
        if (someNode.RecordType == 1) {
            iconImage = [UIImage imageNamed:@"5_5_6.1"];
        } else if (someNode.RecordType == 2) {
            iconImage = [UIImage imageNamed:@"5_5_6.2"];
        } else if (someNode.RecordType == 3) {
            iconImage = [UIImage imageNamed:@"5_5_6.3"];
        }
        self.imgIcon.image = iconImage;
        
    } else if ([node isKindOfClass:[LLWithdrawHistoryNode class]]) {
        self.imgIconConstraintL.constant = -30;
        LLWithdrawHistoryNode *someNode = (LLWithdrawHistoryNode *)node;
        self.labTitle.text = @"提现";
        self.labDate.text = someNode.AddTime;
        self.labAmount.text = someNode.Amount;
    }
}

@end
