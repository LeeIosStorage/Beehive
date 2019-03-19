//
//  LLExchangeOrderDetailsViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLExchangeOrderDetailsViewController.h"

@interface LLExchangeOrderDetailsViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UIImageView *imgAvatar;
@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;
@property (nonatomic, weak) IBOutlet UIImageView *imgSex;
@property (nonatomic, weak) IBOutlet UILabel *labNickName;

@property (nonatomic, weak) IBOutlet UILabel *labShopName;
@property (nonatomic, weak) IBOutlet UILabel *labShopTipName;

@property (nonatomic, weak) IBOutlet UILabel *labQuanPrice;
@property (nonatomic, weak) IBOutlet UILabel *labTime;
@property (nonatomic, weak) IBOutlet UILabel *labValidity;
@property (nonatomic, weak) IBOutlet UILabel *labFull;
@property (nonatomic, weak) IBOutlet UILabel *labScope;

@property (nonatomic, weak) IBOutlet UILabel *labAddress;

@property (nonatomic, weak) IBOutlet UILabel *labExchangeType;
@property (nonatomic, weak) IBOutlet UILabel *labExchangePhone;
@property (nonatomic, weak) IBOutlet UILabel *labExchangeDate;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LLExchangeOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
}

- (void)setup {
    self.title = @"详情";
    
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    self.headerView.height = 445;
    self.tableView.tableHeaderView = self.headerView;
    
    [self.tableView reloadData];
}

- (void)refreshData {
    
    [self refreshHeadViewUI];
    [self.tableView reloadData];
}

- (void)refreshHeadViewUI {
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.imgAvatar setbitmapImage:nil];
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.imgIcon setbitmapImage:nil];
}

- (IBAction)callTelAction:(id)sender {
    [WYCommonUtils callTelephone:@"10086"];
}

#pragma mark - SetGet
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 57;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
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