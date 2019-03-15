//
//  LLRedpacketDetailsHeaderView.h
//  Beehive
//
//  Created by liguangjun on 2019/3/14.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLView.h"
#import "LLSegmentedHeadView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLRedpacketDetailsHeaderViewRedReceiveBlock)(void);
typedef void(^LLRedpacketDetailsHeaderViewAvatarBlock)(void);

@interface LLRedpacketDetailsHeaderView : LLView

@property (nonatomic, weak) IBOutlet LLSegmentedHeadView *segmentedHeadView;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) LLRedpacketDetailsHeaderViewRedReceiveBlock redReceiveBlock;
@property (nonatomic, strong) LLRedpacketDetailsHeaderViewAvatarBlock avatarBlock;

- (void)updateCellWithData:(id)node;

@end

NS_ASSUME_NONNULL_END
