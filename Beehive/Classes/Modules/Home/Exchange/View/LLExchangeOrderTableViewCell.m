//
//  LLExchangeOrderTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLExchangeOrderTableViewCell.h"
#import "LLExchangeOrderNode.h"

@interface LLExchangeOrderTableViewCell ()

@property (nonatomic, strong) LLExchangeOrderNode *exchangeOrderNode;
@property (nonatomic, weak) IBOutlet UIImageView *imgAvatar;
@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;
@property (nonatomic, weak) IBOutlet UIImageView *imgSex;
@property (nonatomic, weak) IBOutlet UILabel *labNickName;

@property (nonatomic, weak) IBOutlet UILabel *labShopName;
@property (nonatomic, weak) IBOutlet UILabel *labShopTipName;

@property (nonatomic, weak) IBOutlet UILabel *labAddress;

@property (nonatomic, weak) IBOutlet UILabel *labExchangeType;
@property (nonatomic, weak) IBOutlet UILabel *labExchangePhone;
@property (nonatomic, weak) IBOutlet UILabel *labExchangeDate;

@end

@implementation LLExchangeOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)callTelAction:(id)sender {
    [WYCommonUtils callTelephone:self.exchangeOrderNode.Phone];
}

- (void)updateCellWithData:(id)node {
    LLExchangeOrderNode *someNode = (LLExchangeOrderNode *)node;
    self.exchangeOrderNode = someNode;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:someNode.HeadImg] setImage:self.imgAvatar setbitmapImage:nil];
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:someNode.GoodsImg] setImage:self.imgIcon setbitmapImage:nil];
    UIImage *sexImage = [UIImage imageNamed:@"user_sex_man"];
    if (someNode.Sex == 1) {
        sexImage = [UIImage imageNamed:@"user_sex_woman"];
    }
    self.imgSex.image = sexImage;
    self.labNickName.text = someNode.UserName;
    
    self.labShopName.text = someNode.GoodsName;
    self.labShopTipName.text = [NSString stringWithFormat:@"实付%@蜂蜜",someNode.Money];
    
    NSString *buyType = @"";
    if (someNode.BuyType == 1) {
        buyType = @"电子券";
    }
    self.labExchangeType.text = [NSString stringWithFormat:@"兑换类型：%@", buyType];
    self.labExchangePhone.text = [NSString stringWithFormat:@"商家电话：%@", someNode.Phone];
    self.labExchangeDate.text = [NSString stringWithFormat:@"兑换时间：%@", someNode.AddTime];
    
    self.labAddress.text = someNode.Address;
}

@end
