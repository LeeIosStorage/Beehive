//
//  LLPersonalHomeHeaderView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPersonalHomeHeaderView.h"
#import "LLPersonalHomeNode.h"

@interface LLPersonalHomeHeaderView ()

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *sexImageView;
@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;

@property (nonatomic, weak) IBOutlet UILabel *labDes;
@property (nonatomic, weak) IBOutlet UILabel *labFollowCount;
@property (nonatomic, weak) IBOutlet UILabel *labBeFollowCount;
@property (nonatomic, weak) IBOutlet UILabel *labReleaseCount;

@end

@implementation LLPersonalHomeHeaderView

- (void)updateCellWithData:(id)node {
    LLPersonalHomeNode *someNode = (LLPersonalHomeNode *)node;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:someNode.HeadImg] setImage:self.avatarImageView setbitmapImage:[UIImage imageNamed:@""]];
    UIImage *sexImage = [UIImage imageNamed:@"user_sex_man"];
    if (someNode.Sex == 1) {
        sexImage = [UIImage imageNamed:@"user_sex_woman"];
    }
    self.sexImageView.image = sexImage;
    self.nickNameLabel.text = someNode.UserName;
    self.labDes.text = someNode.Autograph;
    
    self.labFollowCount.textColor = kAppThemeColor;
    self.labFollowCount.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:[NSString stringWithFormat:@"他关注的 %d",someNode.FollowCount] range:NSMakeRange(0, 4) font:self.labFollowCount.font color:kAppTitleColor];
    self.labBeFollowCount.textColor = kAppThemeColor;
    self.labBeFollowCount.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:[NSString stringWithFormat:@"关注他的 %d",someNode.BeFollowCount] range:NSMakeRange(0, 4) font:self.labBeFollowCount.font color:kAppTitleColor];
    self.labReleaseCount.text = [NSString stringWithFormat:@"（共%d条）",someNode.ReleaseCount];
}

@end
