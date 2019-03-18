//
//  LLBeeKingAuctionHeadView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/18.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeKingAuctionHeadView.h"

@interface LLBeeKingAuctionHeadView ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imgTopConstraintH;

@end

@implementation LLBeeKingAuctionHeadView

- (void)setup {
    [super setup];
    self.imgTopConstraintH.constant = HitoActureHeight(164);
}



@end
