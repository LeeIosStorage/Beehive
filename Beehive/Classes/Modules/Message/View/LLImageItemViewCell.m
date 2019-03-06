//
//  LLImageItemViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/6.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLImageItemViewCell.h"

@interface LLImageItemViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation LLImageItemViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = kAppThemeColor;
    self.contentView.backgroundColor = kAppThemeColor;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = true;
    self.imageView.layer.cornerRadius = 4;
    self.imageView.layer.masksToBounds = true;
}

- (void)updateCellWithData:(id)node {
    NSString *urlStr = (NSString *)node;
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:urlStr] setImage:self.imageView setbitmapImage:nil];
}

@end
