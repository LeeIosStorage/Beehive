//
//  LLAddShopAddressViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/10.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLAddShopAddressViewController.h"
#import "LLPublishCellNode.h"
#import "LLPublishNormalViewCell.h"
#import "LLPublishChooseViewCell.h"
#import "LLMapAddressViewController.h"

@interface LLAddShopAddressViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) LLPublishCellNode *currentPublishNode;

@end

@implementation LLAddShopAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"添加到点地址";
    
    self.tableView.backgroundColor = kAppSectionBackgroundColor;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    
    self.footerView.height = 60;
    self.tableView.tableFooterView = self.footerView;
    
    self.currentPublishNode = [[LLPublishCellNode alloc] init];
    self.currentPublishNode.sexMold = 0;
    
    [self refreshDataSource];
}

- (void)refreshDataSource {
//    self.dataSource = [NSMutableArray array];
    
    NSMutableArray *newMutArray = [NSMutableArray array];
    //配置发布信息
    LLPublishCellNode *cellNode = [self nodeForCellTypeWithType:LLPublishCellTypeContacts];
    LLPublishCellNode *cellNode1 = [self nodeForCellTypeWithType:LLPublishCellTypePhone];
    [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode, cellNode1, nil]];
    
    LLPublishCellNode *cellNode2 = [self nodeForCellTypeWithType:LLPublishCellTypeSex];
    [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode2, nil]];
    
    LLPublishCellNode *cellNode3 = [self nodeForCellTypeWithType:LLPublishCellTypeShipAddress];
    LLPublishCellNode *cellNode4 = [self nodeForCellTypeWithType:LLPublishCellTypeHouseNumber];
    [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode3, cellNode4, nil]];
    
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
        case LLPublishCellTypePhone:
            cellNode.title = @"手机号";
            cellNode.placeholder = @"输入手机号";
            cellNode.inputType = LLPublishInputTypeInput;
            break;
        case LLPublishCellTypeContacts:
            cellNode.title = @"联系人";
            cellNode.placeholder = @"输入联系人姓名";
            cellNode.inputType = LLPublishInputTypeInput;
            break;
        case LLPublishCellTypeSex:
            cellNode.title = @"性别";
            cellNode.sexMold = self.currentPublishNode.sexMold;
            break;
        case LLPublishCellTypeShipAddress:
            cellNode.title = @"收货地址";
            cellNode.placeholder = @"点击选择";
            break;
        case LLPublishCellTypeHouseNumber:
            cellNode.title = @"门牌号";
            cellNode.placeholder = @"例：16号楼427室";
            cellNode.inputType = LLPublishInputTypeInput;
            break;
        default:
            break;
    }
    return cellNode;
}

#pragma mark - Action
- (void)saveAction:(id)sender {
    
}

- (void)chooseShipAddress {
    LLMapAddressViewController *vc = [[LLMapAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
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

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = kAppSectionBackgroundColor;
        
        [_footerView addSubview:self.saveButton];
        [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_footerView).offset(10);
            make.right.equalTo(self->_footerView).offset(-10);
            make.top.equalTo(self->_footerView).offset(12);
            make.bottom.equalTo(self->_footerView);
        }];
    }
    return _footerView;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _saveButton.backgroundColor = kAppThemeColor;
        _saveButton.layer.cornerRadius = 3;
        _saveButton.layer.masksToBounds = true;
        [_saveButton setTitle:@"保存地址" forState:UIControlStateNormal];
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
    if (cellNode.cellType == LLPublishCellTypeSex) {
        
        static NSString *cellIdentifier = @"LLPublishChooseViewCell";
        LLPublishChooseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        WEAKSELF
        cell.refreshBlock = ^(NSInteger index) {
            weakSelf.currentPublishNode.sexMold = index;
            [weakSelf refreshDataSource];
        };
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
    NSArray *array = self.dataSource[indexPath.section];
    LLPublishCellNode *cellNode = array[indexPath.row];
    switch (cellNode.cellType) {
        case LLPublishCellTypeShipAddress: {
            [self chooseShipAddress];
        }
            break;
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
