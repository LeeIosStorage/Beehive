//
//  LLRedTaskShowAlertView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLRedTaskShowAlertView.h"

@implementation LLRedTaskShowAlertView

- (void)setup {
    [super setup];
    self.backgroundColor = UIColor.clearColor;
}

- (IBAction)clickAction:(id)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
