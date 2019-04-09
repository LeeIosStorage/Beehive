//
//  LLAreaChooseView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/9.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLAreaChooseView.h"
#import "LELoginAuthManager.h"

@interface LLAreaChooseView ()

@property (nonatomic, weak) IBOutlet UIView *areaView;
@property (nonatomic, weak) IBOutlet UIButton *btnProvince;
@property (nonatomic, weak) IBOutlet UIButton *btnCity;
@property (nonatomic, weak) IBOutlet UIButton *btnCounty;
@property (nonatomic, weak) IBOutlet UIImageView *imgMoveLine;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataLists;
@property (nonatomic, assign) NSInteger currentChoosePage;

@end

@implementation LLAreaChooseView

- (void)setup {
    [super setup];
    
    [self.imgMoveLine removeFromSuperview];
    [self.areaView addSubview:self.imgMoveLine];
    [self.imgMoveLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.areaView);
        make.size.mas_equalTo(CGSizeMake(15, 1.5));
        make.centerX.equalTo(self.btnProvince.mas_centerX);
    }];
    
    self.currentChoosePage = 0;
    [self refreshUI];
}

- (void)refreshUI {
    if (self.currentChoosePage == 0) {
        [self.btnProvince setTitleColor:kAppThemeColor forState:UIControlStateNormal];
        [self.btnCity setTitleColor:kAppTitleColor forState:UIControlStateNormal];
        [self.btnCounty setTitleColor:kAppTitleColor forState:UIControlStateNormal];
        [self.imgMoveLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.areaView);
            make.size.mas_equalTo(CGSizeMake(15, 1.5));
            make.centerX.equalTo(self.btnProvince.mas_centerX);
        }];
        LLAreaNode *node = [[LLAreaNode alloc] init];
        node.Id = @"0"; node.FullName = @"全国";
        self.dataLists = [NSMutableArray arrayWithObjects:node, nil];
        [self.dataLists addObjectsFromArray:[LELoginAuthManager sharedInstance].allAreaList];
    } else if (self.currentChoosePage == 1) {
        [self.btnProvince setTitleColor:kAppTitleColor forState:UIControlStateNormal];
        [self.btnCity setTitleColor:kAppThemeColor forState:UIControlStateNormal];
        [self.btnCounty setTitleColor:kAppTitleColor forState:UIControlStateNormal];
        [self.imgMoveLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.areaView);
            make.size.mas_equalTo(CGSizeMake(15, 1.5));
            make.centerX.equalTo(self.btnCity.mas_centerX);
        }];
        for (LLAreaNode *node in [LELoginAuthManager sharedInstance].allAreaList) {
            if ([[node.Id description] isEqualToString:[self.areaNode.ProvinceId description]]) {
                self.dataLists = [NSMutableArray arrayWithArray:node.Children];
            }
        }
    } else if (self.currentChoosePage == 2) {
        [self.btnProvince setTitleColor:kAppTitleColor forState:UIControlStateNormal];
        [self.btnCity setTitleColor:kAppTitleColor forState:UIControlStateNormal];
        [self.btnCounty setTitleColor:kAppThemeColor forState:UIControlStateNormal];
        [self.imgMoveLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.areaView);
            make.size.mas_equalTo(CGSizeMake(15, 1.5));
            make.centerX.equalTo(self.btnCounty.mas_centerX);
        }];
        for (LLAreaNode *node in [LELoginAuthManager sharedInstance].allAreaList) {
            if ([[node.Id description] isEqualToString:[self.areaNode.ProvinceId description]]) {
                for (LLAreaNode *cityNode in node.Children) {
                    if ([[cityNode.Id description] isEqualToString:[self.areaNode.CityId description]]) {
                        self.dataLists = [NSMutableArray arrayWithArray:cityNode.Children];
                    }
                }
            }
        }
    }
    
    [self.tableView reloadData];
    
    [self refreshAreaUI];
}

- (void)refreshAreaUI {
    NSString *provinceName = @"请选择省";
    if (self.areaNode.ProvinceName.length > 0) provinceName = self.areaNode.ProvinceName;
    [self.btnProvince setTitle:provinceName forState:UIControlStateNormal];
    
    NSString *cityName = @"请选择市";
    if (self.areaNode.CityName.length > 0) cityName = self.areaNode.CityName;
    [self.btnCity setTitle:cityName forState:UIControlStateNormal];
    
    NSString *countyName = @"请选择区/县";
    if (self.areaNode.CountyName.length > 0) countyName = self.areaNode.CountyName;
    [self.btnCounty setTitle:countyName forState:UIControlStateNormal];
}

- (NSString *)getCurrentAreaId {
    NSString *Id = self.areaNode.ProvinceId;
    if (self.currentChoosePage == 1) {
        Id = self.areaNode.CityId;
    } else if (self.currentChoosePage == 2) {
        Id = self.areaNode.CountyId;
    }
    return [Id description];
}

- (IBAction)cancelAction:(id)sender {
    if (self.chooseBlock) {
        self.chooseBlock(nil);
    }
}

- (IBAction)affirmAction:(id)sender {
    if (self.chooseBlock) {
        self.chooseBlock(self.areaNode);
    }
}

- (IBAction)chooseProvinceAction:(id)sender {
    self.currentChoosePage = 0;
    [self refreshUI];
}

- (IBAction)chooseCityAction:(id)sender {
    self.currentChoosePage = 1;
    [self refreshUI];
}

- (IBAction)chooseCountyAction:(id)sender {
    self.currentChoosePage = 2;
    [self refreshUI];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

static int label_tag = 201;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UITableViewCellP";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [FontConst PingFangSCRegularWithSize:13];
        label.textColor = kAppTitleColor;
        label.tag = label_tag;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(15);
            make.centerY.equalTo(cell.contentView);
        }];
        
        UIImageView *lineImg = [UIImageView new];
        lineImg.backgroundColor = LineColor;
        [cell.contentView addSubview:lineImg];
        [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(0);
            make.right.equalTo(cell.contentView).offset(0);
            make.bottom.equalTo(cell.contentView);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    UILabel *lable = (UILabel *)[cell.contentView viewWithTag:label_tag];
    LLAreaNode *node = self.dataLists[indexPath.row];
    lable.text = node.FullName;
    lable.textColor = kAppTitleColor;
    if ([[self getCurrentAreaId] isEqualToString:[node.Id description]]) {
        lable.textColor = kAppThemeColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    LLAreaNode *node = self.dataLists[indexPath.row];
    if ([node.Id intValue] == 0) {
        return;
    }
    if (self.currentChoosePage == 0) {
        self.areaNode.ProvinceId = node.Id;
        self.areaNode.ProvinceName = node.FullName;
        self.areaNode.CityId = @"";
        self.areaNode.CityName = @"";
        self.areaNode.CountyId = @"";
        self.areaNode.CountyName = @"";
        self.currentChoosePage = 1;
    } else if (self.currentChoosePage == 1) {
        self.areaNode.CityId = node.Id;
        self.areaNode.CityName = node.FullName;
        self.areaNode.CountyId = @"";
        self.areaNode.CountyName = @"";
        self.currentChoosePage = 2;
    } else if (self.currentChoosePage == 2) {
        self.areaNode.CountyId = node.Id;
        self.areaNode.CountyName = node.FullName;
    }
    [self refreshUI];
}

@end
