//
//  LLExchangeDetailsBottomView.h
//  Beehive
//
//  Created by liguangjun on 2019/3/13.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLExchangeDetailsBottomViewClickBlock)(NSInteger index);

@interface LLExchangeDetailsBottomView : LLView

@property (nonatomic, weak) IBOutlet UIButton *collectionButton;

@property (nonatomic, strong) LLExchangeDetailsBottomViewClickBlock clickBlock;

@end

NS_ASSUME_NONNULL_END
