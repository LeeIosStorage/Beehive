//
//  LLMessageDetailsHeaderView.m
//  Beehive
//
//  Created by liguangjun on 2019/3/6.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLMessageDetailsHeaderView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface LLMessageDetailsHeaderView ()
<
SDCycleScrollViewDelegate
>
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *sexImageView;

@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *signLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;

@property (nonatomic, weak) IBOutlet SDCycleScrollView *gridImageView;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *gridImageViewConstraintH;
@property (nonatomic, weak) IBOutlet UIView *imagePageView;
@property (nonatomic, weak) IBOutlet UILabel *imagePageLabel;

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) IBOutlet UIButton *readButton;
@property (nonatomic, strong) IBOutlet UIButton *favourButton;

@property (nonatomic, weak) IBOutlet UILabel *commentLabel;

@end

@implementation LLMessageDetailsHeaderView

- (void)setup {
    [super setup];
    self.avatarImageView.layer.cornerRadius = 22.5;
    self.avatarImageView.layer.masksToBounds = true;
    
    self.gridImageView.layer.cornerRadius = 10;
    self.gridImageView.layer.masksToBounds = true;
    
    self.gridImageView.backgroundColor = kAppThemeColor;
    self.gridImageView.delegate = self;
    
    self.imagePageView.backgroundColor = kAppMaskOpaqueBlackColor;
    self.imagePageView.layer.cornerRadius = 15;
    self.imagePageView.layer.masksToBounds = true;
    
    self.images = [NSMutableArray array];
}

- (void)updateCellWithData:(id)node {
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.avatarImageView setbitmapImage:nil];
    self.signLabel.text = @"个性签名吧";
    self.contentLabel.text = @"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
    [self.images removeAllObjects];
    [self.images addObject:kLLAppTestHttpURL];
    [self.images addObject:kLLAppTestHttpURL];
    [self.images addObject:kLLAppTestHttpURL];
    if (self.images.count > 0) {
        self.gridImageViewConstraintH.constant = 225;
        [self.imagePageView setHidden:false];
    } else {
        self.gridImageViewConstraintH.constant = 0;
        [self.imagePageView setHidden:true];
    }
    self.gridImageView.showPageControl = false;
    self.gridImageView.imageURLStringsGroup = self.images;
    
    self.imagePageLabel.text = [NSString stringWithFormat:@"%d/%ld",1,self.images.count];
    
    NSString *commentText = [NSString stringWithFormat:@"评论（%d）",20];
    self.commentLabel.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:commentText range:NSMakeRange(0, 2) font:[FontConst PingFangSCRegularWithSize:13] color:kAppTitleColor];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    LELog(@"点击了图片%ld",index);
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
//    LELog(@"图片滑动到%ld",index);
    self.imagePageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(index + 1),self.images.count];
}

@end
