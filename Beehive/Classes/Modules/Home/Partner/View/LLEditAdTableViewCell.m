//
//  LLEditAdTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/11.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLEditAdTableViewCell.h"
#import "LLAdvertNode.h"

@interface LLEditAdTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *adsImageView;
@property (nonatomic, weak) IBOutlet UILabel *adsLabel;
@property (nonatomic, weak) IBOutlet UILabel *adsPriceLabel;

@end

@implementation LLEditAdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = kAppSectionBackgroundColor;
    self.contentView.backgroundColor = kAppSectionBackgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editAction:(id)sender {
    if (self.editBlock) {
        self.editBlock(self);
    }
}

- (IBAction)deleteAction:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self);
    }
}

- (void)updateCellWithData:(id)node {
    LLAdvertNode *someNode = (LLAdvertNode *)node;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:someNode.DataImg] setImage:self.adsImageView setbitmapImage:nil];
    self.adsLabel.text = someNode.DataTitle;
    self.adsPriceLabel.text = [NSString stringWithFormat:@"（%.0f元/天）", someNode.Price];
}

@end
