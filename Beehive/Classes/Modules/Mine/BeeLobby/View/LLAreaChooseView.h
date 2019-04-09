//
//  LLAreaChooseView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/9.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"
#import "LLHomeNode.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLAreaChooseViewBlock)(LLHomeNode *areaNode);

@interface LLAreaChooseView : LLView

@property (nonatomic, strong) LLHomeNode *areaNode;

@property (nonatomic, copy) LLAreaChooseViewBlock chooseBlock;

- (void)refreshUI;

@end

NS_ASSUME_NONNULL_END
