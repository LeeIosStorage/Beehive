//
//  LLCityOptionHeaderView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/3.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLCityOptionHeaderViewSelectBlock)(id node);

@interface LLCityOptionHeaderView : LLView

@property (nonatomic, strong) NSMutableArray *redCityArray;

@property (nonatomic, strong) LLCityOptionHeaderViewSelectBlock selectBlock;

@end

NS_ASSUME_NONNULL_END
