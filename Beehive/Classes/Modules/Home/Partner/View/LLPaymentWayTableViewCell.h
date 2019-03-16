//
//  LLPaymentWayTableViewCell.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLPaymentWayTableViewCell : LLTableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *typeImageView;

@property (nonatomic, weak) IBOutlet UIButton *btnRecharge;

@end

NS_ASSUME_NONNULL_END
