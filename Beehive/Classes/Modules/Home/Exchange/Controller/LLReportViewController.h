//
//  LLReportViewController.h
//  Beehive
//
//  Created by liguangjun on 2019/3/13.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLReportViewController : LLBaseViewController

@property (nonatomic, strong) NSString *dataId;
@property (nonatomic, assign) NSInteger type;//type 1：商品；2：红包

@end

NS_ASSUME_NONNULL_END
