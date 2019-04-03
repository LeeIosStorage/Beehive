//
//  LLMessageTimeLineViewCell.h
//  Beehive
//
//  Created by liguangjun on 2019/3/5.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLMessageTimeLineViewCellAvatarBlock)(id cell);

@interface LLMessageTimeLineViewCell : LLTableViewCell

@property (nonatomic, copy) LLMessageTimeLineViewCellAvatarBlock avatarBlock;

@end

NS_ASSUME_NONNULL_END
