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

typedef void(^LLFundHandleBindWXBlock)(BOOL needBind);
typedef void(^LLFundHandleChooseAmountBlock)(NSString *money);
typedef void(^LLFundHandleAffirmBlock)(void);

@interface LLFundHandleHeaderView : LLView

@property (nonatomic, assign) LLFundHandleVCType vcType;

@property (nonatomic, strong) LLFundHandleBindWXBlock bindWXBlock;
@property (nonatomic, strong) LLFundHandleChooseAmountBlock chooseAmountBlock;
@property (nonatomic, strong) LLFundHandleAffirmBlock affirmBlock;

- (void)updateCellWithData:(id)node;

@end

NS_ASSUME_NONNULL_END
