//
//  LLMineCollectionHeaderView.h
//  Beehive
//
//  Created by liguangjun on 2019/3/7.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LLMineCollectionHeaderViewClickBlock) (NSInteger index);

@interface LLMineCollectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) LLMineCollectionHeaderViewClickBlock headerViewClickBlock;

- (void)updateHeadViewWithData:(id)node;

@end

NS_ASSUME_NONNULL_END
