//
//  LLRedReceiveUserTableViewCell.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLRedReceiveUserTableViewCell : LLTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;

- (void)updateUserCellWithData:(id)node;

@end

NS_ASSUME_NONNULL_END
