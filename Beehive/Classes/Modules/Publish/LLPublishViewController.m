//
//  LLPublishViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/8.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPublishViewController.h"
#import "LLPublishCellNode.h"
#import "LLPublishNormalViewCell.h"
#import "LLPublishInputViewCell.h"
#import "LLPublishImageViewCell.h"

@interface LLPublishViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *publishButton;

@end

@implementation LLPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}

- (void)setPublishVcType:(LLPublishViewcType)publishVcType {
    _publishVcType = publishVcType;
}

#pragma mark -
#pragma mark - Private
- (void)setup {
    self.title = @"发布";
    
    [self.view addSubview:self.publishButton];
    [self.publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.publishButton.mas_top);
    }];
    
    self.dataSource = [NSMutableArray array];
    //配置发布信息
    LLPublishCellNode *cellNode = [[LLPublishCellNode alloc] init];
    cellNode.title = @"红包类型";
    cellNode.placeholder = @"普通红包";
    cellNode.cellType = LLPublishCellTypeRedMold;
//    cellNode.inputType = LLPublishInputTypeSelect;
    [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode]];
    
    LLPublishCellNode *cellNode1 = [[LLPublishCellNode alloc] init];
    cellNode1.title = @"标题";
    cellNode1.placeholder = @"输入文字";
    cellNode1.cellType = LLPublishCellTypeInputTitle;
    [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode1]];
    
//    LLPublishCellNode *cellNode2 = [[LLPublishCellNode alloc] init];
//    cellNode2.title = @"添加照片";
//    cellNode2.placeholder = @"最多9张";
//    cellNode2.cellType = LLPublishCellTypeImage;
//    [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode2]];
    
    LLPublishCellNode *cellNode3 = [[LLPublishCellNode alloc] init];
    cellNode3.title = @"选择位置";
    cellNode3.placeholder = @"请选择";
    cellNode3.cellType = LLPublishCellTypeLocation;
    [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode3]];
    
    LLPublishCellNode *cellNode4 = [[LLPublishCellNode alloc] init];
    cellNode4.title = @"红包金额";
    cellNode4.placeholder = @"请输入";
    cellNode4.cellType = LLPublishCellTypeRedAmount;
    cellNode4.inputType = LLPublishInputTypeInput;
    LLPublishCellNode *cellNode5 = [[LLPublishCellNode alloc] init];
    cellNode5.title = @"红包个数";
    cellNode5.placeholder = @"请输入";
    cellNode5.cellType = LLPublishCellTypeRedCount;
    cellNode5.inputType = LLPublishInputTypeInput;
    [self.dataSource addObject:[NSMutableArray arrayWithObjects:cellNode4, cellNode5, nil]];
    
    [self.tableView reloadData];
}

#pragma mark - Action
- (void)publishAction:(id)sender {
    
}

#pragma mark - SetGet
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 40;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (UIButton *)publishButton {
    if (!_publishButton) {
        _publishButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _publishButton.backgroundColor = kAppThemeColor;
        [_publishButton setTitle:@"发布" forState:UIControlStateNormal];
        [_publishButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_publishButton.titleLabel setFont:[FontConst PingFangSCRegularWithSize:14]];
        [_publishButton addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishButton;
}

#pragma mark -
#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataSource[section];
    return array.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 57;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [UIView new];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    static NSString *headerIdentifier = @"UITableViewHeaderFooterView";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
        header.backgroundColor = kAppSectionBackgroundColor;
        header.contentView.backgroundColor = kAppSectionBackgroundColor;
        
        UIImageView *imgLine = [UIImageView new];
        imgLine.backgroundColor = LineColor;
        [header addSubview:imgLine];
        [imgLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(header);
            make.height.mas_equalTo(0.5);
        }];
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.dataSource[indexPath.section];
    LLPublishCellNode *cellNode = array[indexPath.row];
    if (cellNode.cellType == LLPublishCellTypeInputTitle) {
        
        static NSString *cellIdentifier = @"LLPublishInputViewCell";
        LLPublishInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        [cell updateCellWithData:cellNode];
        return cell;
        
    } else if (cellNode.cellType == LLPublishCellTypeImage) {
        
        static NSString *cellIdentifier = @"LLPublishImageViewCell";
        LLPublishImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        [cell updateCellWithData:cellNode];
        return cell;
        
    } else {
        
        static NSString *cellIdentifier = @"LLPublishNormalViewCell";
        LLPublishNormalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        [cell updateCellWithData:cellNode];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:true];
}

@end
