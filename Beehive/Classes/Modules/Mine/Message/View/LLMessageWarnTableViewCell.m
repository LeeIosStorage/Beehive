//
//  LLMessageWarnTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/13.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMessageWarnTableViewCell.h"

@interface LLMessageWarnTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;

@end

@implementation LLMessageWarnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgIcon.layer.cornerRadius = 20;
    self.imgIcon.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    NSDictionary *dic = (NSDictionary *)node;
    self.labTitle.text = dic[@"title"];
    self.imgIcon.image = [UIImage imageNamed:dic[@"icon"]];
}

@end
