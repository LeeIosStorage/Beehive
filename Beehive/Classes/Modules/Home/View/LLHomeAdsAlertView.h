//
//  LLHomeAdsAlertView.h
//  Beehive
//
//  Created by liguangjun on 2019/3/20.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLHomeAdsAlertViewActionBlock)(NSInteger index);

@interface LLHomeAdsAlertView : LLView

@property (nonatomic, weak) IBOutlet UIImageView *adsImageView;

@property (nonatomic, strong) LLHomeAdsAlertViewActionBlock actionBlock;

- (void)updateCellWithData:(id)node;

@end

NS_ASSUME_NONNULL_END
