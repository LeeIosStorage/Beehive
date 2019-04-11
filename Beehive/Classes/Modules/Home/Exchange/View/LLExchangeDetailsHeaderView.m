//
//  LLExchangeDetailsHeaderView.m
//  Beehive
//
//  Created by liguangjun on 2019/3/13.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLExchangeDetailsHeaderView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "LLExchangeGoodsNode.h"

@interface LLExchangeDetailsHeaderView ()
<
SDCycleScrollViewDelegate
>

@property (nonatomic, strong) LLExchangeGoodsNode *goodsNode;

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *sexImageView;

@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *signLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labRead;
@property (nonatomic, weak) IBOutlet UILabel *labExchange;
@property (nonatomic, weak) IBOutlet UILabel *labPrice;
@property (nonatomic, weak) IBOutlet UILabel *labBeeCoin;

@property (nonatomic, weak) IBOutlet UIView *gridContentView;
@property (nonatomic, strong) SDCycleScrollView *gridImageView;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *gridImageViewConstraintH;
@property (nonatomic, weak) IBOutlet UIView *imagePageView;
@property (nonatomic, weak) IBOutlet UILabel *imagePageLabel;

@property (nonatomic, weak) IBOutlet UILabel *labAddress;
@property (nonatomic, strong) IBOutlet UIButton *phoneButton;

@property (nonatomic, weak) IBOutlet UILabel *exchangeInfoLabel;

@end

@implementation LLExchangeDetailsHeaderView

- (void)setup {
    [super setup];
    self.avatarImageView.layer.cornerRadius = 22.5;
    self.avatarImageView.layer.masksToBounds = true;
    
    self.gridImageView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 10*2, 225) delegate:self placeholderImage:nil];
    [self.gridContentView addSubview:self.gridImageView];
    self.gridImageView.layer.cornerRadius = 2;
    self.gridImageView.layer.masksToBounds = true;
    self.gridImageView.backgroundColor = kAppThemeColor;
    self.gridImageView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//    self.gridImageView.delegate = self;
    
    self.imagePageView.backgroundColor = kAppMaskOpaqueBlackColor;
    self.imagePageView.layer.cornerRadius = 15;
    self.imagePageView.layer.masksToBounds = true;
    
    self.images = [NSMutableArray array];
}

- (IBAction)callTelAction:(id)sender {
    [WYCommonUtils callTelephone:self.goodsNode.Phone];
}

- (void)updateCellWithData:(id)node {
    self.goodsNode = (LLExchangeGoodsNode *)node;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:self.goodsNode.HeadImg] setImage:self.avatarImageView setbitmapImage:nil];
    self.signLabel.text = self.goodsNode.Autograph;
    self.exchangeInfoLabel.text = self.goodsNode.ConvertExplain;
    self.timeLabel.text = self.goodsNode.ReleaseTime;
    
    UIImage *sexImage = [UIImage imageNamed:@"user_sex_man"];
    if (self.goodsNode.Sex == 1) {
        sexImage = [UIImage imageNamed:@"user_sex_woman"];
    }
    self.sexImageView.image = sexImage;
    
    self.images = [NSMutableArray arrayWithArray:self.goodsNode.ImgUrls];
    if (self.images.count > 0) {
        self.gridImageViewConstraintH.constant = 225;
        self.gridContentView.hidden = false;
        [self.imagePageView setHidden:false];
    } else {
        self.gridImageViewConstraintH.constant = 0;
        self.gridContentView.hidden = true;
        [self.imagePageView setHidden:true];
    }
    self.gridImageView.showPageControl = false;
    self.gridImageView.imageURLStringsGroup = self.images;
    
    self.imagePageLabel.text = [NSString stringWithFormat:@"%d/%ld",1,self.images.count];
    
    self.labTitle.text = self.goodsNode.Name;
    self.labRead.text = [NSString stringWithFormat:@"浏览%d",self.goodsNode.LookCount];
    self.labAddress.text = self.goodsNode.Address;
    self.labBeeCoin.text = [NSString stringWithFormat:@"%@蜂蜜",self.goodsNode.NowPrice];
    self.labExchange.text = [NSString stringWithFormat:@"已兑换%d",self.goodsNode.ConvertCount];
    
    NSString *oldPrice = [NSString stringWithFormat:@"%@蜂蜜",self.goodsNode.OldPrice];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldPrice attributes:attribtDic];
    self.labPrice.attributedText = attribtStr;
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
