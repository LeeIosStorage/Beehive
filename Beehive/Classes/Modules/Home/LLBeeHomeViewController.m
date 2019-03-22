//
//  LLBeeHomeViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/2/27.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeHomeViewController.h"
#import "LLBeeMineViewController.h"
#import "UIViewController+LLNavigationBar.h"
#import "LLRedRuleViewController.h"
#import "LLCityOptionHeaderView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "LEWebViewController.h"
#import "LLCommodityExchangeViewController.h"
#import "LLRedTaskViewController.h"
#import "LLRedTaskHistoryViewController.h"
#import "LLAwardRecordViewController.h"
#import "LLReceiveRedAlertView.h"
#import "LEAlertMarkView.h"
#import "LLRedpacketDetailsViewController.h"
#import "LLPartnerViewController.h"
#import "UIButton+WebCache.h"
#import "LLHomeAdsAlertView.h"

@interface LLBeeHomeViewController ()
<
MAMapViewDelegate,
AMapSearchDelegate,
AMapGeoFenceManagerDelegate
>

@property (nonatomic, strong) LLCityOptionHeaderView *cityOptionHeaderView;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *mapSearch;
@property (nonatomic, strong) AMapGeoFenceManager *geoFenceManager;

@property (nonatomic, assign) BOOL isLocated;

@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, assign) CLLocationCoordinate2D userLocationCoordinate;

@property (nonatomic, assign) BOOL isChooseCity;

@property (nonatomic, strong) UIButton *btnExchange;
@property (nonatomic, strong) UIButton *btnSingin;
@property (nonatomic, strong) UIButton *btnRefresh;
@property (nonatomic, strong) UIButton *btnRedTask;
@property (nonatomic, strong) UIButton *btnRedHistory;
@property (nonatomic, strong) UIButton *btnShare;

@property (nonatomic, strong) UIButton *btnBottomAds;

@end

@implementation LLBeeHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self addBottomAds:kLLAppTestHttpURL];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showHomeAdsAlertView];
    });
}

- (void)injected {
}

#pragma mark -
#pragma mark - Methods
- (void)setup {
    
    [self createBarButtonItemAtPosition:LLNavigationBarPositionRight normalImage:[UIImage imageNamed:@"home_nav_help"] highlightImage:nil text:@"" action:@selector(ruleClickAction:)];
    
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.cityOptionHeaderView];
    [self.cityOptionHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(65);
    }];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.cityOptionHeaderView.mas_bottom);
    }];
    
    [self.view addSubview:self.btnExchange];
    [self.btnExchange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.cityOptionHeaderView.mas_bottom).offset(80);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
    [self.view addSubview:self.btnSingin];
    [self.btnSingin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.btnExchange.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
    [self.view addSubview:self.btnRefresh];
    [self.btnRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.btnSingin.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
    [self.view addSubview:self.btnRedTask];
    [self.btnRedTask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.cityOptionHeaderView.mas_bottom).offset(80);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
    [self.view addSubview:self.btnRedHistory];
    [self.btnRedHistory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.btnExchange.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
    [self.view addSubview:self.btnShare];
    [self.btnShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.btnSingin.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
    
    self.mapView.showsCompass = false;
    self.mapView.zoomLevel = 14.5;
    self.mapView.showsUserLocation = true;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}

- (void)receiveRedAlertViewShow {
    LLReceiveRedAlertView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"LLReceiveRedAlertView" owner:self options:nil] firstObject];
    tipView.frame = CGRectMake(0, 0, 186, 280);
    [tipView updateCellWithData:nil];
    __weak UIView *weakView = tipView;
    WEAKSELF
    tipView.clickBlock = ^(NSInteger index) {
        if ([weakView.superview isKindOfClass:[LEAlertMarkView class]]) {
            LEAlertMarkView *alert = (LEAlertMarkView *)weakView.superview;
            [alert dismiss];
        }
        if (index == 0) {
            [weakSelf gotoRedpacketDetailsVc];
        }
    };
    LEAlertMarkView *alert = [[LEAlertMarkView alloc] initWithCustomView:tipView type:LEAlertMarkViewTypeCenter];
    [alert show];
}

- (void)showHomeAdsAlertView {
    LLHomeAdsAlertView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"LLHomeAdsAlertView" owner:self options:nil] firstObject];
    tipView.frame = CGRectMake(0, 0, 230, 345);
    [tipView updateCellWithData:nil];
    __weak UIView *weakView = tipView;
    WEAKSELF
    tipView.actionBlock = ^(NSInteger index) {
        if ([weakView.superview isKindOfClass:[LEAlertMarkView class]]) {
            LEAlertMarkView *alert = (LEAlertMarkView *)weakView.superview;
            [alert dismiss];
        }
        if (index == 1) {
            [LELinkerHandler handleDealWithHref:@"http://www.baidu.com" From:weakSelf.navigationController];
        }
    };
    LEAlertMarkView *alert = [[LEAlertMarkView alloc] initWithCustomView:tipView type:LEAlertMarkViewTypeCenter];
    [alert show];
}

- (void)gotoRedpacketDetailsVc {
    LLRedpacketDetailsViewController *vc = [[LLRedpacketDetailsViewController alloc] init];
    vc.vcType = 1;
    [self.navigationController pushViewController:vc animated:true];
}

- (void)addBottomAds:(NSString *)url {
    [self.mapView addSubview:self.btnBottomAds];
    [self.btnBottomAds mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.mapView);
        make.height.mas_equalTo(60);
    }];
    [self.btnBottomAds sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
}

- (void)getPoiInfoWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self.currentCoordinate = coordinate;
//    self.chooseLocationScopeView.addressLabel.text = @"加载中...";
//    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
//    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
//    regeo.requireExtension = false;
//    [self.mapSearch AMapReGoecodeSearch:regeo];
    
    if (self.isChooseCity) {
        self.isChooseCity = false;
        return;
    }
    [self addCircleRegionForMonitoringWithCenter:coordinate];
}

//范围围栏
- (void)addCircleRegionForMonitoringWithCenter:(CLLocationCoordinate2D)coordinate {
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.geoFenceManager removeAllGeoFenceRegions];
    
    CLLocationDistance radius = 1000;
    [self.geoFenceManager addCircleRegionForMonitoringWithCenter:coordinate radius:radius customID:@"circle_1"];
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

#pragma mark -
#pragma mark - Request
//上报用户位置
- (void)updateUserPositionRequest {
    if (self.userLocationCoordinate.longitude == 0 || self.userLocationCoordinate.latitude == 0) {
        return;
    }
//    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"UpdateUserPosition"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithDouble:self.userLocationCoordinate.longitude] forKey:@"longitude"];
    [params setObject:[NSNumber numberWithDouble:self.userLocationCoordinate.latitude] forKey:@"latitude"];
    [params setObject:[NSNumber numberWithDouble:self.userLocationCoordinate.latitude] forKey:@"latitude"];
//    [params setObject:[LELoginUserManager authToken] forKey:@"token"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return;
        }
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

#pragma mark -
#pragma mark - Action
- (void)ruleClickAction:(id)sender {
    LLRedRuleViewController *vc = [[LLRedRuleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)exchangeAction:(id)sender {
    LLCommodityExchangeViewController *vc = [[LLCommodityExchangeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)singinAction:(id)sender {
    LEWebViewController *vc = [[LEWebViewController alloc] initWithURLString:@"http://www.baidu.com"];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)refreshAction:(id)sender {
    LLAwardRecordViewController *vc = [[LLAwardRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)redTaskAction:(id)sender {
    LLRedTaskViewController *vc = [[LLRedTaskViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)redHistoryAction:(id)sender {
    LLRedTaskHistoryViewController *vc = [[LLRedTaskHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)shareAction:(id)sender {
    [self receiveRedAlertViewShow];
}

- (void)adsBtnAction {
    LLPartnerViewController *vc = [[LLPartnerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark -
#pragma mark - SettingAndGetting
- (LLCityOptionHeaderView *)cityOptionHeaderView {
    if (!_cityOptionHeaderView) {
        _cityOptionHeaderView = [[LLCityOptionHeaderView alloc] init];
    }
    return _cityOptionHeaderView;
}

- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] init];
        _mapView.delegate = self;
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

- (UIButton *)btnExchange {
    if (!_btnExchange) {
        _btnExchange = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnExchange setImage:[UIImage imageNamed:@"home_store_exchange"] forState:UIControlStateNormal];
        [_btnExchange addTarget:self action:@selector(exchangeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnExchange;
}
- (UIButton *)btnSingin {
    if (!_btnSingin) {
        _btnSingin = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSingin setImage:[UIImage imageNamed:@"home_signin"] forState:UIControlStateNormal];
        [_btnSingin addTarget:self action:@selector(singinAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSingin;
}
- (UIButton *)btnShare {
    if (!_btnShare) {
        _btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnShare setImage:[UIImage imageNamed:@"home_share"] forState:UIControlStateNormal];
        [_btnShare addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnShare;
}
- (UIButton *)btnRefresh {
    if (!_btnRefresh) {
        _btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRefresh setImage:[UIImage imageNamed:@"home_redpacket_refresh"] forState:UIControlStateNormal];
        [_btnRefresh addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRefresh;
}
- (UIButton *)btnRedTask {
    if (!_btnRedTask) {
        _btnRedTask = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRedTask setImage:[UIImage imageNamed:@"home_redpacket_task"] forState:UIControlStateNormal];
        [_btnRedTask addTarget:self action:@selector(redTaskAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRedTask;
}
- (UIButton *)btnRedHistory {
    if (!_btnRedHistory) {
        _btnRedHistory = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRedHistory setImage:[UIImage imageNamed:@"home_redpacket_history"] forState:UIControlStateNormal];
        [_btnRedHistory addTarget:self action:@selector(redHistoryAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRedHistory;
}

- (UIButton *)btnBottomAds {
    if (!_btnBottomAds) {
        _btnBottomAds = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnBottomAds addTarget:self action:@selector(adsBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBottomAds;
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
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

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if(!updatingLocation)
    return ;
    
    if (userLocation.location.horizontalAccuracy < 0)
    {
        return ;
    }
    
    self.userLocationCoordinate = userLocation.location.coordinate;
    [self updateUserPositionRequest];
    
    // only the first locate used.
    if (!self.isLocated)
    {
        self.isLocated = YES;
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
        
        //        [self actionSearchAroundAt:userLocation.location.coordinate];
    }
}

- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated {
    if (mode == MAUserTrackingModeNone){
        
    } else {
        
    }
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"error = %@",error);
}

#pragma mark - AMapSearchDelegate
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
        NSString *formattedAddress = response.regeocode.formattedAddress;
        AMapAddressComponent *addressComponent = response.regeocode.addressComponent;
        //        self.chooseLocationScopeView.addressLabel.text = formattedAddress;
        //        NSString *addressDes = [NSString stringWithFormat:@"%@ %@",addressComponent.streetNumber.street, addressComponent.streetNumber.number];
        //        self.currentAddress = formattedAddress;
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
