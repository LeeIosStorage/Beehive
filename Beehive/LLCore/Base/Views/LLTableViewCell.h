//
//  LLTableViewCell.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/3.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLTableViewCell : UITableViewCell

@property (nonatomic, strong) id node;

- (void)updateCellWithData:(id)node;

@end

NS_ASSUME_NONNULL_END
