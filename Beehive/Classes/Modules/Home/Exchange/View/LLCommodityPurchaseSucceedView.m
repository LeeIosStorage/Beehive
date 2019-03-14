//
//  LLCommodityPurchaseSucceedView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/14.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLCommodityPurchaseSucceedView.h"

@implementation LLCommodityPurchaseSucceedView

- (void)setup {
    [super setup];
    self.backgroundColor = [UIColor clearColor];
}

- (IBAction)backAction:(id)sender {
    if (self.clickBlock) {
        self.clickBlock(0);
    }
}

- (IBAction)orderAction:(id)sender {
    if (self.clickBlock) {
        self.clickBlock(1);
    }
}

@end
