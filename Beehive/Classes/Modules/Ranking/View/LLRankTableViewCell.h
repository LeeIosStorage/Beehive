//
//  LLRankTableViewCell.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/7.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLRankTableViewCell : LLTableViewCell

@property (nonatomic, assign) NSInteger type; //0：收益排行；1：粉丝排行

@end

NS_ASSUME_NONNULL_END
