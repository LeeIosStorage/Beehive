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
#import "LLHomeNode.h"
#import "GYRollingNoticeView.h"
#import "LLHomeNoticeCell.h"

@interface LLBeeHomeViewController ()
<
MAMapViewDelegate,
AMapSearchDelegate,
AMapGeoFenceManagerDelegate,
GYRollingNoticeViewDelegate,
GYRollingNoticeViewDataSource
>

@property (nonatomic, strong) LLHomeNode *homeNode;

@property (nonatomic, strong) NSMutableArray *redCityList;
@property (nonatomic, strong) NSMutableArray *mapRedpacketList;

@property (nonatomic, strong) UIView *customNavTitleView;
@property (nonatomic, strong) GYRollingNoticeView *rollingNoticeView;

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

- (void)dealloc
{
    [self.rollingNoticeView stopRoll];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
//    [self refreshHomeInfo];
    
//    [self addBottomAds:kLLAppTestHttpURL];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showHomeAdsAlertView];
    });
}

- (void)injected {
}

#pragma mark -
#pragma mark - Methods
- (void)setup {
    
    self.redCityList = [NSMutableArray array];
    self.mapRedpacketList = [NSMutableArray array];
    
    self.navigationItem.titleView = self.customNavTitleView;
    [self createBarButtonItemAtPosition:LLNavigationBarPositionRight normalImage:[UIImage imageNamed:@"home_nav_help"] highlightImage:nil text:@"" action:@selector(ruleClickAction:)];
    
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.cityOptionHeaderView];
    [self.cityOptionHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(65);
    }];
    self.cityOptionHeaderView.redCityArray = [NSMutableArray arrayWithArray:self.homeNode.FirstRowRedList];
    WEAKSELF
    self.cityOptionHeaderView.selectBlock = ^(id  _Nonnull node) {
        LLRedCityNode *cityNode = (LLRedCityNode *)node;
        if (cityNode.RedList.count > 0) {
            LLRedpacketNode *redNode = cityNode.RedList[0];
            [weakSelf addCircleRegionForMonitoringWithCityCenter:CLLocationCoordinate2DMake(redNode.Latitude, redNode.Longitude)];
        } else {
            [weakSelf addDistrictRegionForMonitoringWithDistrictName:cityNode.Name];
        }
    };
    
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
    
//    [self refreshMapRedpacketList];
    [self refreshHomeInfo];
    
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

- (void)addCircleRegionForMonitoringWithCityCenter:(CLLocationCoordinate2D)coordinate {
    self.isChooseCity = true;
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.geoFenceManager removeAllGeoFenceRegions];
    
    CLLocationDistance radius = 1000;
    [self.geoFenceManager addCircleRegionForMonitoringWithCenter:coordinate radius:radius customID:@"circle_2"];
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
- (void)refreshHomeInfo {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetIndexData"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:[NSNumber numberWithDouble:30.282141] forKey:@"latitude"];
//    [params setObject:[NSNumber numberWithDouble:120.111456] forKey:@"longitude"];
    [params setObject:[NSNumber numberWithDouble:self.currentCoordinate.latitude] forKey:@"latitude"];
    [params setObject:[NSNumber numberWithDouble:self.currentCoordinate.longitude] forKey:@"longitude"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLHomeNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                weakSelf.homeNode = data[0];
            }
        }
        
        [weakSelf setData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

//上报用户位置
- (void)updateUserPositionRequest {
    return;
    if (self.userLocationCoordinate.longitude == 0 || self.userLocationCoordinate.latitude == 0) {
        return;
    }
    if (![LELoginUserManager hasAccoutLoggedin]) {
        return;
    }
//    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"UpdateUserPosition"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithDouble:self.userLocationCoordinate.longitude] forKey:@"longitude"];
    [params setObject:[NSNumber numberWithDouble:self.userLocationCoordinate.latitude] forKey:@"latitude"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return;
        }
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

- (void)setData {
    
    [self.rollingNoticeView reloadDataAndStartRoll];
    
    self.cityOptionHeaderView.redCityArray = [NSMutableArray arrayWithArray:self.homeNode.FirstRowRedList];
    
    //地图上红包
    self.mapRedpacketList = [NSMutableArray arrayWithArray:self.homeNode.RedEnvelopesList];
    
    [self refreshMapRedpacketList];
}

- (void)refreshMapRedpacketList {
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    NSMutableArray *annotations = [NSMutableArray array];
    for (int i = 0; i < self.mapRedpacketList.count; i ++) {
        LLRedpacketNode *node = self.mapRedpacketList[i];
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(node.Latitude, node.Longitude);
        pointAnnotation.title = node.Title;
        pointAnnotation.subtitle = [NSString stringWithFormat:@"%ld", node.RedType];
        [annotations addObject:pointAnnotation];
    }
    
    [self.mapView addAnnotations:annotations];
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
- (UIView *)customNavTitleView{
    if (!_customNavTitleView) {
        _customNavTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 44)];
        
        self.rollingNoticeView.frame = _customNavTitleView.frame;
        [_customNavTitleView addSubview:self.rollingNoticeView];
    }
    return _customNavTitleView;
}

- (GYRollingNoticeView *)rollingNoticeView {
    if (!_rollingNoticeView) {
        _rollingNoticeView = [[GYRollingNoticeView alloc] init];
        _rollingNoticeView.delegate = self;
        _rollingNoticeView.dataSource = self;
        
//        [_rollingNoticeView registerNib:[UINib nibWithNibName:@"LLHomeNoticeCell" bundle:nil] forCellReuseIdentifier:@"LLHomeNoticeCell"];
        [_rollingNoticeView registerClass:[LLHomeNoticeCell class] forCellReuseIdentifier:@"LLHomeNoticeCell"];
    }
    return _rollingNoticeView;
}

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

#pragma mark - GYRollingNoticeViewDelegate
- (NSInteger)numberOfRowsForRollingNoticeView:(GYRollingNoticeView *)rollingView {
    return self.homeNode.NoticeList.count;
}

- (GYNoticeViewCell *)rollingNoticeView:(GYRollingNoticeView *)rollingView cellAtIndex:(NSUInteger)index {
    LLHomeNoticeCell *cell = [rollingView dequeueReusableCellWithIdentifier:@"LLHomeNoticeCell"];
    cell.backgroundColor = UIColor.clearColor;
    LLNoticeNode *node = self.homeNode.NoticeList[index];
    cell.labTitle.text = node.Title;
    
    return cell;
}

- (void)didClickRollingNoticeView:(GYRollingNoticeView *)rollingView forIndex:(NSUInteger)index {
    LLNoticeNode *node = self.homeNode.NoticeList[index];
    LLRedRuleViewController *vc = [[LLRedRuleViewController alloc] init];
    vc.vcType = LLInfoDetailsVcTypeNotice;
    vc.text = node.Contents;
    [self.navigationController pushViewController:vc animated:true];
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

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *reuseIndetifier = @"UserLocationannotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@""];
        return annotationView;
    }
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"home_redpacket_red"];
        if ([annotation.subtitle isEqualToString:@"2"]) {
            annotationView.image = [UIImage imageNamed:@"home_redpacket_bule"];
        } else if ([annotation.subtitle isEqualToString:@"3"]) {
            annotationView.image = [UIImage imageNamed:@"home_redpacket_yellow"];
        }
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
//        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    NSString *type = view.annotation.subtitle;
    if ([type isEqualToString:@"3"]) {
        LLRedpacketDetailsViewController *vc = [[LLRedpacketDetailsViewController alloc] init];
        vc.vcType = 0;
        [self.navigationController pushViewController:vc animated:true];
    } else if ([type isEqualToString:@"2"]) {
        LLRedpacketDetailsViewController *vc = [[LLRedpacketDetailsViewController alloc] init];
        vc.vcType = 1;
        [self.navigationController pushViewController:vc animated:true];
    } else if ([type isEqualToString:@"1"]) {
        
    }
    [self.mapView deselectAnnotation:view.annotation animated:false];
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
        if ([customID hasPrefix:@"circle_1"] || [customID hasPrefix:@"circle_2"]) {
            AMapGeoFenceCircleRegion *circleRegion = (AMapGeoFenceCircleRegion *)regions.firstObject;  //一次添加一个圆形围栏，只会返回一个
            MACircle *circleOverlay = [self showCircleInMap:circleRegion.center radius:circleRegion.radius];
            if ([customID hasPrefix:@"circle_2"]) {
                [self.mapView setVisibleMapRect:circleOverlay.boundingMapRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];   //设置地图的可见范围，让地图缩放和平移到合适的位置
            }
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
