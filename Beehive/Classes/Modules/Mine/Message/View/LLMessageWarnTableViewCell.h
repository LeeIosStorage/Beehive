//
//  LLMessageWarnTableViewCell.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/13.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLTableViewCell.h"
#import "LLBadgeNumberView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLMessageWarnTableViewCell : LLTableViewCell

@property (nonatomic, weak) IBOutlet LLBadgeNumberView *badgeNumberView;

@end

NS_ASSUME_NONNULL_END
