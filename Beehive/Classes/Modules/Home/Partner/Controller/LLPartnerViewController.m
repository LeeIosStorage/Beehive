//
//  LLPartnerViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPartnerViewController.h"
#import "LLPartnerHeaderView.h"

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
    
    self.tableView.tableHeaderView = self.partnerHeaderView;
    [self.partnerHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        //top布局一定要加上 不然origin.y可能为负值
        make.top.width.equalTo(self.tableView);
    }];
    
    [self.tableView reloadData];
}

- (void)refreshData {
    
//    [self.personalHomeHeaderView updateCellWithData:nil];
    
    LLPartnerHeaderView *headView = (LLPartnerHeaderView *)self.tableView.tableHeaderView;
    [self.tableView layoutIfNeeded];
    self.tableView.tableHeaderView = headView;
    
    [self.tableView reloadData];
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
