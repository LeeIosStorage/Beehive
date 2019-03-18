//
//  LLUploadAdViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLUploadAdViewController.h"
#import "LLPublishCellNode.h"
#import "LLPublishNormalViewCell.h"
#import "LLPublishInputViewCell.h"
#import "LLPublishIDCardViewCell.h"

@interface LLUploadAdViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) LLPublishCellNode *currentPublishNode;

@end

@implementation LLUploadAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"上传广告图";
    if (self.vcType == LLUploadAdTypeLaunch) {
        self.title = @"启动页广告位";
    } else if (self.vcType == LLUploadAdTypeHome) {
        self.title = @"首页底部广告位";
    }  else if (self.vcType == LLUploadAdTypePopup) {
        self.title = @"首页弹出广告位";
    }
    
    self.tableView.backgroundColor = kAppSectionBackgroundColor;
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.saveButton.mas_top);
    }];
    
    self.currentPublishNode = [[LLPublishCellNode alloc] init];
    
    [self refreshDataSource];
}

- (void)refreshDataSource {
    //    self.dataSource = [NSMutableArray array];
    
    NSMutableArray *newMutArray = [NSMutableArray array];
    //配置发布信息
    LLPublishCellNode *cellNode = [self nodeForCellTypeWithType:LLPublishCellTypeInputTitle];
    [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode, nil]];
    
    LLPublishCellNode *cellNode2 = [self nodeForCellTypeWithType:LLPublishCellTypeADImage];
    [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode2, nil]];
    
    LLPublishCellNode *cellNode3 = [self nodeForCellTypeWithType:LLPublishCellTypeLinkAddress];
    [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode3, nil]];
    
    if (self.vcType == LLUploadAdTypeLaunch || self.vcType == LLUploadAdTypeHome || self.vcType == LLUploadAdTypePopup) {
        newMutArray = [NSMutableArray array];
        LLPublishCellNode *cellNode2 = [self nodeForCellTypeWithType:LLPublishCellTypeADImage];
        [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode2, nil]];
    }
    
    
    self.dataSource = [NSMutableArray arrayWithArray:newMutArray];
    [self.tableView reloadData];
}

- (LLPublishCellNode *)nodeForCellTypeWithType:(LLPublishCellType)type {
    LLPublishCellNode *cellNode;
    for (NSArray *array in self.dataSource) {
        for (LLPublishCellNode *node in array) {
            if (node.cellType == type) {
                cellNode = node;
                break;
            }
        }
    }
    if (!cellNode) {
        cellNode = [[LLPublishCellNode alloc] init];
        cellNode.cellType = type;
    }
    switch (type) {
        case LLPublishCellTypeInputTitle:
            cellNode.title = @"标题";
            cellNode.placeholder = @"输入文字标题";
            break;
        case LLPublishCellTypeADImage:
            cellNode.title = @"添加广告图";
            if (self.vcType != LLUploadAdTypeNone) {
                cellNode.title = @"添加照片";
            }
            cellNode.uploadImageDatas = [NSMutableArray array];
            break;
        case LLPublishCellTypeLinkAddress:
            cellNode.title = @"跳转链接地址";
            cellNode.placeholder = @"输入链接地址...";
            break;
        default:
            break;
    }
    return cellNode;
}

#pragma mark - Action
- (void)saveAction:(id)sender {
    
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

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _saveButton.backgroundColor = kAppThemeColor;
        [_saveButton setTitle:@"上传" forState:UIControlStateNormal];
        if (self.vcType != LLUploadAdTypeNone) {
            [_saveButton setTitle:@"提交" forState:UIControlStateNormal];
        }
        [_saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_saveButton.titleLabel setFont:[FontConst PingFangSCRegularWithSize:14]];
        [_saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
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
        imgLine.tag = 201;
        [header.contentView addSubview:imgLine];
        [imgLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(header);
            make.height.mas_equalTo(0.5);
        }];
    }
    UIImageView *imgLine = (UIImageView *)[header.contentView viewWithTag:201];
    imgLine.hidden = false;
    if (section == self.dataSource.count - 1) {
        imgLine.hidden = true;
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.dataSource[indexPath.section];
    LLPublishCellNode *cellNode = array[indexPath.row];
    if (cellNode.cellType == LLPublishCellTypeInputTitle || cellNode.cellType == LLPublishCellTypeLinkAddress) {
        
        static NSString *cellIdentifier = @"LLPublishInputViewCell";
        LLPublishInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        [cell updateCellWithData:cellNode];
        return cell;
        
    } else {
        
        static NSString *cellIdentifier = @"LLPublishIDCardViewCell";
        LLPublishIDCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        cell.vc = self;
        [cell updateCellWithData:cellNode];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    NSArray *array = self.dataSource[indexPath.section];
    LLPublishCellNode *cellNode = array[indexPath.row];
    switch (cellNode.cellType) {
        default:
            break;
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:true];
}

@end
