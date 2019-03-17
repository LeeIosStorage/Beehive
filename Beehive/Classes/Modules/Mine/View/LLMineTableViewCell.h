//
//  LLMineTableViewCell.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLMineCellSwitchBlock)(BOOL on);

@interface LLMineTableViewCell : LLTableViewCell

@property (nonatomic, strong) LLMineCellSwitchBlock switchBlock;

@end

NS_ASSUME_NONNULL_END
