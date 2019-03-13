//
//  LLReceiveCommentTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/13.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLReceiveCommentTableViewCell.h"
#import "LLCellOriginalContentView.h"

@interface LLReceiveCommentTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labTime;
@property (nonatomic, weak) IBOutlet UILabel *labContent;
@property (nonatomic, weak) IBOutlet LLCellOriginalContentView *oriContentView;

@end

@implementation LLReceiveCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgIcon.layer.cornerRadius = 17.5;
    self.imgIcon.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.imgIcon setbitmapImage:nil];
    self.labTitle.text = @"11";
    self.labTime.text = @"2018-12-09";
    
    self.labContent.text = @"11";
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.oriContentView.imgIcon setbitmapImage:nil];
    self.oriContentView.labTitle.text = @"22";
    self.oriContentView.labDes.text = @"14:40:33";
}

@end
