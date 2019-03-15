//
//  LLPersonalHomeHeaderView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPersonalHomeHeaderView.h"

@interface LLPersonalHomeHeaderView ()

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *sexImageView;
@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;

@property (nonatomic, weak) IBOutlet UILabel *labDes;
//@property (nonatomic, strong) IBOutlet UILabel *labRule2;

@end

@implementation LLPersonalHomeHeaderView

- (void)updateCellWithData:(id)node {
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.avatarImageView setbitmapImage:[UIImage imageNamed:@""]];
    self.nickNameLabel.text = @"郑和";
}

@end
