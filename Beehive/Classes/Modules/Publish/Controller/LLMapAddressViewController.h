//
//  LLMapAddressViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/11.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLMapAddressChooseCoordinateBlock) (CLLocationCoordinate2D currentCoordinate, NSString *address);

@interface LLMapAddressViewController : LLBaseViewController

@property (nonatomic, copy) LLMapAddressChooseCoordinateBlock chooseCoordinateBlock;

@end

NS_ASSUME_NONNULL_END
