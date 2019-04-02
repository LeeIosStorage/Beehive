//
//  LLLocationManager.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/2.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLLocationManager.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface LLLocationManager ()
<
AMapLocationManagerDelegate
>
@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation LLLocationManager

static LLLocationManager *_instance = nil;
+ (LLLocationManager *)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)login {
    
}
- (void)logout {
    
}

#pragma mark - SetAndGet
- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 200;
    }
    return _locationManager;
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    self.currentCoordinate = location.coordinate;
}

@end
