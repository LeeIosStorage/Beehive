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

@interface LLPartnerViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) LLPartnerHeaderView *partnerHeaderView;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation LLPartnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
}

- (void)setup {
    self.title = @"广告位";
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    self.partnerHeaderView.height = 679;
    self.tableView.tableHeaderView = self.partnerHeaderView;
//    [self.partnerHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        //top布局一定要加上 不然origin.y可能为负值
//        make.top.width.equalTo(self.tableView);
//    }];
    
    [self.tableView reloadData];
    
    WEAKSELF
    self.partnerHeaderView.buyAdBlock = ^(NSInteger index) {
        LLBuyAdViewController *vc = [[LLBuyAdViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:true];
    };
    self.partnerHeaderView.uploadAdBlock = ^(NSInteger index) {
        LLUploadAdViewController *vc = [[LLUploadAdViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:true];
    };
    self.partnerHeaderView.editAdBlock = ^(NSInteger index) {
        LLEditAdViewController *vc = [[LLEditAdViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:true];
    };
}

- (void)refreshData {
    
    [self.partnerHeaderView updateCellWithData:nil];
    
//    LLPartnerHeaderView *headView = (LLPartnerHeaderView *)self.tableView.tableHeaderView;
//    [self.tableView layoutIfNeeded];
////    headView.height = 679;
//    self.tableView.tableHeaderView = headView;
    
    [self.tableView reloadData];
}

- (IBAction)otherCityAction:(id)sender {
    WEAKSELF
    [ZJUsefulPickerView showCitiesPickerWithToolBarText:@"其他区域" withDefaultSelectedValues:nil withCancelHandler:^{
        
    } withDoneHandler:^(NSArray *selectedValues) {
        NSString *districtName = selectedValues[2];
        if (districtName.length == 0) {
            districtName = selectedValues[1];
        }
        
    }];
}

- (IBAction)joinPartnerAction:(id)sender {
    
    LLBeeKingIntroViewController *vc = [[LLBeeKingIntroViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
    
//    LLBeeKingViewController *vc = [[LLBeeKingViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - set
- (LLPartnerHeaderView *)partnerHeaderView {
    if (!_partnerHeaderView) {
        _partnerHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LLPartnerHeaderView" owner:self options:nil] firstObject];
    }
    return _partnerHeaderView;
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
