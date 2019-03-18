//
//  LLBeeAffirmBidView.m
//  Beehive
//
//  Created by liguangjun on 2019/3/18.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLBeeAffirmBidView.h"

@interface LLBeeAffirmBidView ()

@property (nonatomic, weak) IBOutlet UILabel *labPrice;
@property (nonatomic, weak) IBOutlet UITextField *textField;

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
    NSString *price = @"100";
    NSString *priceText = [NSString stringWithFormat:@"¥ %@ (10天)",price];
    self.labPrice.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:priceText range:NSMakeRange(2, price.length) font:[FontConst PingFangSCRegularWithSize:20] color:kAppThemeColor];
}

@end
