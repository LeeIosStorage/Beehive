//
//  LLReceiveRedAlertView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/14.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLReceiveRedAlertViewClickBlock)(NSInteger index);

@interface LLReceiveRedAlertView : LLView

@property (nonatomic, strong) LLReceiveRedAlertViewClickBlock clickBlock;

- (void)updateCellWithData:(id)node;

@end

NS_ASSUME_NONNULL_END
