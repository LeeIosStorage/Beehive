//
//  LLAttentionTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/13.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLAttentionTableViewCell.h"
#import "LLFollowUserNode.h"

@interface LLAttentionTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labDes;

@end

@implementation LLAttentionTableViewCell

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

- (IBAction)rightClick:(id)sender {
    
}

- (void)updateCellWithData:(id)node {
    LLFollowUserNode *someNode = (LLFollowUserNode *)node;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:someNode.HeadImg] setImage:self.imgIcon setbitmapImage:nil];
    self.labTitle.text = someNode.UserName;
    self.labDes.text = someNode.Autograph;
    self.rightButton.backgroundColor = kAppThemeColor;
    [self.rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [FontConst PingFangSCRegularWithSize:12];
    [self.rightButton setTitle:@" +关注 " forState:UIControlStateNormal];
    self.rightButton.enabled = true;
    if (someNode.IsMutualFollow) {
        self.rightButton.enabled = false;
        self.rightButton.backgroundColor = UIColor.clearColor;
        [self.rightButton setTitleColor:kAppLightTitleColor forState:UIControlStateNormal];
        self.rightButton.titleLabel.font = [FontConst PingFangSCRegularWithSize:11];
        [self.rightButton setTitle:@" 已关注 " forState:UIControlStateNormal];
    }
}

@end
