//
//  LLMessageDetailsHeaderView.m
//  Beehive
//
//  Created by liguangjun on 2019/3/6.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLMessageDetailsHeaderView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "LLMessageListNode.h"

@interface LLMessageDetailsHeaderView ()
<
SDCycleScrollViewDelegate
>

@property (nonatomic, strong) LLMessageListNode *messageListNode;

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *sexImageView;

@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *signLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;

@property (nonatomic, weak) IBOutlet UIView *gridContentView;
@property (nonatomic, strong) SDCycleScrollView *gridImageView;
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
    
    self.gridImageView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 10*2, 225) delegate:self placeholderImage:nil];
    [self.gridContentView addSubview:self.gridImageView];
    self.gridImageView.layer.cornerRadius = 10;
    self.gridImageView.layer.masksToBounds = true;
    self.gridImageView.backgroundColor = kAppThemeColor;
//    self.gridImageView.delegate = self;
    
    self.imagePageView.backgroundColor = kAppMaskOpaqueBlackColor;
    self.imagePageView.layer.cornerRadius = 15;
    self.imagePageView.layer.masksToBounds = true;
    
    self.images = [NSMutableArray array];
}

- (void)updateCellWithData:(id)node {
    self.messageListNode = (LLMessageListNode *)node;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:self.messageListNode.HeadImg] setImage:self.avatarImageView setbitmapImage:nil];
    self.signLabel.text = self.messageListNode.Autograph;
    
    UIImage *sexImage = [UIImage imageNamed:@"user_sex_man"];
    if (self.messageListNode.Sex == 1) {
        sexImage = [UIImage imageNamed:@"user_sex_woman"];
    }
    self.sexImageView.image = sexImage;
    
    self.contentLabel.text = self.messageListNode.Title;
    
    self.timeLabel.text = [WYCommonUtils dateDiscriptionFromNowBk:[WYCommonUtils dateFromUSDateString:self.messageListNode.AddTime]];
    self.distanceLabel.text = [WYCommonUtils distanceFormatWithDistance:self.messageListNode.Distance];
    
    self.images = [NSMutableArray arrayWithArray:self.messageListNode.ImgUrls];
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
    
    [self.readButton setTitle:[NSString stringWithFormat:@" %d", self.messageListNode.LookCount] forState:UIControlStateNormal];
    [self.favourButton setTitle:[NSString stringWithFormat:@" %d", self.messageListNode.GoodCount] forState:UIControlStateNormal];
    
    NSString *commentText = [NSString stringWithFormat:@"评论（%d）",self.messageListNode.CommentCount];
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
