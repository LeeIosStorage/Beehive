//
//  LLAddShopAddressViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/10.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"
#import "LLPublishCellNode.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLAddShopAddressViewControllerBlock)(LLPublishCellNode * shopAddressNode);

@interface LLAddShopAddressViewController : LLBaseViewController

@property (nonatomic, strong) LLAddShopAddressViewControllerBlock addShopAddressBlock;

@end

NS_ASSUME_NONNULL_END
