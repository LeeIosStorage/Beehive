//
//  LLPricingTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/18.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPricingTableViewCell.h"
#import "LLBeeKingNode.h"

@interface LLPricingTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *areaNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;

@end

@implementation LLPricingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.typeLabel.layer.cornerRadius = 2;
    self.typeLabel.layer.masksToBounds = true;
    self.typeLabel.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    LLBeeKingNode *someNode = (LLBeeKingNode *)node;
    self.typeLabel.text = @"定价";
    self.typeLabel.layer.borderColor = kAppThemeColor.CGColor;
    self.typeLabel.textColor = kAppThemeColor;
    self.areaNameLabel.text = someNode.AreaName;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f/年",someNode.CostMoeny];
    [self.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    self.buyButton.backgroundColor = kAppThemeColor;
    if (someNode.IsBiddingPrice) {
        self.typeLabel.text = @"竞拍";
        self.typeLabel.layer.borderColor = [UIColor colorWithHexString:@"#FC5751"].CGColor;
        self.buyButton.backgroundColor = [UIColor colorWithHexString:@"#FC5751"];
        self.typeLabel.textColor = [UIColor colorWithHexString:@"#FC5751"];
        [self.buyButton setTitle:@"立即出价" forState:UIControlStateNormal];
    }
}

@end
