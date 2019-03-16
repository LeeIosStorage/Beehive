//
//  LLMineCollectTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMineCollectTableViewCell.h"
#import "LLHandleStatusView.h"

@interface LLMineCollectTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;

@property (nonatomic, weak) IBOutlet UILabel *labTitle;

@property (nonatomic, weak) IBOutlet LLHandleStatusView *handleStatusView;

@end

@implementation LLMineCollectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.imgIcon setbitmapImage:[UIImage imageNamed:@""]];
    self.labTitle.text = @"奶茶三兄弟";
    [self.handleStatusView updateWithData:nil];
}

@end
