//
//  LLMessageCommentViewCell.h
//  Beehive
//
//  Created by liguangjun on 2019/3/6.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLCommentViewCellAdoptAnswerBlock)(id cell);

@interface LLMessageCommentViewCell : LLTableViewCell

@property (nonatomic, copy) LLCommentViewCellAdoptAnswerBlock adoptAnswerBlock;

@end

NS_ASSUME_NONNULL_END
