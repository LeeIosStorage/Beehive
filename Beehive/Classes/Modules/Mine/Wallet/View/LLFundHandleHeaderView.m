//
//  LLFundHandleHeaderView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLFundHandleHeaderView.h"

@interface LLFundHandleHeaderView ()

@property (nonatomic, strong) IBOutlet UILabel *labExplain;

@end

@implementation LLFundHandleHeaderView

- (void)setup {
    [super setup];
}

- (void)updateCellWithData:(id)node {
    self.labExplain.text = @"1. 提现说明提现说明提现说明提现说明。 \n2.提现说明提现说明提现说明提现说明提现说明提现说明。";
}

@end
