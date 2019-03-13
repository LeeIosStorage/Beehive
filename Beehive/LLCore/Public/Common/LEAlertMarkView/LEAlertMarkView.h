//
//  LEAlertMarkView.h
//  Beehive
//
//  Created by liguangjun on 2019/3/13.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LEAlertMarkView : UIView

- (instancetype)initWithCustomView:(UIView *)customView;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
