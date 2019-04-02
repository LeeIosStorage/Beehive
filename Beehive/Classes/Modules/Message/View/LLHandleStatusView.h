//
//  LLHandleStatusView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/6.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLHandleStatusView : LLView

@property (nonatomic, strong) UIButton *readButton;

@property (nonatomic, strong) UIButton *commentButton;

@property (nonatomic, strong) UIButton *favourButton;

- (void)updateWithData:(id)node;

@end

NS_ASSUME_NONNULL_END
