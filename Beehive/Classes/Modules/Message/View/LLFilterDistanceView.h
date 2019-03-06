//
//  LLFilterDistanceView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/6.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLFilterDistanceView : LLView

@property (nonatomic, assign) NSInteger selectIndex;

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
