//
//  LLCommodityExchangeconfirmView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/14.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLCommodityExchangeConfirmViewSubmitBlock)(void);

@interface LLCommodityExchangeconfirmView : LLView

@property (nonatomic, strong) LLCommodityExchangeConfirmViewSubmitBlock submitBlock;

- (void)updateCellWithData:(id)node;

@end

NS_ASSUME_NONNULL_END
