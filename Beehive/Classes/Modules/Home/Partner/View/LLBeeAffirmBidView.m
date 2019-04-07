//
//  LLBeeAffirmBidView.m
//  Beehive
//
//  Created by liguangjun on 2019/3/18.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLBeeAffirmBidView.h"
#import "LLBeeKingNode.h"

@interface LLBeeAffirmBidView ()

@property (nonatomic, strong) LLBeeKingNode *beeKingNode;

@property (nonatomic, weak) IBOutlet UILabel *labPrice;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UILabel *labTipDes;

@end

@implementation LLBeeAffirmBidView

- (void)setup {
    [super setup];
}

- (IBAction)payAction:(id)sender {
    if (self.payBlock) {
        self.payBlock(self.textField.text);
    }
}

- (void)updateViewWithData:(id)node {
    self.beeKingNode = (LLBeeKingNode *)node;
    
    NSString *price = [NSString stringWithFormat:@"%.0f",self.beeKingNode.StartPrice];
    NSString *priceText = [NSString stringWithFormat:@"¥ %@ (%d天)",price, self.beeKingNode.Days];
    self.labPrice.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:priceText range:NSMakeRange(2, price.length) font:[FontConst PingFangSCRegularWithSize:20] color:kAppThemeColor];
    self.textField.placeholder = [NSString stringWithFormat:@"¥ %@起",price];
    self.labTipDes.text = [NSString stringWithFormat:@"竞拍价格不能低于%@元低价，价高者得！", price];
}

@end
