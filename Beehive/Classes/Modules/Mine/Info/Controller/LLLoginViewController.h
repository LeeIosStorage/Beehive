//
//  LLLoginViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/2.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LELoginSuccessBlock)(void);
typedef void(^LELoginFailureBlock)(NSString *errorMessage);
typedef void(^LELoginCancelBlock)(void);

@interface LLLoginViewController : LLBaseViewController

@property (nonatomic, copy) LELoginSuccessBlock loginSuccessBlock;
@property (nonatomic, copy) LELoginCancelBlock loginCancelBlock;
@property (nonatomic, copy) LELoginFailureBlock loginFailureBlock;

@end

NS_ASSUME_NONNULL_END
