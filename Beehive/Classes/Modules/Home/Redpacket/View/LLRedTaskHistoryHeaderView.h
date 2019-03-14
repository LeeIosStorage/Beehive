//
//  LLRedTaskHistoryHeaderView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/14.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLRedTaskHistoryHeaderView : LLView

@property (nonatomic, weak) IBOutlet UILabel *labTotalAmount;
@property (nonatomic, weak) IBOutlet UILabel *labTotalType;
@property (nonatomic, weak) IBOutlet UILabel *labTotalTip;

@property (nonatomic, weak) IBOutlet UILabel *labDayAmount;
@property (nonatomic, weak) IBOutlet UILabel *labDayType;
@property (nonatomic, weak) IBOutlet UILabel *labDayTip;

@end

NS_ASSUME_NONNULL_END
