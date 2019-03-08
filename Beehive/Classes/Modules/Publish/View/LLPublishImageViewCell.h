//
//  LLPublishImageViewCell.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/8.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^LLPublishImageViewCellUpdateHeightBlock) (void);

@interface LLPublishImageViewCell : LLTableViewCell

@property (nonatomic, strong) LLPublishImageViewCellUpdateHeightBlock cellUpdateHeightBlock;

@end

NS_ASSUME_NONNULL_END
