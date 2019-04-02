//
//  LLFilterDistanceView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/6.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLFilterDistanceView.h"
#import "LLTableViewCell.h"

@interface LLFilterDistanceView ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UIImageView *markImageView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation LLFilterDistanceView

- (void)setup {
    [super setup];
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.markImageView];
    [self.markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    
    self.dataList = [NSMutableArray arrayWithObjects:@{@"title":@"1千米", @"id":@"1"}, @{@"title":@"3千米", @"id":@"2"}, @{@"title":@"5千米", @"id":@"3"}, @{@"title":@"10千米以上", @"id":@"4"}, nil];
    [self.tableView reloadData];
}

- (void)show {
    
    [self setHidden:false];
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40*4);
        self.markImageView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        self.markImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self setHidden:true];
        [self removeFromSuperview];
    }];
}

#pragma mark - SetAndGet
- (UIImageView *)markImageView {
    if (!_markImageView) {
        _markImageView = [[UIImageView alloc] init];
        _markImageView.backgroundColor = kAppMaskOpaqueBlackColor;
        _markImageView.alpha = 0;
        _markImageView.userInteractionEnabled = true;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_markImageView addGestureRecognizer:tap];
    }
    return _markImageView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 33;
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
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LLTableViewCell";
    LLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[LLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UILabel *label = [[UILabel alloc] init];
        label.font = [FontConst PingFangSCRegularWithSize:14];
        label.textColor = kAppSubTitleColor;
        label.tag = 201;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(21);
            make.centerY.equalTo(cell.contentView);
        }];
    }
    NSDictionary *dic = self.dataList[indexPath.row];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:201];
    label.text = dic[@"title"];
    label.textColor = kAppSubTitleColor;
    if (self.selectIndex == indexPath.row) {
        label.textColor = kAppThemeColor;
    }
//    [cell updateCellWithData:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    _selectIndex = indexPath.row;
    [self.tableView reloadData];
    if (self.selectBlock) {
        self.selectBlock(_selectIndex);
    }
    [self dismiss];
}

@end
