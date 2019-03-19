//
//  LEFeedbackViewController.h
//  XWAPP
//
//  Created by hys on 2018/6/25.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LLBaseViewController.h"

typedef NS_ENUM(NSInteger, LLFillInfoVcType) {
    LLFillInfoVcTypeNone, //意见反馈
    LLFillInfoVcTypeSign  //个人签名
};

typedef void(^LLFillInfoVcSubmitBlock)(NSString *text);

@interface LEFeedbackViewController : LLBaseViewController

@property (nonatomic, assign) LLFillInfoVcType vcType;

@property (nonatomic, copy) LLFillInfoVcSubmitBlock submitBlock;

@end
