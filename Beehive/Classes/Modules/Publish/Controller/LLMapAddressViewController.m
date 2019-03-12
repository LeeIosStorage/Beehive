//
//  LLMapAddressViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/11.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMapAddressViewController.h"
#import "LLMapAddressSearchViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "LLMapAddressShowView.h"

@interface LLMapAddressViewController ()
<
MAMapViewDelegate,
AMapSearchDelegate
>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *mapSearch;

@property (nonatomic, strong) UIImageView *centerAnnotationView;
@property (nonatomic, strong) UIButton *locationBtn;
@property (nonatomic, strong) LLMapAddressShowView *mapAddressShowView;
@property (nonatomic, strong) UIButton *affirmButton;

@property (nonatomic, assign) BOOL isLocated;

@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, strong) NSString *currentAddress;
@property (nonatomic, strong) NSString *city;

@end

@implementation LLMapAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"选择地址";
    //3_2_4.1
    [self createBarButtonItemAtPosition:LLNavigationBarPositionRight normalImage:[UIImage imageNamed:@"3_2_4.1"] highlightImage:[UIImage imageNamed:@"3_2_4.1"] text:nil action:@selector(searchAddress)];
    
//    self.currentCoordinate.longitude = 0;
//    self.currentCoordinate.latitude = 0;
    
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [self.mapView addSubview:self.centerAnnotationView];
    [self.centerAnnotationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.mapView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.view addSubview:self.affirmButton];
    [self.affirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.mapAddressShowView];
    [self.mapAddressShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.affirmButton.mas_top).offset(-10);
        make.height.mas_equalTo(80);
    }];
    
    [self.view addSubview:self.locationBtn];
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-5);
        make.bottom.equalTo(self.mapAddressShowView.mas_top).offset(-5);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    self.mapView.zoomLevel = 17;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}


/* 移动窗口弹一下的动画 */
- (void)centerAnnotationAnimimate
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGPoint center = self.centerAnnotationView.center;
                         center.y -= 20;
                         [self.centerAnnotationView setCenter:center];}
                     completion:nil];
    
    [UIView animateWithDuration:0.45
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGPoint center = self.centerAnnotationView.center;
                         center.y += 20;
                         [self.centerAnnotationView setCenter:center];}
                     completion:nil];
}

- (void)getPoiInfoWithCoordinate:(CLLocationCoordinate2D)coordinate {
    [self centerAnnotationAnimimate];
    LELog(@"%f-%f",self.mapView.centerCoordinate.latitude,self.mapView.centerCoordinate.longitude);
    self.currentCoordinate = coordinate;
    self.mapAddressShowView.addressLabel.text = @"加载中...";
    self.mapAddressShowView.addressDesLabel.text = @"加载中...";
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = false;
    [self.mapSearch AMapReGoecodeSearch:regeo];
}

#pragma mark -
#pragma mark - Action
- (void)searchAddress {
    LLMapAddressSearchViewController *vc = [[LLMapAddressSearchViewController alloc] init];
    vc.city = self.city;
    [self.navigationController pushViewController:vc animated:true];
    
    WEAKSELF
    vc.searchCoordinateBlock = ^(CLLocationCoordinate2D currentCoordinate, NSString * _Nonnull address) {
        [weakSelf.mapView setCenterCoordinate:currentCoordinate animated:YES];
        [weakSelf getPoiInfoWithCoordinate:currentCoordinate];
    };
}

- (void)actionLocation
{
    if (self.mapView.userTrackingMode == MAUserTrackingModeFollow) {
        [self.mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];
    } else {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            // 因为下面这句的动画有bug，所以要延迟0.5s执行，动画由上一句产生
            [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        });
    }
}

- (void)affirmAction {
    if (self.currentCoordinate.latitude == 0 || self.currentCoordinate.longitude == 0) {
        [SVProgressHUD showCustomInfoWithStatus:@"请选择地址"];
        return;
    }
    if (self.chooseCoordinateBlock) {
        self.chooseCoordinateBlock(self.currentCoordinate, self.currentAddress);
    }
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - setget
- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] init];
        _mapView.delegate = self;
        self.isLocated = NO;
    }
    return _mapView;
}

- (AMapSearchAPI *)mapSearch {
    if (!_mapSearch) {
        _mapSearch = [[AMapSearchAPI alloc] init];
        _mapSearch.delegate = self;
    }
    return _mapSearch;
}

- (UIImageView *)centerAnnotationView {
    if (!_centerAnnotationView) {
        _centerAnnotationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3_2_4.2"]];
    }
    return _centerAnnotationView;
}

- (UIButton *)locationBtn {
    if (!_locationBtn) {
        _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationBtn setImage:[UIImage imageNamed:@"3_2_4.3"] forState:UIControlStateNormal];
        [_locationBtn addTarget:self action:@selector(actionLocation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _locationBtn;
}

- (LLMapAddressShowView *)mapAddressShowView {
    if (!_mapAddressShowView) {
        _mapAddressShowView = [[[NSBundle mainBundle] loadNibNamed:@"LLMapAddressShowView" owner:self options:nil] firstObject];
        _mapAddressShowView.layer.cornerRadius = 3;
        _mapAddressShowView.layer.masksToBounds = true;
    }
    return _mapAddressShowView;
}

- (UIButton *)affirmButton {
    if (!_affirmButton) {
        _affirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_affirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_affirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _affirmButton.backgroundColor = kAppThemeColor;
        [_affirmButton.titleLabel setFont:[FontConst PingFangSCRegularWithSize:14]];
        _affirmButton.layer.cornerRadius = 3;
        _affirmButton.layer.masksToBounds = true;
        [_affirmButton addTarget:self action:@selector(affirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _affirmButton;
}

#pragma mark - MapViewDelegate
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.mapView.userTrackingMode == MAUserTrackingModeNone) {
        [self getPoiInfoWithCoordinate:self.mapView.centerCoordinate];
    }
}

#pragma mark - userLocation
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(!updatingLocation)
        return ;
    
    if (userLocation.location.horizontalAccuracy < 0)
    {
        return ;
    }
    
    // only the first locate used.
    if (!self.isLocated)
    {
        self.isLocated = YES;
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
        
//        [self actionSearchAroundAt:userLocation.location.coordinate];
    }
}

- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    if (mode == MAUserTrackingModeNone){
        
    } else {
        
    }
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"error = %@",error);
}

#pragma mark - AMapSearchDelegate
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
        NSString *formattedAddress = response.regeocode.formattedAddress;
        AMapAddressComponent *addressComponent = response.regeocode.addressComponent;
        self.mapAddressShowView.addressLabel.text = formattedAddress;
        NSString *addressDes = [NSString stringWithFormat:@"%@ %@",addressComponent.streetNumber.street, addressComponent.streetNumber.number];
        self.mapAddressShowView.addressDesLabel.text = addressDes;
        self.currentAddress = formattedAddress;
        self.city = addressComponent.city;
    }
}

@end
