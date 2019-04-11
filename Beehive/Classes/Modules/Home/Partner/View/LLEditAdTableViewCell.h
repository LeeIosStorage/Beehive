//
//  LLEditAdTableViewCell.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/11.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLEditAdCellEditBlock)(id cell);
typedef void(^LLEditAdCellDeleteBlock)(id cell);

@interface LLEditAdTableViewCell : LLTableViewCell

@property (nonatomic, strong) LLEditAdCellEditBlock editBlock;
@property (nonatomic, strong) LLEditAdCellDeleteBlock deleteBlock;

@end

NS_ASSUME_NONNULL_END
