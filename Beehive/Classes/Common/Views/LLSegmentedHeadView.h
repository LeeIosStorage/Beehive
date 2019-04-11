//
//  LLSegmentedHeadView.h
//  Beehive
//
//  Created by liguangjun on 2019/3/5.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

#define kllSegmentedTitle @"title"
#define kllSegmentedType @"type"

typedef void (^LLSegmentedHeadViewBlcok) (NSInteger index);

@interface LLSegmentedHeadView : LLView

@property (nonatomic, strong) LLSegmentedHeadViewBlcok clickBlock;

@property (nonatomic, assign) NSInteger selectIndex;

- (void)setItems:(NSArray *)items;
- (void)updateLabelWithIndex:(NSInteger)index title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
