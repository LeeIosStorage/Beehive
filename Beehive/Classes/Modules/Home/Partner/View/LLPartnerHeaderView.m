//
//  LLPartnerHeaderView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPartnerHeaderView.h"
#import "LLAdvertDetailsNode.h"
#import "UIButton+WebCache.h"

@interface LLPartnerHeaderView ()

@property (nonatomic, strong) LLAdvertDetailsNode *advertDetailsNode;

@property (nonatomic, weak) IBOutlet UIView *partnerContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *sexImageView;
@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *partnerTipLabel;
@property (nonatomic, weak) IBOutlet UILabel *incomeLabel;

@property (nonatomic, weak) IBOutlet UIView *nonPartnerContainerView;
@property (nonatomic, weak) IBOutlet UILabel *nonTipLabel;

@property (nonatomic, weak) IBOutlet UIView *factorContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *adsImageView;
@property (nonatomic, weak) IBOutlet UILabel *adsLabel;
@property (nonatomic, weak) IBOutlet UIView *nonfactorContainerView;

@property (nonatomic, weak) IBOutlet UIView *adsMiddle1ContainerView;
@property (nonatomic, weak) IBOutlet UILabel *adsMiddle1TipLabel;
@property (nonatomic, weak) IBOutlet UILabel *adsMiddle1PriceLabel;
@property (nonatomic, weak) IBOutlet UIButton *adsMiddle1UploadButton;
@property (nonatomic, weak) IBOutlet UIView *nonAdsMiddle1ContainerView;

@property (nonatomic, weak) IBOutlet UIView *adsMiddle2ContainerView;
@property (nonatomic, weak) IBOutlet UILabel *adsMiddle2TipLabel;
@property (nonatomic, weak) IBOutlet UILabel *adsMiddle2PriceLabel;
@property (nonatomic, weak) IBOutlet UIButton *adsMiddle2UploadButton;
@property (nonatomic, weak) IBOutlet UIView *nonAdsMiddle2ContainerView;

@property (nonatomic, weak) IBOutlet UIView *adsBottomContainerView;
@property (nonatomic, weak) IBOutlet UILabel *adsBottomTipLabel;
@property (nonatomic, weak) IBOutlet UILabel *adsBottomPriceLabel;
@property (nonatomic, weak) IBOutlet UIButton *adsBottomUploadButton;
@property (nonatomic, weak) IBOutlet UIView *nonAdsBottomContainerView;

@end

@implementation LLPartnerHeaderView

- (void)setup {
    [super setup];
    self.backgroundColor = kAppSectionBackgroundColor;
}

- (void)updateCellWithData:(id)node {
    self.advertDetailsNode = (LLAdvertDetailsNode *)node;
    
    self.nonTipLabel.backgroundColor = kAppMaskOpaqueBlackColor;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:self.advertDetailsNode.HeadImg] setImage:self.avatarImageView setbitmapImage:nil];
    self.nickNameLabel.text = self.advertDetailsNode.UserName;
    UIImage *sexImage = [UIImage imageNamed:@"user_sex_man"];
    if (self.advertDetailsNode.Sex == 1) {
        sexImage = [UIImage imageNamed:@"user_sex_woman"];
    }
    self.sexImageView.image = sexImage;
    self.partnerTipLabel.text = [NSString stringWithFormat:@"%@蜂王",self.advertDetailsNode.CountyName];
    self.incomeLabel.text = [NSString stringWithFormat:@"%.2f",self.advertDetailsNode.MoneyIncome];
    
    self.partnerContainerView.hidden = true;
    self.nonPartnerContainerView.hidden = false;
    if (self.advertDetailsNode.IsHaveQueenBee) {
        self.partnerContainerView.hidden = false;
        self.nonPartnerContainerView.hidden = true;
    }
    
    self.factorContainerView.hidden = true;
    self.nonfactorContainerView.hidden = false;
    if (self.advertDetailsNode.AdverList.count > 0) {
        LLAdvertNode *adNode = self.advertDetailsNode.AdverList[0];
        if ([adNode.UserId integerValue] > 0) {
            self.factorContainerView.hidden = false;
            self.nonfactorContainerView.hidden = true;
            [WYCommonUtils setImageWithURL:[NSURL URLWithString:adNode.DataImg] setImage:self.adsImageView setbitmapImage:nil];
            self.adsLabel.text = adNode.DataTitle;
        }
    }
    
    self.adsMiddle1ContainerView.hidden = true;
    self.nonAdsMiddle1ContainerView.hidden = false;
    if (self.advertDetailsNode.AdverList.count > 1) {
        LLAdvertNode *adNode = self.advertDetailsNode.AdverList[1];
        self.adsMiddle1PriceLabel.text = [NSString stringWithFormat:@"%.0f/天",adNode.Price];
        if ([adNode.UserId integerValue] > 0) {
            self.adsMiddle1ContainerView.hidden = false;
            self.nonAdsMiddle1ContainerView.hidden = true;
            self.adsMiddle1TipLabel.hidden = false;
            [self.adsMiddle1UploadButton setImage:[UIImage imageNamed:@"1_7_2.3"] forState:UIControlStateNormal];
            if (adNode.DataImg.length > 0) {
                self.adsMiddle1TipLabel.hidden = true;
                [self.adsMiddle1UploadButton sd_setImageWithURL:[NSURL URLWithString:adNode.DataImg] forState:UIControlStateNormal];
            }
        }
    }
    
    self.adsMiddle2ContainerView.hidden = true;
    self.nonAdsMiddle2ContainerView.hidden = false;
    if (self.advertDetailsNode.AdverList.count > 2) {
        LLAdvertNode *adNode = self.advertDetailsNode.AdverList[2];
        self.adsMiddle2PriceLabel.text = [NSString stringWithFormat:@"%.0f/天",adNode.Price];
        if ([adNode.UserId integerValue] > 0) {
            self.adsMiddle2ContainerView.hidden = false;
            self.nonAdsMiddle2ContainerView.hidden = true;
            self.adsMiddle2TipLabel.hidden = false;
            [self.adsMiddle2UploadButton setImage:[UIImage imageNamed:@"1_7_2.3"] forState:UIControlStateNormal];
            if (adNode.DataImg.length > 0) {
                self.adsMiddle1TipLabel.hidden = true;
                [self.adsMiddle2UploadButton sd_setImageWithURL:[NSURL URLWithString:adNode.DataImg] forState:UIControlStateNormal];
            }
        }
    }
    
    self.adsBottomContainerView.hidden = true;
    self.nonAdsBottomContainerView.hidden = false;
    if (self.advertDetailsNode.AdverList.count > 3) {
        LLAdvertNode *adNode = self.advertDetailsNode.AdverList[3];
        self.adsBottomPriceLabel.text = [NSString stringWithFormat:@"%.0f/天",adNode.Price];
        if ([adNode.UserId integerValue] > 0) {
            self.adsBottomContainerView.hidden = false;
            self.nonAdsBottomContainerView.hidden = true;
            self.adsBottomTipLabel.hidden = false;
            [self.adsBottomUploadButton setImage:[UIImage imageNamed:@"1_7_2.3"] forState:UIControlStateNormal];
            if (adNode.DataImg.length > 0) {
                self.adsBottomTipLabel.hidden = true;
                [self.adsBottomUploadButton sd_setImageWithURL:[NSURL URLWithString:adNode.DataImg] forState:UIControlStateNormal];
            }
        }
    }
    
}

- (IBAction)buyAdAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.buyAdBlock) {
        self.buyAdBlock(btn.tag);
    }
}

- (IBAction)uploadAdAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.uploadAdBlock) {
        self.uploadAdBlock(btn.tag);
    }
}

- (IBAction)editAdAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.editAdBlock) {
        self.editAdBlock(btn.tag);
    }
}

@end
