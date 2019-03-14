//
//  LLExchangeDetailsHeaderView.m
//  Beehive
//
//  Created by liguangjun on 2019/3/13.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLExchangeDetailsHeaderView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface LLExchangeDetailsHeaderView ()
<
SDCycleScrollViewDelegate
>

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

@property (nonatomic, weak) IBOutlet SDCycleScrollView *gridImageView;
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
    
    self.gridImageView.layer.cornerRadius = 2;
    self.gridImageView.layer.masksToBounds = true;
    
    self.gridImageView.backgroundColor = kAppThemeColor;
    self.gridImageView.delegate = self;
    
    self.imagePageView.backgroundColor = kAppMaskOpaqueBlackColor;
    self.imagePageView.layer.cornerRadius = 15;
    self.imagePageView.layer.masksToBounds = true;
    
    self.images = [NSMutableArray array];
}

- (IBAction)callTelAction:(id)sender {
    [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://10086"]];
}

- (void)updateCellWithData:(id)node {
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.avatarImageView setbitmapImage:nil];
    self.signLabel.text = @"个性签名吧";
    self.exchangeInfoLabel.text = @"1哈哈哈哈哈哈哈哈哈哈哈哈哈哈\n2哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈\n3哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
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
    
    self.labTitle.text = @"11";
    self.labRead.text = @"11";
    self.labAddress.text = @"11";
    self.labBeeCoin.text = @"11";
    self.labExchange.text = @"11";
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"¥ 40.00" attributes:attribtDic];
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
