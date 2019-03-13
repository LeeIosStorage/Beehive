//
//  LLReportViewController.m
//  Beehive
//
//  Created by liguangjun on 2019/3/13.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLReportViewController.h"
#import "LEAlertMarkView.h"
#import "LLReportSucceedView.h"

@interface LLReportViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *publishButton;

@property (nonatomic, strong) NSMutableArray *dataList;
@property (strong, nonatomic) NSMutableArray *selectedValues;

@end

@implementation LLReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"举报";
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    [self.view addSubview:self.publishButton];
    [self.publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.publishButton.mas_top);
    }];
    
    self.selectedValues = [NSMutableArray array];
    
    self.dataList = [NSMutableArray array];
    [self.dataList addObject:@"发布色情骚扰信息"];
    [self.dataList addObject:@"发布暴力恐怖信息"];
    [self.dataList addObject:@"发布政治敏感信息"];
    [self.dataList addObject:@"发布其他违法信息"];
    
    [self.tableView reloadData];
}

- (void)publishAction:(id)sender {
    LLReportSucceedView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"LLReportSucceedView" owner:self options:nil] firstObject];
    tipView.layer.cornerRadius = 3;
    tipView.layer.masksToBounds = true;
    tipView.frame = CGRectMake(0, 0, 260, 247);
    LEAlertMarkView *alert = [[LEAlertMarkView alloc] initWithCustomView:tipView];
    [alert show];
}

#pragma mark - setget
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton *)publishButton {
    if (!_publishButton) {
        _publishButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _publishButton.backgroundColor = kAppThemeColor;
        [_publishButton setTitle:@"提交" forState:UIControlStateNormal];
        [_publishButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_publishButton.titleLabel setFont:[FontConst PingFangSCRegularWithSize:14]];
        [_publishButton addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishButton;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

static int label_tag = 201, image_tag = 202;
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
            make.left.equalTo(cell.contentView).offset(10);
            make.centerY.equalTo(cell.contentView);
        }];
        
        UIImageView *selImg = [UIImageView new];
        selImg.image = [UIImage imageNamed:@"1_2_4.1"];
        selImg.tag = image_tag;
        [cell.contentView addSubview:selImg];
        [selImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-10);
            make.centerY.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(15, 15));
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
    NSString *title = self.dataList[indexPath.row];
    UILabel *lable = (UILabel *)[cell.contentView viewWithTag:label_tag];
    UIImageView *selImg = (UIImageView *)[cell.contentView viewWithTag:image_tag];
    selImg.image = [UIImage imageNamed:@"1_2_4.1"];
    lable.text = title;
    if ([self.selectedValues containsObject:title]) {
        selImg.image = [UIImage imageNamed:@"1_2_4.2"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = self.dataList[indexPath.row];
    if ([self.selectedValues containsObject:title]) {
        [self.selectedValues removeObject:title];
    } else {
        [self.selectedValues addObject:title];
    }
    [self.tableView reloadData];
}

@end
