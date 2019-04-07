//
//  LLPartnerViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPartnerViewController.h"
#import "LLPartnerHeaderView.h"
#import "ZJUsefulPickerView.h"
#import "LLUploadAdViewController.h"
#import "LLBuyAdViewController.h"
#import "LLEditAdViewController.h"
#import "LLBeeKingViewController.h"
#import "LLBeeKingIntroViewController.h"
#import "LLRedRuleViewController.h"
#import "LLAdvertDetailsNode.h"
#import "LELoginAuthManager.h"

@interface LLPartnerViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) LLAdvertDetailsNode *advertDetailsNode;

@property (nonatomic, strong) LLPartnerHeaderView *partnerHeaderView;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *allAreaNameList;

@end

@implementation LLPartnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
    [self getAdvertInfo];
}

- (void)setup {
    self.title = @"广告位";
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    [self createBarButtonItemAtPosition:LLNavigationBarPositionRight normalImage:[UIImage imageNamed:@"home_nav_help"] highlightImage:nil text:@"" action:@selector(ruleClickAction:)];
    
//    self.partnerHeaderView.height = 679;
    self.tableView.tableHeaderView = self.partnerHeaderView;
    [self.partnerHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        //top布局一定要加上 不然origin.y可能为负值
        make.top.width.equalTo(self.tableView);
    }];
    [self.tableView reloadData];
    
    WEAKSELF
    self.partnerHeaderView.buyAdBlock = ^(NSInteger index) {
        LLBuyAdViewController *vc = [[LLBuyAdViewController alloc] init];
        vc.advertNode = weakSelf.advertDetailsNode.AdverList[index];
        [weakSelf.navigationController pushViewController:vc animated:true];
    };
    self.partnerHeaderView.uploadAdBlock = ^(NSInteger index) {
        LLAdvertNode *node = weakSelf.advertDetailsNode.AdverList[index];
        [weakSelf gotoUploadAdVc:node];
    };
    self.partnerHeaderView.editAdBlock = ^(NSInteger index) {
        LLEditAdViewController *vc = [[LLEditAdViewController alloc] init];
        vc.advertNode = weakSelf.advertDetailsNode.AdverList[index];
        [weakSelf.navigationController pushViewController:vc animated:true];
    };
}

- (void)refreshData {
    
    [self.partnerHeaderView updateCellWithData:self.advertDetailsNode];
    
    LLPartnerHeaderView *headView = (LLPartnerHeaderView *)self.tableView.tableHeaderView;
    [self.tableView layoutIfNeeded];
//    headView.height = 679;
    self.tableView.tableHeaderView = headView;
    
    [self.tableView reloadData];
}

- (void)gotoUploadAdVc:(LLAdvertNode *)node {
    if (node.DataImg.length > 0) {
        LLEditAdViewController *vc = [[LLEditAdViewController alloc] init];
        vc.advertNode = node;
        [self.navigationController pushViewController:vc animated:true];
        return;
    }
    LLUploadAdViewController *vc = [[LLUploadAdViewController alloc] init];
    vc.advertNode = node;
    [self.navigationController pushViewController:vc animated:true];
    WEAKSELF
    vc.successBlock = ^{
        [weakSelf getAdvertInfo];
    };
}

#pragma mark - Request
- (void)getAdvertInfo {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetAdvertInfo"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.areaNode.ProvinceId forKey:@"provinceId"];
    [params setValue:self.areaNode.CityId forKey:@"cityId"];
    [params setValue:self.areaNode.CountyId forKey:@"countyId"];
//    NSString *caCheKey = @"GetAdvertInfo";
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLAdvertDetailsNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                weakSelf.advertDetailsNode = data[0];
                weakSelf.advertDetailsNode.CountyName = weakSelf.areaNode.CountyName;
            }
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

#pragma mark - Action
- (IBAction)otherCityAction:(id)sender {
    WEAKSELF
    [ZJUsefulPickerView showMultipleAssociatedColPickerWithToolBarText:@"其他区域" withDefaultValues:nil withData:self.allAreaNameList withCancelHandler:^{
        
    } withDoneHandler:^(NSArray *selectedValues) {
        NSString *provinceName = selectedValues[0];
        NSString *cityName = selectedValues[1];
        NSString *countyName = selectedValues[2];
        NSString *provinceId = @"";
        NSString *cityId = @"";
        NSString *countyId = @"";
        for (LLAreaNode *provinceNode in [LELoginAuthManager sharedInstance].allAreaList) {
            if ([provinceNode.FullName isEqualToString:provinceName]) {
                provinceId = provinceNode.Id;
                for (LLAreaNode *cityNode in provinceNode.Children) {
                    if ([cityNode.FullName isEqualToString:cityName]) {
                        cityId = cityNode.Id;
                        for (LLAreaNode *areaNode in cityNode.Children) {
                            if ([areaNode.FullName isEqualToString:countyName]) {
                                countyId = areaNode.Id;
                                break;
                            }
                        }
                    }
                }
            }
        }
        weakSelf.areaNode = [[LLHomeNode alloc] init];
        weakSelf.areaNode.ProvinceName = provinceName;
        weakSelf.areaNode.ProvinceId = provinceId;
        weakSelf.areaNode.CityName = cityName;
        weakSelf.areaNode.CityId = cityId;
        weakSelf.areaNode.CountyName = countyName;
        weakSelf.areaNode.CountyId = countyId;
        
        [weakSelf getAdvertInfo];
    }];
}

- (IBAction)joinPartnerAction:(id)sender {
    
    LLBeeKingIntroViewController *vc = [[LLBeeKingIntroViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
    
//    LLBeeKingViewController *vc = [[LLBeeKingViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:true];
}

- (void)ruleClickAction:(id)sender {
    LLRedRuleViewController *vc = [[LLRedRuleViewController alloc] init];
    vc.vcType = LLInfoDetailsVcTypeAdsBuyRule;
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - set
- (LLPartnerHeaderView *)partnerHeaderView {
    if (!_partnerHeaderView) {
        _partnerHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LLPartnerHeaderView" owner:self options:nil] firstObject];
    }
    return _partnerHeaderView;
}

- (NSMutableArray *)allAreaNameList {
    if (!_allAreaNameList) {
        _allAreaNameList = [NSMutableArray array];
        
        NSMutableArray *provinceArray = [NSMutableArray array];
        NSMutableDictionary *cityDic = [NSMutableDictionary dictionary];
        NSMutableDictionary *areaDic = [NSMutableDictionary dictionary];
        for (LLAreaNode *provinceNode in [LELoginAuthManager sharedInstance].allAreaList) {
            NSMutableArray *cityArray = [NSMutableArray array];
            for (LLAreaNode *cityNode in provinceNode.Children) {
                NSMutableArray *areaArray = [NSMutableArray array];
                for (LLAreaNode *areaNode in cityNode.Children) {
                    [areaArray addObject:areaNode.FullName];
                }
                [cityArray addObject:cityNode.FullName];
                [areaDic setObject:areaArray forKey:cityNode.FullName];
            }
            [provinceArray addObject:provinceNode.FullName];
            [cityDic setObject:cityArray forKey:provinceNode.FullName];
        }
        
        _allAreaNameList = [NSMutableArray arrayWithArray:@[provinceArray, cityDic, areaDic]];
    }
    return _allAreaNameList;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
}

@end
