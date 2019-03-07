//
//  LLMineCollectionViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/7.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMineCollectionViewCell.h"
#import "LLMineNode.h"

@interface LLMineCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *img;
@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation LLMineCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCellWithData:(id)node {
    LLMineNode *mineNode = (LLMineNode *)node;
    self.img.image = [UIImage imageNamed:mineNode.icon];
    self.label.text = mineNode.title;
}

@end
