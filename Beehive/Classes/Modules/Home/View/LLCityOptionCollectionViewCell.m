//
//  LLCityOptionCollectionViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/3.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLCityOptionCollectionViewCell.h"
#import "LLRedCityNode.h"
#import "LLRedpacketNode.h"

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
    LLRedpacketNode *someNode = (LLRedpacketNode *)node;
    self.nameLabel.text = someNode.Title;
    self.nameLabel.text = @"红包";
    self.imageView.image = [UIImage imageNamed:@"home_redpacket_red"];
    if (someNode.RedType == 2) {
        self.imageView.image = [UIImage imageNamed:@"home_redpacket_bule"];
    } else if (someNode.RedType == 3) {
        self.imageView.image = [UIImage imageNamed:@"home_redpacket_yellow"];
    }
}

@end
