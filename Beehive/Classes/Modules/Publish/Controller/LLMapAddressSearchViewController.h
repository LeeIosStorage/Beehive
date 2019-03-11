//
//  LLMapAddressSearchViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/11.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLMapAddressSearchCoordinateBlock) (CLLocationCoordinate2D currentCoordinate, NSString *address);

@interface LLMapAddressSearchViewController : LLBaseViewController

@property (nonatomic, strong) NSString *city;

@property (nonatomic, strong) LLMapAddressSearchCoordinateBlock searchCoordinateBlock;

@end

NS_ASSUME_NONNULL_END
