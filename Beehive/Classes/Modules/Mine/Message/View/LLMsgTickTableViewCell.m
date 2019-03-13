//
//  LLMsgTickTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/13.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMsgTickTableViewCell.h"
#import "LLCellOriginalContentView.h"

@interface LLMsgTickTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labDes;
@property (nonatomic, weak) IBOutlet LLCellOriginalContentView *oriContentView;

@end

@implementation LLMsgTickTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgIcon.layer.cornerRadius = 14;
    self.imgIcon.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.imgIcon setbitmapImage:nil];
    self.labTitle.text = @"老夫 已采纳你的意见";
    self.labDes.text = @"2018-12-09";
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.oriContentView.imgIcon setbitmapImage:nil];
    self.oriContentView.labTitle.text = @"22";
    self.oriContentView.labDes.text = @"14:40:33";
}

@end
