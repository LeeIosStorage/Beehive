//
//  LLBeePresentAffirmView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLBeePresentAffirmViewClickBlock)(NSInteger index);

@interface LLBeePresentAffirmView : LLView

@property (nonatomic, strong) LLBeePresentAffirmViewClickBlock clickBlock;

- (void)updateCellWithData:(id)node;

@end

NS_ASSUME_NONNULL_END
