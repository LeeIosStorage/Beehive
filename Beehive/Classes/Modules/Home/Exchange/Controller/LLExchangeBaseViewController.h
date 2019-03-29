//
//  LLExchangeBaseViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/13.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LLExchangeBaseViewControllerDelegate <NSObject>

- (void)refreshExchangeBanners:(NSArray *)banners;

@end

@interface LLExchangeBaseViewController : LLBaseViewController

@property (nonatomic, weak) id <LLExchangeBaseViewControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger vcType;

@end

NS_ASSUME_NONNULL_END
