//
//  LLChooseLocationViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/10.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLChooseLocationViewController.h"
#import "LLChooseLocationScopeView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "ZJUsefulPickerView.h"

@interface LLChooseLocationViewController ()
<
MAMapViewDelegate,
AMapSearchDelegate,
AMapGeoFenceManagerDelegate
>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *mapSearch;
@property (nonatomic, strong) AMapGeoFenceManager *geoFenceManager; //地理围栏

@property (nonatomic, strong) LLChooseLocationScopeView *chooseLocationScopeView;

@property (nonatomic, strong) UIButton *affirmButton;

@property (nonatomic, strong) UIImageView *centerAnnotationView;

@property (nonatomic, assign) BOOL isLocated;

@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, strong) NSString *currentAddress;

@property (nonatomic, assign) NSInteger selScopeIndex;

@property (nonatomic, assign) BOOL isChooseCity;

@end

@implementation LLChooseLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"选择位置";
    self.isChooseCity = false;
    
    [self.view addSubview:self.chooseLocationScopeView];
    [self.chooseLocationScopeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(110);
    }];
    
    [self.view addSubview:self.affirmButton];
    [self.affirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.chooseLocationScopeView.mas_bottom);
        make.bottom.equalTo(self.affirmButton.mas_top);
    }];
    
    [self.mapView addSubview:self.centerAnnotationView];
    [self.centerAnnotationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.mapView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.mapView.zoomLevel = 15;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    WEAKSELF
    self.chooseLocationScopeView.chooseCityBlock = ^{
        [weakSelf chooseCity];
    };
    self.chooseLocationScopeView.chooseScopeBlock = ^(NSInteger index) {
        weakSelf.selScopeIndex = index;
        [weakSelf addCircleRegionForMonitoringWithCenter:weakSelf.currentCoordinate];
    };
    
    [self.chooseLocationScopeView setCurrentIndex:0];
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
    self.currentCoordinate = coordinate;
    self.chooseLocationScopeView.addressLabel.text = @"加载中...";
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = false;
    [self.mapSearch AMapReGoecodeSearch:regeo];
    
    if (self.isChooseCity) {
        self.isChooseCity = false;
        return;
    }
    [self addCircleRegionForMonitoringWithCenter:coordinate];
}

- (void)addCircleRegionForMonitoringWithCenter:(CLLocationCoordinate2D)coordinate {
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.geoFenceManager removeAllGeoFenceRegions];
    
    if (self.selScopeIndex >= 0 && self.selScopeIndex < 3) {
        CLLocationDistance radius = 1000;
        if (self.selScopeIndex == 1) radius = 3000;
        if (self.selScopeIndex == 2) radius = 5000;
        [self.geoFenceManager addCircleRegionForMonitoringWithCenter:coordinate radius:radius customID:@"circle_1"];
    }
//    [self.geoFenceManager addDistrictRegionForMonitoringWithDistrictName:@"西湖区" customID:@"district_1"];
}

- (void)addDistrictRegionForMonitoringWithDistrictName:(NSString *)districtName {
    self.isChooseCity = true;
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.geoFenceManager removeAllGeoFenceRegions];
    [self.geoFenceManager addDistrictRegionForMonitoringWithDistrictName:districtName customID:@"district_1"];
}

//添加地理围栏对应的Overlay，方便查看。地图上显示圆
- (MACircle *)showCircleInMap:(CLLocationCoordinate2D )coordinate radius:(NSInteger)radius {
    MACircle *circleOverlay = [MACircle circleWithCenterCoordinate:coordinate radius:radius];
    [self.mapView addOverlay:circleOverlay];
    return circleOverlay;
}

- (MAPolygon *)showPolygonInMap:(CLLocationCoordinate2D *)coordinates count:(NSInteger)count {
    MAPolygon *polygonOverlay = [MAPolygon polygonWithCoordinates:coordinates count:count];
    [self.mapView addOverlay:polygonOverlay];
    return polygonOverlay;
}

#pragma mark Methds
- (void)chooseCity {
    WEAKSELF
    [ZJUsefulPickerView showCitiesPickerWithToolBarText:@"选择地区" withDefaultSelectedValues:nil withCancelHandler:^{
        
    } withDoneHandler:^(NSArray *selectedValues) {
        LELog(@"selectedValues: %@",selectedValues);
        NSString *districtName = selectedValues[2];
        if (districtName.length == 0) {
            districtName = selectedValues[1];
        }
        [weakSelf addDistrictRegionForMonitoringWithDistrictName:districtName];
    }];
}

- (void)affirmAction {
    if (self.currentCoordinate.latitude == 0 || self.currentCoordinate.longitude == 0) {
        [SVProgressHUD showCustomInfoWithStatus:@"请选择地址"];
        return;
    }
    if (self.chooseLocationCoordinateBlock) {
        self.chooseLocationCoordinateBlock(self.currentCoordinate, self.currentAddress);
    }
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - setget
- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] init];
        _mapView.delegate = self;
        self.isLocated = NO;
        _mapView.showsCompass = false;
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

- (AMapGeoFenceManager *)geoFenceManager {
    if (!_geoFenceManager) {
        _geoFenceManager = [[AMapGeoFenceManager alloc] init];
        _geoFenceManager.delegate = self;
        _geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed;
//        _geoFenceManager.allowsBackgroundLocationUpdates = YES;
    }
    return _geoFenceManager;
}

- (LLChooseLocationScopeView *)chooseLocationScopeView {
    if (!_chooseLocationScopeView) {
        _chooseLocationScopeView = [[[NSBundle mainBundle] loadNibNamed:@"LLChooseLocationScopeView" owner:self options:nil] firstObject];
    }
    return _chooseLocationScopeView;
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

- (UIImageView *)centerAnnotationView {
    if (!_centerAnnotationView) {
        _centerAnnotationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3_2_4.2"]];
    }
    return _centerAnnotationView;
}

#pragma mark - MapViewDelegate
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.mapView.userTrackingMode == MAUserTrackingModeNone) {
        [self getPoiInfoWithCoordinate:self.mapView.centerCoordinate];
    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolygon class]]) {
        MAPolygonRenderer *polylineRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
        polylineRenderer.lineWidth = 3.0f;
        polylineRenderer.strokeColor = [kAppThemeColor colorWithAlphaComponent:0.3];
        UIColor *fillColor = polylineRenderer.fillColor;
        
        polylineRenderer.fillColor = [fillColor colorWithAlphaComponent:0.5];
        
        return polylineRenderer;
    } else if ([overlay isKindOfClass:[MACircle class]]) {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.lineWidth = 3.0f;
        circleRenderer.strokeColor = [kAppThemeColor colorWithAlphaComponent:0.3];
        circleRenderer.fillColor = UIColor.clearColor;
        
        return circleRenderer;
    }
    return nil;
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
        self.chooseLocationScopeView.addressLabel.text = formattedAddress;
//        NSString *addressDes = [NSString stringWithFormat:@"%@ %@",addressComponent.streetNumber.street, addressComponent.streetNumber.number];
        self.currentAddress = formattedAddress;
    }
}

#pragma mark - AMapGeoFenceManagerDelegate
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray<AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        LELog(@"围栏创建失败 %@",error);
    } else {
        LELog(@"围栏创建成功");
        if ([customID hasPrefix:@"circle_1"]) {
            AMapGeoFenceCircleRegion *circleRegion = (AMapGeoFenceCircleRegion *)regions.firstObject;  //一次添加一个圆形围栏，只会返回一个
            MACircle *circleOverlay = [self showCircleInMap:circleRegion.center radius:circleRegion.radius];
//            [self.mapView setVisibleMapRect:circleOverlay.boundingMapRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];   //设置地图的可见范围，让地图缩放和平移到合适的位置
        } else if ([customID hasPrefix:@"district_1"]) {
            AMapGeoFenceDistrictRegion *districtRegion = (AMapGeoFenceDistrictRegion *)regions.firstObject;
            for (NSArray *arealocation in districtRegion.polylinePoints) {
                CLLocationCoordinate2D *coorArr = malloc(sizeof(CLLocationCoordinate2D) * arealocation.count);
                for (int i = 0; i < arealocation.count; i++) {
                    AMapLocationPoint *point = [arealocation objectAtIndex:i];
                    coorArr[i] = CLLocationCoordinate2DMake(point.latitude, point.longitude);
                }
                MAPolygon *polygonOverlay = [self showPolygonInMap:coorArr count:arealocation.count];
                [self.mapView setVisibleMapRect:polygonOverlay.boundingMapRect edgePadding:UIEdgeInsetsMake(0, 0, 0, 0) animated:YES];
                
                free(coorArr);
                coorArr = NULL;
                
            }
        }
    }
}

@end
