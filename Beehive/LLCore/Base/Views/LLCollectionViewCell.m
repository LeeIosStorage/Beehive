//
//  LLCollectionViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/3.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLCollectionViewCell.h"

@implementation LLCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColor.whiteColor;
    self.contentView.backgroundColor = UIColor.whiteColor;
}

- (void)updateCellWithData:(id)node {
    self.node = node;
}

@end
