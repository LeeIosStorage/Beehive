//
//  LLBeeLobbyTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/18.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeLobbyTableViewCell.h"
#import "LLAdvertNode.h"

@interface LLBeeLobbyTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *labTitle;

@end

@implementation LLBeeLobbyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    LLAdvertNode *someNode = (LLAdvertNode *)node;
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:someNode.DataImg] setImage:self.iconImageView setbitmapImage:nil];
    self.labTitle.text = someNode.DataTitle;
}

@end
