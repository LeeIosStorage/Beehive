//
//  LLReceiveFavourTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/13.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLReceiveFavourTableViewCell.h"
#import "LLCommentNode.h"

@interface LLReceiveFavourTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labTime;
@property (nonatomic, weak) IBOutlet UIImageView *imgContent;

@end

@implementation LLReceiveFavourTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    LLCommentNode *someNode = (LLCommentNode *)node;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:someNode.HeadImg] setImage:self.imgIcon setbitmapImage:nil];
    self.labTitle.text = someNode.UserName;
    self.labTime.text = someNode.AddTime;
    
    NSString *url = @"";
    if (someNode.ImgUrls.count > 0) {
        url = someNode.ImgUrls[0];
    }
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:url] setImage:self.imgContent setbitmapImage:nil];
}

@end
