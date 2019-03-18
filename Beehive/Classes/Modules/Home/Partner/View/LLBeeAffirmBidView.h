//
//  LLBeeAffirmBidView.h
//  Beehive
//
//  Created by liguangjun on 2019/3/18.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLBeeAffirmBidViewPayBlock)(NSString *price);

@interface LLBeeAffirmBidView : LLView

@property (nonatomic, strong) LLBeeAffirmBidViewPayBlock payBlock;

- (void)updateViewWithData:(id)node;

@end

NS_ASSUME_NONNULL_END
