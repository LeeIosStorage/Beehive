//
//  LLPaymentWayView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLPaymentWayViewPaymentBlock)(NSInteger type);

@interface LLPaymentWayView : LLView

@property (nonatomic, strong) LLPaymentWayViewPaymentBlock paymentBlock;

- (void)updateCellWithData:(id)node;

@end

NS_ASSUME_NONNULL_END
