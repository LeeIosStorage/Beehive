//
//  LLTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/3.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLTableViewCell.h"

@implementation LLTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    self.node = node;
}

@end
