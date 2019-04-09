//
//  LLBeeTaskTableViewCell.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLBeeTaskTableViewCell : LLTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labDes;
@property (nonatomic, weak) IBOutlet UILabel *labCount;
@property (nonatomic, weak) IBOutlet UIButton *btnTask;

@end

NS_ASSUME_NONNULL_END
