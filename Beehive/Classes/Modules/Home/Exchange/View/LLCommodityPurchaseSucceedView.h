//
//  LLCommodityPurchaseSucceedView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/14.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLCommodityPurchaseSucceedViewClickBlock)(NSInteger index);

@interface LLCommodityPurchaseSucceedView : LLView

@property (nonatomic, strong) LLCommodityPurchaseSucceedViewClickBlock clickBlock;

@end

NS_ASSUME_NONNULL_END
