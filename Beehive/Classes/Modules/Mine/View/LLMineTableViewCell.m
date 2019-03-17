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
@property (nonatomic, weak) IBOutlet UILabel *labDes;
@property (nonatomic, weak) IBOutlet UIImageView *imgRight;
@property (nonatomic, weak) IBOutlet UISwitch *rightSwitch;

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

- (IBAction)switchAction:(id)sender {
    UISwitch *s = (UISwitch *)sender;
    if (self.switchBlock) {
        self.switchBlock(s.on);
    }
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
    self.labDes.text = mineNode.des;
    self.rightSwitch.hidden = !mineNode.switchShow;
    self.imgRight.hidden = mineNode.switchShow;
}

@end
