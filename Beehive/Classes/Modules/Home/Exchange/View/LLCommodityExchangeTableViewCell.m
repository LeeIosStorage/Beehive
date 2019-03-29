//
//  LLCommodityExchangeTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/13.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLCommodityExchangeTableViewCell.h"
#import "LLExchangeGoodsNode.h"

@interface LLCommodityExchangeTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labRead;
@property (nonatomic, weak) IBOutlet UILabel *labExchange;
@property (nonatomic, weak) IBOutlet UILabel *labPrice;
@property (nonatomic, weak) IBOutlet UILabel *labBeeCoin;
@property (nonatomic, weak) IBOutlet UILabel *labAddress;

@end

@implementation LLCommodityExchangeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    LLExchangeGoodsNode *goodsNode = (LLExchangeGoodsNode *)node;
    if (goodsNode.ImgUrls.count > 0) {
        NSString *url = goodsNode.ImgUrls[0];
        [WYCommonUtils setImageWithURL:[NSURL URLWithString:url] setImage:self.imgIcon setbitmapImage:nil];
    }
    self.labTitle.text = goodsNode.Name;
    self.labRead.text = [NSString stringWithFormat:@"浏览%d",goodsNode.LookCount];
    self.labAddress.text = goodsNode.Address;
    self.labBeeCoin.text = [NSString stringWithFormat:@"%@蜂蜜",goodsNode.NowPrice];
    self.labExchange.text = [NSString stringWithFormat:@"已兑换%d",goodsNode.ConvertCount];
    
    NSString *oldPrice = [NSString stringWithFormat:@"%@蜂蜜",goodsNode.OldPrice];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:oldPrice attributes:attribtDic];
    self.labPrice.attributedText = attribtStr;
}

@end
