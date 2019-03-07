//
//  LLCommentBottomView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/7.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^LLCommentBottomViewSendBlock) (void);

@interface LLCommentBottomView : LLView

@property (nonatomic, strong) LLCommentBottomViewSendBlock commentBottomViewSendBlock;

@end

NS_ASSUME_NONNULL_END
