//
//  LLExchangeDetailsBottomView.m
//  Beehive
//
//  Created by liguangjun on 2019/3/13.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLExchangeDetailsBottomView.h"

@implementation LLExchangeDetailsBottomView

- (void)setup {
    [super setup];
}

- (IBAction)shareAction:(id)sender {
    if (self.clickBlock) {
        self.clickBlock(0);
    }
}

- (IBAction)collectAction:(id)sender {
    if (self.clickBlock) {
        self.clickBlock(1);
    }
}

- (IBAction)exchangeAction:(id)sender {
    if (self.clickBlock) {
        self.clickBlock(2);
    }
}

@end
