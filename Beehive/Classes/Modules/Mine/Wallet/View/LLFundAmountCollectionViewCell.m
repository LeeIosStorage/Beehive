//
//  LLFundAmountCollectionViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLFundAmountCollectionViewCell.h"

@implementation LLFundAmountCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = true;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = LineColor.CGColor;
}

@end
