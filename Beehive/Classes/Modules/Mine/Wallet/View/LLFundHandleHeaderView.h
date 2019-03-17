//
//  LLFundHandleHeaderView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"
#import "LLWithdrawViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLFundHandleHeaderView : LLView

@property (nonatomic, assign) LLFundHandleVCType vcType;

- (void)updateCellWithData:(id)node;

@end

NS_ASSUME_NONNULL_END
