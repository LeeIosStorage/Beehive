//
//  LLCommodityExchangeTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/13.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLCommodityExchangeTableViewCell.h"

@interface LLCommodityExchangeTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labRead;
@property (nonatomic, weak) IBOutlet UILabel *labExchange;
@property (nonatomic, weak) IBOutlet UILabel *labPrice;
@property (nonatomic, weak) IBOutlet UILabel *labBeeCoin;
@property (nonatomic, weak) IBOutlet UILabel *labAddress;

@end

@implementation LLCommodityExchangeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.imgIcon setbitmapImage:nil];
    self.labTitle.text = @"11";
    self.labRead.text = @"11";
    self.labPrice.text = @"¥ 40.00";
    self.labAddress.text = @"11";
    self.labBeeCoin.text = @"11";
    self.labExchange.text = @"11";
}

@end
