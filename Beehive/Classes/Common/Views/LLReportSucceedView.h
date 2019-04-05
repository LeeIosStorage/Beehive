//
//  LLReportSucceedView.h
//  Beehive
//
//  Created by liguangjun on 2019/3/13.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLReportSucceedViewCloseBlock)(void);

@interface LLReportSucceedView : LLView

@property (nonatomic, strong) LLReportSucceedViewCloseBlock closeBlock;

@end

NS_ASSUME_NONNULL_END
