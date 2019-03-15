//
//  LLRedrReceiveDetailsHeaderView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLRedrReceiveDetailsHeaderView.h"

@interface LLRedrReceiveDetailsHeaderView ()

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *sexImageView;
@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;

@property (nonatomic, strong) IBOutlet UILabel *labRule1;
@property (nonatomic, strong) IBOutlet UILabel *labRule2;

@end

@implementation LLRedrReceiveDetailsHeaderView

- (void)setup {
    [super setup];
    
    self.labRule1.layer.borderWidth = 0.5;
    self.labRule1.layer.borderColor = kAppLightTitleColor.CGColor;
    self.labRule2.layer.borderWidth = 0.5;
    self.labRule2.layer.borderColor = kAppLightTitleColor.CGColor;
}

- (void)updateCellWithData:(id)node {
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.avatarImageView setbitmapImage:[UIImage imageNamed:@""]];
    self.nickNameLabel.text = @"郑和";
}

@end
