//
//  LEPublishMenuView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/4.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^LEPublishMenuViewBlcok) (NSInteger index);

@interface LEPublishMenuView : LLView

- (instancetype)initWithActionBlock:(LEPublishMenuViewBlcok)actionBlock;

- (void)showInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
