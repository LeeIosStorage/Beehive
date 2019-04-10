//
//  LLBeeKingUserShowView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/10.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLBeeKingUserClickBlock)(void);

@interface LLBeeKingUserShowView : LLView

@property (nonatomic, strong) LLBeeKingUserClickBlock clickBlock;

- (void)updateCellWithData:(id)node;

@end

NS_ASSUME_NONNULL_END
