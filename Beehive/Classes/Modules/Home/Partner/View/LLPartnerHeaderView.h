//
//  LLPartnerHeaderView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLPartnerHeaderViewUploadAdBlock)(NSInteger index);
typedef void(^LLPartnerHeaderViewEditAdBlock)(NSInteger index);
typedef void(^LLPartnerHeaderViewBuyAdBlock)(NSInteger index);

@interface LLPartnerHeaderView : LLView

@property (nonatomic, strong) LLPartnerHeaderViewBuyAdBlock buyAdBlock;
@property (nonatomic, strong) LLPartnerHeaderViewUploadAdBlock uploadAdBlock;
@property (nonatomic, strong) LLPartnerHeaderViewEditAdBlock editAdBlock;

- (void)updateCellWithData:(id)node;

@end

NS_ASSUME_NONNULL_END
