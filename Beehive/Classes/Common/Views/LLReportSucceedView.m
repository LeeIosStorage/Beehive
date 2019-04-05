//
//  LLReportSucceedView.m
//  Beehive
//
//  Created by liguangjun on 2019/3/13.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLReportSucceedView.h"

@implementation LLReportSucceedView

- (void)setup {
    [super setup];
}

- (IBAction)closeAction:(id)sender {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
