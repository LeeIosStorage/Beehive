//
//  LLChooseLocationViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/10.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLChooseLocationCoordinateBlock) (CLLocationCoordinate2D currentCoordinate, NSString *address, NSInteger radiusType);

@interface LLChooseLocationViewController : LLBaseViewController

@property (nonatomic, copy) LLChooseLocationCoordinateBlock chooseLocationCoordinateBlock;

@end

NS_ASSUME_NONNULL_END
