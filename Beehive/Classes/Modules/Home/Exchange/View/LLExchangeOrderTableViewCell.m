//
//  LLExchangeOrderTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLExchangeOrderTableViewCell.h"

@interface LLExchangeOrderTableViewCell ()

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
    [WYCommonUtils callTelephone:@"10086"];
}

- (void)updateCellWithData:(id)node {
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.imgAvatar setbitmapImage:nil];
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.imgIcon setbitmapImage:nil];
    
//    self.labNickName.text = @"11";
}

@end
