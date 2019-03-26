//
//  LLCityOptionCollectionViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/3.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLCityOptionCollectionViewCell.h"
#import "LLRedCityNode.h"

@interface LLCityOptionCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@end

@implementation LLCityOptionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCellWithData:(id)node {
    LLRedCityNode *cityNode = (LLRedCityNode *)node;
    self.nameLabel.text = cityNode.Name;
}

@end
