//
//  LLRedTaskShowAlertView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLRedTaskShowAlertViewClickBlock)(void);

@interface LLRedTaskShowAlertView : LLView

@property (nonatomic, strong) LLRedTaskShowAlertViewClickBlock clickBlock;

@end

NS_ASSUME_NONNULL_END
