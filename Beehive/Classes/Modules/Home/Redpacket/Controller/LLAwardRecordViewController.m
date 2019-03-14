//
//  LLAwardRecordViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/14.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLAwardRecordViewController.h"

@interface LLAwardRecordViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataLists;

@end

@implementation LLAwardRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
    [self refreshData];
}

- (void)setup {
    self.title = @"中奖纪录";
    self.view.backgroundColor = kAppSectionBackgroundColor;
    self.dataLists = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [self.tableView reloadData];
}

- (void)refreshData {
    self.dataLists = [NSMutableArray array];
    [self.dataLists addObject:@""];
    [self.dataLists addObject:@""];
    [self.dataLists addObject:@""];
    [self.dataLists addObject:@""];
    
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 40;
        _tableView.rowHeight = 40;
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
    return self.dataLists.count;
}

static int label_tag = 201, des_tag = 202;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UITableViewCellP";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [FontConst PingFangSCRegularWithSize:13];
        label.textColor = kAppSubTitleColor;
        label.tag = label_tag;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(10);
            make.centerY.equalTo(cell.contentView);
        }];
        
        UILabel *deslabel = [[UILabel alloc] init];
        deslabel.font = [FontConst PingFangSCRegularWithSize:13];
        deslabel.textColor = kAppSubTitleColor;
        deslabel.tag = des_tag;
        [cell.contentView addSubview:deslabel];
        [deslabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-10);
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
    UILabel *desLable = (UILabel *)[cell.contentView viewWithTag:des_tag];
    lable.text = @"2018-09-18 12:11";
    desLable.text = @"1.11";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
        [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

@end
