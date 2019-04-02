//
//  LLCommentBottomView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/7.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^LLCommentBottomViewHandleBlock) (NSInteger index);
typedef void (^LLCommentBottomViewSendBlock) (NSString *commentText);

@interface LLCommentBottomView : LLView

@property (nonatomic, strong) LLCommentBottomViewHandleBlock commentBottomViewHandleBlock;
@property (nonatomic, strong) LLCommentBottomViewSendBlock commentBottomViewSendBlock;

@property (nonatomic, strong) UIButton *btnShare;
@property (nonatomic, strong) UIButton *btnLike;
@property (nonatomic, strong) UIButton *btnCollect;

@property (nonatomic, strong) UITextField *textField;

@end

NS_ASSUME_NONNULL_END
