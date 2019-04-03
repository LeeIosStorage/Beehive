//
//  LLRedrReceiveDetailsHeaderView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLRedrReceiveDetailsHeaderView.h"
#import "LLRedReceiveDetailNode.h"

@interface LLRedrReceiveDetailsHeaderView ()

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *sexImageView;
@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;

@property (nonatomic, strong) IBOutlet UILabel *labRule1;
@property (nonatomic, strong) IBOutlet UILabel *labRule2;

@property (nonatomic, strong) IBOutlet UILabel *labMoney;
@property (nonatomic, strong) IBOutlet UILabel *labCount;

@end

@implementation LLRedrReceiveDetailsHeaderView

- (void)setup {
    [super setup];
    
    self.labRule1.layer.borderWidth = 0.5;
    self.labRule1.layer.borderColor = kAppLightTitleColor.CGColor;
    self.labRule2.layer.borderWidth = 0.5;
    self.labRule2.layer.borderColor = kAppLightTitleColor.CGColor;
    self.labRule1.text = @"";
    self.labRule2.text = @"";
}

- (void)updateCellWithData:(id)node {
    LLRedReceiveDetailNode *someNode = (LLRedReceiveDetailNode *)node;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:someNode.HeadImg] setImage:self.avatarImageView setbitmapImage:[UIImage imageNamed:@""]];
    UIImage *sexImage = [UIImage imageNamed:@"user_sex_man"];
    if (someNode.Sex == 1) {
        sexImage = [UIImage imageNamed:@"user_sex_woman"];
    }
    self.sexImageView.image = sexImage;
    self.nickNameLabel.text = someNode.UserName;
    for (int i = 0; i < someNode.ReceiveCondition.count; i ++) {
        NSString *title = someNode.ReceiveCondition[i];
        if (i == 0) {
            self.labRule1.text = title;
        } else if (i == 1) {
            self.labRule2.text = title;
        }
    }
    
    self.labMoney.text = [NSString stringWithFormat:@"%.2f蜂蜜",someNode.Money];
    self.labCount.text = [NSString stringWithFormat:@"已领取%d份/总%d份",someNode.ReceiveCount, someNode.SumCount];
}

@end
