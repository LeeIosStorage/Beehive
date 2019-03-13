//
//  LLAttentionTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/13.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLAttentionTableViewCell.h"

@interface LLAttentionTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labDes;
@property (nonatomic, weak) IBOutlet UIButton *rightButton;

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
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.imgIcon setbitmapImage:nil];
    self.labTitle.text = @"11";
    self.labDes.text = @"11";
    self.rightButton.backgroundColor = kAppThemeColor;
    [self.rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [FontConst PingFangSCRegularWithSize:12];
    [self.rightButton setTitle:@"+关注" forState:UIControlStateNormal];
    if (1) {
        self.rightButton.backgroundColor = UIColor.clearColor;
        [self.rightButton setTitleColor:kAppLightTitleColor forState:UIControlStateNormal];
        self.rightButton.titleLabel.font = [FontConst PingFangSCRegularWithSize:11];
        [self.rightButton setTitle:@"已关注" forState:UIControlStateNormal];
    }
}

@end
