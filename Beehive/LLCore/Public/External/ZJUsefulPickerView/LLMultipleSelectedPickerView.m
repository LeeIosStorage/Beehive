//
//  LLMultipleSelectedPickerView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/10.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMultipleSelectedPickerView.h"
#import "ZJToolBar.h"

extern void ifDebug(dispatch_block_t blcok);

@interface LLMultipleSelectedPickerView ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ZJToolBar *toolBar;
@property (strong, nonatomic) NSArray<NSString *> *data;
@property (strong, nonatomic) NSMutableArray *selectedIndexs;
@property (strong, nonatomic) NSMutableArray *selectedValues;

@end

@implementation LLMultipleSelectedPickerView

#pragma mark - life cycle
- (instancetype)initWithToolBarText:(NSString *)toolBarText withDefaultIndexs:(NSArray *)defaultIndexs withData:(NSArray<NSString *> *)data withValueDidChangedHandler:(MultipleSelectedHandler)valueDidChangeHandler cancelAction:(BtnAction)cancelAction doneAction:(MultipleDoneHandler)doneAction {
    if (self = [super init]) {
        
        if (!data || ![data isKindOfClass:[NSArray class]]) {
            ifDebug(^{
                NSAssert(NO, @"设置的数据格式不正确, 初始化失败");
            });
            
            return nil;
        }
        
        _data = data;
//        _valueDidChangeHandler = valueDidChangeHandler;
        __weak typeof(self) weakSelf = self;
        _toolBar = [[ZJToolBar alloc] initWithToolbarText:toolBarText cancelAction:cancelAction doneAction:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                if (doneAction) {
                    doneAction(strongSelf.selectedIndexs, strongSelf.selectedValues);
                }
            }
        }];
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.tableView];
        [self addSubview:_toolBar];
        
        _selectedIndexs = [defaultIndexs mutableCopy];
        
        if (_selectedIndexs == nil || _selectedIndexs.count == 0) {
            // 如果没有指定默认值, 就全部设置为0
            _selectedIndexs = [NSMutableArray array];
//            for (int i = 0; i < data.count; i++) {
//                [_selectedIndexs addObject:@0];
//            }
        }
        
        [self congifTheDefaultValues];
        
        [self.tableView reloadData];
    }
    
    return self;
}

- (void)congifTheDefaultValues {
    _selectedValues = [NSMutableArray array];
    for (int i = 0; i < _selectedIndexs.count; i ++) {
        NSInteger row = [_selectedIndexs[i] integerValue];
        if (row < self.data.count) {
            NSString *title = self.data[row];
            [_selectedValues addObject:title];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat kToolBarHeight = 44.0f;
    
    NSLayoutConstraint *toolBarLeft = [NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0f];
    NSLayoutConstraint *toolBarRight = [NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0f];
    
    NSLayoutConstraint *toolBarHeight = [NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kToolBarHeight];
    NSLayoutConstraint *toolBarTop = [NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0f];
    self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[toolBarLeft, toolBarRight, toolBarHeight, toolBarTop]];
    
    NSLayoutConstraint *pickerViewLeft = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0f];
    NSLayoutConstraint *pickerViewRight = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0f];
    
    NSLayoutConstraint *pickerViewHeight = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.bounds.size.height - kToolBarHeight];
    NSLayoutConstraint *pickerViewBottom = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0f];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[pickerViewLeft, pickerViewRight, pickerViewHeight, pickerViewBottom]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

static int label_tag = 201, image_tag = 202;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UITableViewCellP";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [FontConst PingFangSCRegularWithSize:12];
        label.textColor = kAppTitleColor;
        label.tag = label_tag;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(27);
            make.centerY.equalTo(cell.contentView);
        }];
        
        UIImageView *selImg = [UIImageView new];
        selImg.image = [UIImage imageNamed:@"1_2_4.1"];
        selImg.tag = image_tag;
        [cell.contentView addSubview:selImg];
        [selImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-27);
            make.centerY.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        UIImageView *lineImg = [UIImageView new];
        lineImg.backgroundColor = LineColor;
        [cell.contentView addSubview:lineImg];
        [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(20);
            make.right.equalTo(cell.contentView).offset(-20);
            make.bottom.equalTo(cell.contentView);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    NSString *title = self.data[indexPath.row];
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
    
    NSString *title = self.data[indexPath.row];
    if ([self.selectedValues containsObject:title]) {
        [self.selectedValues removeObject:title];
        [self.selectedIndexs removeObject:[NSNumber numberWithInteger:indexPath.row]];
    } else {
        [self.selectedValues addObject:title];
        [self.selectedIndexs addObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    [self.tableView reloadData];
}

#pragma mark - setget
- (NSArray<NSString *> *)data {
    if (_data == nil) {
        _data = [NSArray array];
    }
    return _data;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(35, 0, 0, 0);
    }
    return _tableView;
}

@end
