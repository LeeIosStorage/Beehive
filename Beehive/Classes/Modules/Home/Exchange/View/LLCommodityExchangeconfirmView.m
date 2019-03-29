//
//  LLCommodityExchangeconfirmView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/14.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLCommodityExchangeconfirmView.h"
#import "LLExchangeGoodsNode.h"

@interface LLCommodityExchangeconfirmView ()

@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labPrice;
@property (nonatomic, weak) IBOutlet UILabel *labBeeCoin;
@property (nonatomic, weak) IBOutlet UILabel *labQuanPrice;
@property (nonatomic, weak) IBOutlet UILabel *labTime;
@property (nonatomic, weak) IBOutlet UILabel *labValidity;
@property (nonatomic, weak) IBOutlet UILabel *labFull;
@property (nonatomic, weak) IBOutlet UILabel *labScope;
@property (nonatomic, weak) IBOutlet UIButton *btnSubmit;

@end

@implementation LLCommodityExchangeconfirmView

- (void)setup {
    [super setup];
    self.imgIcon.layer.cornerRadius = 3;
    self.imgIcon.layer.masksToBounds = true;
}

- (void)updateCellWithData:(id)node {
    LLExchangeGoodsNode *goodsNode = (LLExchangeGoodsNode *)node;
    
    NSString *url = @"";
    if (goodsNode.ImgUrls.count) {
        url = goodsNode.ImgUrls[0];
    }
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:url] setImage:self.imgIcon setbitmapImage:nil];
    
    self.labTitle.text = goodsNode.Name;
    self.labBeeCoin.text = [NSString stringWithFormat:@"%@蜂蜜",goodsNode.NowPrice];
    
    self.labQuanPrice.text = [NSString stringWithFormat:@"¥ %@",goodsNode.CashPrice];
    self.labFull.text = goodsNode.CouponName;
    self.labScope.text = goodsNode.CouponExplain;
    self.labTime.text = goodsNode.CashTime;
    self.labValidity.text = [NSString stringWithFormat:@"有效期%ld天",goodsNode.Days];
    
    [self.btnSubmit setTitle:[NSString stringWithFormat:@"支付%@蜂蜜兑换",goodsNode.NowPrice] forState:UIControlStateNormal];
    
    NSString *oldPrice = [NSString stringWithFormat:@"%@蜂蜜",goodsNode.OldPrice];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldPrice attributes:attribtDic];
    self.labPrice.attributedText = attribtStr;
}

- (IBAction)submitAction:(id)sender {
    if (self.submitBlock) {
        self.submitBlock();
    }
}

@end
