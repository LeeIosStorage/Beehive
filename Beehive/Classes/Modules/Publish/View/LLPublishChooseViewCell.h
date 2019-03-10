//
//  LLPublishChooseViewCell.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/10.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^LLPublishChooseViewCellRefreshBlock) (NSInteger index);

@interface LLPublishChooseViewCell : LLTableViewCell

@property (nonatomic, strong) LLPublishChooseViewCellRefreshBlock refreshBlock;

@end

NS_ASSUME_NONNULL_END
