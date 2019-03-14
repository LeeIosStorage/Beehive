//
//  LLCommodityExchangeconfirmView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/14.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLCommodityExchangeconfirmView.h"

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
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.imgIcon setbitmapImage:nil];
    self.labTitle.text = @"11";
    self.labTime.text = @"11";
    self.labBeeCoin.text = @"11";
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"¥ 40.00" attributes:attribtDic];
    self.labPrice.attributedText = attribtStr;
}

- (IBAction)submitAction:(id)sender {
    if (self.submitBlock) {
        self.submitBlock();
    }
}

@end
