//
//  LLBeeLobbyHeaderView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/18.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLBeeLobbyHeaderViewBeeKingBlock)(void);
typedef void(^LLBeeLobbyHeaderViewHandleBlock)(NSInteger index);

@interface LLBeeLobbyHeaderView : LLView

@property (nonatomic, strong) LLBeeLobbyHeaderViewBeeKingBlock beeKingBlock;
@property (nonatomic, strong) LLBeeLobbyHeaderViewHandleBlock handleBlock;

- (void)updateHeadViewWithData:(id)node;

@end

NS_ASSUME_NONNULL_END
