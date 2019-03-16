//
//  LLMineTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMineTableViewCell.h"
#import "LLMineNode.h"

@interface LLMineTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imgIconConstraintL;
@property (nonatomic, weak) IBOutlet UILabel *labTitle;

@end

@implementation LLMineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    LLMineNode *mineNode = (LLMineNode *)node;
    self.imgIcon.image = [UIImage imageNamed:mineNode.icon];
    self.labTitle.text = mineNode.title;
    if (mineNode.icon.length > 0) {
        self.imgIconConstraintL.constant = 10;
    } else {
        self.imgIconConstraintL.constant = -10;
    }
}

@end
