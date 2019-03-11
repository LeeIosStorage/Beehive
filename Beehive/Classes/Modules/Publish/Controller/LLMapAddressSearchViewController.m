//
//  LLMapAddressSearchViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/11.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMapAddressSearchViewController.h"
#import "LLMapAddressSearchTitleView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface LLMapAddressSearchViewController ()
<
AMapSearchDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) LLMapAddressSearchTitleView *searchTitleView;

@property (nonatomic, strong) AMapSearchAPI *mapSearch;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *geocodes;//<AMapGeocode *>

@end

@implementation LLMapAddressSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
//    self.navigationItem.titleView = self.searchTitleView;
    
    self.geocodes = [NSMutableArray array];
    
    UIView *customTitleView = [[UIView alloc] init];
    customTitleView.frame = CGRectMake(0, 0, 260, 26);
//    customTitleView.backgroundColor = kAppThemeColor;
    self.navigationItem.titleView = customTitleView;
    
    [customTitleView addSubview:self.searchTitleView];
//    [self.searchTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.centerY.equalTo(customTitleView);
//        make.size.mas_equalTo(CGSizeMake(260, 26));
//    }];
    
    WEAKSELF
    self.searchTitleView.cityLabel.text = self.city;
    self.searchTitleView.chooseCityBlock = ^{
        
    };
    self.searchTitleView.searchTextBlock = ^(NSString * _Nonnull text) {
        [weakSelf searchAddress:text];
    };
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)searchAddress:(NSString *)searchText {
//    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
//    geo.city = self.city;
//    geo.address = searchText;
//    [self.mapSearch AMapGeocodeSearch:geo];
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = searchText;
    tips.city     = self.city;
    tips.cityLimit = YES; //是否限制城市
    [self.mapSearch AMapInputTipsSearch:tips];
}

#pragma mark - setget
- (LLMapAddressSearchTitleView *)searchTitleView {
    if (!_searchTitleView) {
        _searchTitleView = [[[NSBundle mainBundle] loadNibNamed:@"LLMapAddressSearchTitleView" owner:self options:nil] firstObject];
        _searchTitleView.frame = CGRectMake(0, 0, 260, 26);
        _searchTitleView.layer.cornerRadius = 13;
        _searchTitleView.layer.masksToBounds = true;
        _searchTitleView.backgroundColor = kAppSectionBackgroundColor;
        
    }
    return _searchTitleView;
}

- (AMapSearchAPI *)mapSearch {
    if (!_mapSearch) {
        _mapSearch = [[AMapSearchAPI alloc] init];
        _mapSearch.delegate = self;
    }
    return _mapSearch;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.estimatedRowHeight = 57;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

#pragma mark - AMapSearchDelegate
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response {
    self.geocodes = [NSMutableArray arrayWithArray:response.geocodes];
//    LELog(@"%@",self.geocodes);
    [self.tableView reloadData];
}

- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response {
    self.geocodes = [NSMutableArray arrayWithArray:response.tips];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.geocodes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

static int titlelabel_tag = 201, deslabel_tag = 202;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UILabel *label = [[UILabel alloc] init];
        label.font = [FontConst PingFangSCRegularWithSize:13];
        label.textColor = kAppTitleColor;
        label.tag = titlelabel_tag;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(30);
            make.right.equalTo(cell.contentView).offset(-20);
            make.bottom.equalTo(cell.contentView.mas_centerY).offset(-2);
        }];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.font = [FontConst PingFangSCRegularWithSize:12];
        label2.textColor = kAppLightTitleColor;
        label2.tag = deslabel_tag;
        [cell.contentView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(30);
            make.right.equalTo(cell.contentView).offset(-20);
            make.top.equalTo(cell.contentView.mas_centerY).offset(2);
        }];
        
        UIImageView *lineImg = [UIImageView new];
        lineImg.backgroundColor = LineColor;
        [cell.contentView addSubview:lineImg];
        [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(30);
            make.right.equalTo(cell.contentView);
            make.bottom.equalTo(cell.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    AMapTip *node = self.geocodes[indexPath.row];
    UILabel *titlelabel = (UILabel *)[cell.contentView viewWithTag:titlelabel_tag];
    UILabel *deslabel = (UILabel *)[cell.contentView viewWithTag:deslabel_tag];
    titlelabel.text = node.name;
    deslabel.text = node.address;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    AMapTip *node = self.geocodes[indexPath.row];
    if (self.searchCoordinateBlock) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(node.location.latitude, node.location.longitude);
        self.searchCoordinateBlock(coordinate, node.name);
    }
    [self.navigationController popViewControllerAnimated:true];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:true];
    [self.searchTitleView.textField resignFirstResponder];
}

@end
