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
#import "ZJUsefulPickerView.h"
#import "LLPublishIDCardViewCell.h"
#import "LLTradeMoldViewController.h"
#import "LLChooseLocationViewController.h"
#import "LLAddShopAddressViewController.h"

@interface LLPublishViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *publishButton;

@property (nonatomic, strong) LLPublishImageViewCell *publishImageViewCell;

@property (nonatomic, strong) LLPublishCellNode *currentPublishNode;

//Data
@property (nonatomic, strong) NSArray *ageArray;
@property (nonatomic, strong) NSArray *sexArray;
@property (nonatomic, strong) NSArray *hobbiesArray;
@property (nonatomic, strong) NSArray *couponPriceArray;

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
    if (self.publishVcType == LLPublishViewcTypeExchange) {
        self.title = @"发布商品";
    } else if (self.publishVcType == LLPublishViewcTypeAsk) {
        
    } else if (self.publishVcType == LLPublishViewcTypeConvenience) {
        self.title = @"发布信息";
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    
    self.currentPublishNode = [[LLPublishCellNode alloc] init];
    self.currentPublishNode.redMold = 0;
    self.currentPublishNode.taskMold = 0;
    self.currentPublishNode.companyMold = 0;
    self.currentPublishNode.ageMold = -1;
    self.currentPublishNode.sexMold = -1;
    self.currentPublishNode.isMore = true;
//    self.currentPublishNode.hobbiesIndexs = [NSArray arrayWithObjects:[NSNumber numberWithInteger:0], [NSNumber numberWithInteger:1], nil];
    
    [self refreshDataSource];
}

- (void)refreshDataSource {
//    for (NSArray *array in self.dataSource) {
//        for (LLPublishCellNode *node in array) {
//            if (node.cellType == LLPublishCellTypeRedMold) {
//                node.placeholder =
//            }
//        }
//    }
    
    self.dataSource = [NSMutableArray array];
    
    if (self.publishVcType == LLPublishViewcTypeExchange) {
        [self refreshExchangeData];
        return;
    } else if (self.publishVcType == LLPublishViewcTypeAsk) {
        [self refreshAskData];
        return;
    } else if (self.publishVcType == LLPublishViewcTypeConvenience) {
        [self refreshConvenienceData];
        return;
    }
    
    //配置发布信息
    LLPublishCellNode *cellNode = [[LLPublishCellNode alloc] init];
    cellNode.title = @"红包类型";
    cellNode.inputText = @"普通红包";
    if (self.currentPublishNode.redMold == 1) {
        cellNode.inputText = @"红包任务";
    }
    cellNode.cellType = LLPublishCellTypeRedMold;
    [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode]];
    
    if (self.currentPublishNode.redMold == 0) {
        
        LLPublishCellNode *cellNode1 = [[LLPublishCellNode alloc] init];
        cellNode1.title = @"标题";
        cellNode1.inputMaxCount = 200;
        cellNode1.placeholder = @"输入文字...";
        cellNode1.cellType = LLPublishCellTypeInputTitle;
        [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode1]];
        
        LLPublishCellNode *cellNode2 = [[LLPublishCellNode alloc] init];
        cellNode2.title = @"添加照片";
        cellNode2.placeholder = @"最多9张";
        cellNode2.cellType = LLPublishCellTypeImage;
        [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode2]];
        
    } else if (self.currentPublishNode.redMold == 1) {
        
        LLPublishCellNode *cellNode = [[LLPublishCellNode alloc] init];
        cellNode.title = @"选择类型";
        cellNode.inputText = @"上传图片";
        if (self.currentPublishNode.taskMold == 1) {
            cellNode.inputText = @"输入链接";
        }
        cellNode.cellType = LLPublishCellTypeTaskMold;
        [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode]];
        
        LLPublishCellNode *cellNode1 = [[LLPublishCellNode alloc] init];
        cellNode1.title = @"任务名称";
        cellNode1.placeholder = @"请输入";
        cellNode1.cellType = LLPublishCellTypeTaskName;
        cellNode1.inputType = LLPublishInputTypeInput;
        LLPublishCellNode *cellNode2 = [[LLPublishCellNode alloc] init];
        cellNode2.title = @"任务说明";
        cellNode2.placeholder = @"输入文字...";
        cellNode2.cellType = LLPublishCellTypeTaskExplain;
        [self.dataSource addObject:[NSMutableArray arrayWithObjects:cellNode1, cellNode2, nil]];
        
        if (self.currentPublishNode.taskMold == 0) {
            
            LLPublishCellNode *cellNode1 = [[LLPublishCellNode alloc] init];
            cellNode1.title = @"标题";
            cellNode1.inputMaxCount = 200;
            cellNode1.placeholder = @"输入文字...";
            cellNode1.cellType = LLPublishCellTypeInputTitle;
            [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode1]];
            
            LLPublishCellNode *cellNode2 = [[LLPublishCellNode alloc] init];
            cellNode2.title = @"添加照片";
            cellNode2.placeholder = @"最多9张";
            cellNode2.cellType = LLPublishCellTypeImage;
            [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode2]];
            
        } else if (self.currentPublishNode.taskMold == 1) {
            LLPublishCellNode *cellNode2 = [[LLPublishCellNode alloc] init];
            cellNode2.title = @"跳转链接地址";
            cellNode2.placeholder = @"输入链接地址...";
            cellNode2.cellType = LLPublishCellTypeLinkAddress;
            [self.dataSource addObject:[NSMutableArray arrayWithObjects:cellNode2, nil]];
        }
    }
    
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
    
    LLPublishCellNode *cellNode6 = [self nodeForCellTypeWithType:LLPublishCellTypePubDate];
    LLPublishCellNode *cellNode7 = [self nodeForCellTypeWithType:LLPublishCellTypeVisible];
    [self.dataSource addObject:[NSMutableArray arrayWithObjects:cellNode6, cellNode7, nil]];
    
    LLPublishCellNode *cellNode8 = [[LLPublishCellNode alloc] init];
    cellNode8.title = @"精准筛选";
    cellNode8.placeholder = @"最多选两项";
    cellNode8.cellType = LLPublishCellTypeMore;
    LLPublishCellNode *cellNode9 = [self nodeForCellTypeWithType:LLPublishCellTypeAge];
    LLPublishCellNode *cellNode10 = [self nodeForCellTypeWithType:LLPublishCellTypeSex];
    LLPublishCellNode *cellNode11 = [self nodeForCellTypeWithType:LLPublishCellTypeHobbies];
    if (self.currentPublishNode.isMore) {
        [self.dataSource addObject:[NSMutableArray arrayWithObjects:cellNode8, cellNode9, cellNode10, cellNode11, nil]];
    } else {
        [self.dataSource addObject:[NSMutableArray arrayWithObjects:cellNode8, nil]];
    }
    
    LLPublishCellNode *cellNode12 = [[LLPublishCellNode alloc] init];
    cellNode12.title = @"红包任务介绍";
    cellNode12.placeholder = @"红包任务介绍...";
    cellNode12.cellType = LLPublishCellTypeIntro;
    [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode12]];
    
    [self.tableView reloadData];
}

- (void)refreshExchangeData {
    
    LLPublishCellNode *cellNode1 = [[LLPublishCellNode alloc] init];
    cellNode1.title = @"标题";
    cellNode1.inputMaxCount = 200;
    cellNode1.placeholder = @"输入文字...";
    cellNode1.cellType = LLPublishCellTypeInputTitle;
    [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode1]];
    
    LLPublishCellNode *cellNode2 = [[LLPublishCellNode alloc] init];
    cellNode2.title = @"添加照片";
    cellNode2.placeholder = @"最多9张";
    cellNode2.cellType = LLPublishCellTypeImage;
    [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode2]];
    
    LLPublishCellNode *cellNode3 = [[LLPublishCellNode alloc] init];
    cellNode3.title = @"到点地址";
    cellNode3.placeholder = @"请添加";
    cellNode3.cellType = LLPublishCellTypeShopAddress;
    [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode3]];
    
    LLPublishCellNode *cellNode4 = [[LLPublishCellNode alloc] init];
    cellNode4.title = @"蜂蜜兑换数";
    cellNode4.placeholder = @"请输入";
    cellNode4.cellType = LLPublishCellTypeExchangeCount;
    cellNode4.inputType = LLPublishInputTypeInput;
    [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode4]];
    
    LLPublishCellNode *cellNode6 = [self nodeForCellTypeWithType:LLPublishCellTypePubDate];
    LLPublishCellNode *cellNode7 = [self nodeForCellTypeWithType:LLPublishCellTypeVisible];
    [self.dataSource addObject:[NSMutableArray arrayWithObjects:cellNode6, cellNode7, nil]];
    
    LLPublishCellNode *cellNode8 = [[LLPublishCellNode alloc] init];
    cellNode8.title = @"设置电子券";
    cellNode8.placeholder = @"最多选两项";
    cellNode8.cellType = LLPublishCellTypeMore;
    LLPublishCellNode *cellNode9 = [[LLPublishCellNode alloc] init];
    cellNode9.title = @"优惠券名称";
    cellNode9.titleFont = [FontConst PingFangSCRegularWithSize:12];
    cellNode9.placeholder = @"请输入";
    cellNode9.inputMaxCount = 20;
    cellNode9.cellType = LLPublishCellTypeCouponName;
    cellNode9.inputType = LLPublishInputTypeInput;
    LLPublishCellNode *cellNode10 = [[LLPublishCellNode alloc] init];
    cellNode10.title = @"优惠券说明";
    cellNode10.titleFont = [FontConst PingFangSCRegularWithSize:12];
    cellNode10.placeholder = @"请输入";
    cellNode10.inputMaxCount = 10;
    cellNode10.cellType = LLPublishCellTypeCouponExplain;
    cellNode10.inputType = LLPublishInputTypeInput;
    LLPublishCellNode *cellNode11 = [self nodeForCellTypeWithType:LLPublishCellTypeCouponPrice];
    LLPublishCellNode *cellNode12 = [self nodeForCellTypeWithType:LLPublishCellTypeCouponDate];
    if (self.currentPublishNode.isMore) {
        [self.dataSource addObject:[NSMutableArray arrayWithObjects:cellNode8, cellNode9, cellNode10, cellNode11, cellNode12, nil]];
    } else {
        [self.dataSource addObject:[NSMutableArray arrayWithObjects:cellNode8, nil]];
    }
    
    
    [self.tableView reloadData];
}

- (void)refreshAskData {
    
    LLPublishCellNode *cellNode1 = [[LLPublishCellNode alloc] init];
    cellNode1.title = @"标题";
    cellNode1.inputMaxCount = 200;
    cellNode1.placeholder = @"输入文字...";
    cellNode1.cellType = LLPublishCellTypeInputTitle;
    [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode1]];
    
    LLPublishCellNode *cellNode2 = [[LLPublishCellNode alloc] init];
    cellNode2.title = @"添加照片";
    cellNode2.placeholder = @"最多9张";
    cellNode2.cellType = LLPublishCellTypeImage;
    [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode2]];
    
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
    
    LLPublishCellNode *cellNode6 = [self nodeForCellTypeWithType:LLPublishCellTypePubDate];
    LLPublishCellNode *cellNode7 = [self nodeForCellTypeWithType:LLPublishCellTypeVisible];
    [self.dataSource addObject:[NSMutableArray arrayWithObjects:cellNode6, cellNode7, nil]];
    
    LLPublishCellNode *cellNode12 = [[LLPublishCellNode alloc] init];
    cellNode12.title = @"红包任务介绍";
    cellNode12.placeholder = @"红包任务介绍...";
    cellNode12.cellType = LLPublishCellTypeIntro;
    [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode12]];
    
    [self.tableView reloadData];
}

- (void)refreshConvenienceData {
    
    LLPublishCellNode *cellNode = [self nodeForCellTypeWithType:LLPublishCellTypeTradeMold];
    LLPublishCellNode *cellNode1 = [[LLPublishCellNode alloc] init];
    cellNode1.title = @"选择类型";
    cellNode1.inputText = @"个人";
    if (self.currentPublishNode.companyMold == 1) {
        cellNode1.inputText = @"企业";
    }
    cellNode1.cellType = LLPublishCellTypeCompanyMold;
    [self.dataSource addObject:[NSMutableArray arrayWithObjects:cellNode, cellNode1, nil]];
    
    LLPublishCellNode *cellNode2 = [[LLPublishCellNode alloc] init];
    cellNode2.title = @"手机号";
    cellNode2.placeholder = @"请输入";
    cellNode2.cellType = LLPublishCellTypePhone;
    cellNode2.inputType = LLPublishInputTypeInput;
    [self.dataSource addObject:[NSMutableArray arrayWithObjects:cellNode2, nil]];
    
    LLPublishCellNode *cellNode3 = [[LLPublishCellNode alloc] init];
    cellNode3.title = @"选择位置";
    cellNode3.placeholder = @"请选择";
    cellNode3.cellType = LLPublishCellTypeLocation;
    [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode3]];
    
    LLPublishCellNode *cellNode4 = [[LLPublishCellNode alloc] init];
    cellNode4.title = @"标题";
    cellNode4.inputMaxCount = 200;
    cellNode4.placeholder = @"输入文字...";
    cellNode4.cellType = LLPublishCellTypeInputTitle;
    [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode4]];
    
    LLPublishCellNode *cellNode5 = [[LLPublishCellNode alloc] init];
    cellNode5.title = @"身份证正反面";
    cellNode5.uploadImageDatas = [NSMutableArray array];
    cellNode5.cellType = LLPublishCellTypeIDCard;
    [self.dataSource addObject:[NSMutableArray arrayWithObject:cellNode5]];
    
    [self.tableView reloadData];
}

- (LLPublishCellNode *)nodeForCellTypeWithType:(LLPublishCellType)type {
    LLPublishCellNode *cellNode;
    for (NSArray *array in self.dataSource) {
        for (LLPublishCellNode *node in array) {
            if (node.cellType == type) {
                cellNode = node;
            }
        }
    }
    if (!cellNode) {
        cellNode = [[LLPublishCellNode alloc] init];
        cellNode.cellType = type;
    }
    switch (type) {
        case LLPublishCellTypePubDate:
            cellNode.title = @"发布时间";
            cellNode.placeholder = @"请选择";
            if (self.currentPublishNode.date) {
                cellNode.inputText = [WYCommonUtils dateDiscriptionFromDate:self.currentPublishNode.date];
            }
            break;
        case LLPublishCellTypeVisible:
            cellNode.title = @"可见用户";
            cellNode.placeholder = @"请选择";
            if (self.currentPublishNode.visibleMold == 0) {
                cellNode.inputText = @"所有人可见";
            } else if (self.currentPublishNode.visibleMold == 1) {
                cellNode.inputText = @"仅自己可见";
            }
            break;
        case LLPublishCellTypeAge:
            cellNode.title = @"年龄状态";
            cellNode.titleFont = [FontConst PingFangSCRegularWithSize:12];
            cellNode.placeholder = @"请选择";
            if (self.currentPublishNode.ageMold >= 0) {
                cellNode.inputText = self.ageArray[self.currentPublishNode.ageMold];
            }
            break;
        case LLPublishCellTypeSex:
            cellNode.title = @"性别选择";
            cellNode.titleFont = [FontConst PingFangSCRegularWithSize:12];
            cellNode.placeholder = @"请选择";
            if (self.currentPublishNode.sexMold >= 0) {
                cellNode.inputText = self.sexArray[self.currentPublishNode.sexMold];
            }
            break;
        case LLPublishCellTypeHobbies:
            cellNode.title = @"兴趣爱好";
            cellNode.titleFont = [FontConst PingFangSCRegularWithSize:12];
            cellNode.placeholder = @"请选择";
            if (self.currentPublishNode.hobbiesIndexs.count > 0) {
                NSMutableString *mStr = [NSMutableString string];
                for (int i = 0; i < self.currentPublishNode.hobbiesIndexs.count; i ++) {
                    NSInteger row = [self.currentPublishNode.hobbiesIndexs[i] integerValue];
                    NSString *string = self.hobbiesArray[row];
                    [mStr appendString:string];
                    [mStr appendString:@" "];
                }
                cellNode.inputText = mStr;
            }
            break;
        case LLPublishCellTypeCouponPrice:
            cellNode.title = @"优惠价格";
            cellNode.titleFont = [FontConst PingFangSCRegularWithSize:12];
            cellNode.placeholder = @"请选择";
            if (self.currentPublishNode.couponPrice.length > 0) {
                cellNode.inputText = self.currentPublishNode.couponPrice;
            }
            break;
        case LLPublishCellTypeCouponDate:
            cellNode.title = @"优惠起止时间";
            cellNode.titleFont = [FontConst PingFangSCRegularWithSize:12];
            cellNode.placeholder = @"请选择";
            if (self.currentPublishNode.couponBeginDate && self.currentPublishNode.couponEndDate) {
                NSString *inputText = [NSString stringWithFormat:@"%@ 至 %@",[WYCommonUtils dateYearToDayDiscriptionFromDate:self.currentPublishNode.couponBeginDate], [WYCommonUtils dateYearToDayDiscriptionFromDate:self.currentPublishNode.couponEndDate]];
                cellNode.inputText = inputText;
            }
            break;
        case LLPublishCellTypeTradeMold:
            cellNode.title = @"选择行业";
            cellNode.placeholder = @"请选择";
            if (self.currentPublishNode.tradeMoldNode1 && self.currentPublishNode.tradeMoldNode2) {
                cellNode.inputText = [NSString stringWithFormat:@"%@/%@",self.currentPublishNode.tradeMoldNode1.title, self.currentPublishNode.tradeMoldNode2.title];
            }
            break;
        default:
            break;
    }
    return cellNode;
}

#pragma mark - Action
- (void)publishAction:(id)sender {
    [self.tableView reloadData];
}

- (void)chooseRedMold {
    WEAKSELF
    NSArray *dataArray = @[@"普通红包", @"红包任务"];
    [ZJUsefulPickerView showSingleColPickerWithToolBarText:@"红包类型" withData:dataArray withDefaultIndex:weakSelf.currentPublishNode.redMold withCancelHandler:^{
        
    } withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
        weakSelf.currentPublishNode.redMold = selectedIndex;
        [weakSelf refreshDataSource];
    }];
}

- (void)chooseTaskMold {
    WEAKSELF
    NSArray *dataArray = @[@"上传图片", @"输入链接"];
    [ZJUsefulPickerView showSingleColPickerWithToolBarText:nil withData:dataArray withDefaultIndex:weakSelf.currentPublishNode.taskMold withCancelHandler:^{
        
    } withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
        weakSelf.currentPublishNode.taskMold = selectedIndex;
        [weakSelf refreshDataSource];
    }];
}

- (void)chooseCompanyMold {
    WEAKSELF
    NSArray *dataArray = @[@"个人", @"企业"];
    [ZJUsefulPickerView showSingleColPickerWithToolBarText:nil withData:dataArray withDefaultIndex:weakSelf.currentPublishNode.companyMold withCancelHandler:^{
        
    } withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
        weakSelf.currentPublishNode.companyMold = selectedIndex;
        [weakSelf refreshDataSource];
    }];
}

- (void)choosePublishDate {
    WEAKSELF
    ZJDatePickerStyle *style = [ZJDatePickerStyle new];
    style.datePickerMode = UIDatePickerModeDateAndTime;
    NSDate *nowDate = [NSDate date];
    style.minimumDate = nowDate;
    NSDate *maxDate = [nowDate dateByAddingDays:1];
    style.maximumDate = maxDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
//    NSDate *birthdayDate = [dateFormatter dateFromString:self.userModel.birthdayDate];
//    if (birthdayDate == nil) {
//        birthdayDate = [NSDate date];
//    }
//
//    style.date = birthdayDate;
    
    [ZJUsefulPickerView showDatePickerWithToolBarText:@"发布时间" withStyle:style withValueDidChangedHandler:^(NSDate *selectedDate) {
        
    } withCancelHandler:^{
        
    } withDoneHandler:^(NSDate *selectedDate) {
        weakSelf.currentPublishNode.date = selectedDate;
        [weakSelf refreshDataSource];
    }];
}

- (void)chooseVisibleMold {
    WEAKSELF
    NSArray *dataArray = @[@"所有人可见", @"仅自己可见"];
    [ZJUsefulPickerView showSingleColPickerWithToolBarText:@"可见用户" withData:dataArray withDefaultIndex:weakSelf.currentPublishNode.visibleMold withCancelHandler:^{
        
    } withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
        weakSelf.currentPublishNode.visibleMold = selectedIndex;
        [weakSelf refreshDataSource];
    }];
}

- (void)chooseAge {
    WEAKSELF
    [ZJUsefulPickerView showSingleColPickerWithToolBarText:@"选择年龄阶段" withData:self.ageArray withDefaultIndex:self.currentPublishNode.ageMold withCancelHandler:^{
        
    } withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
        weakSelf.currentPublishNode.ageMold = selectedIndex;
        [weakSelf refreshDataSource];
    }];
}

- (void)chooseSex {
    WEAKSELF
    [ZJUsefulPickerView showSingleColPickerWithToolBarText:@"选择性别" withData:self.sexArray withDefaultIndex:self.currentPublishNode.sexMold withCancelHandler:^{
        
    } withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
        weakSelf.currentPublishNode.sexMold = selectedIndex;
        [weakSelf refreshDataSource];
    }];
}

- (void)chooseHobbies {
    WEAKSELF
    [ZJUsefulPickerView showMultipleSelPickerWithToolBarText:@"选择兴趣爱好" withData:self.hobbiesArray withDefaultIndexs:self.currentPublishNode.hobbiesIndexs withCancelHandler:^{
        
    } withDoneHandler:^(NSArray *selectedIndexs, NSArray *selectedValues) {
        weakSelf.currentPublishNode.hobbiesIndexs = selectedIndexs;
        [weakSelf refreshDataSource];
    }];
}

- (void)chooseCouponPrice {
    WEAKSELF
    [ZJUsefulPickerView showSingleColPickerWithToolBarText:@"优惠价格(元)" withData:self.couponPriceArray withDefaultIndex:0 withCancelHandler:^{
        
    } withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
        weakSelf.currentPublishNode.couponPrice = selectedValue;
        [weakSelf refreshDataSource];
    }];
}

- (void)chooseCouponBeginDate {
    WEAKSELF
    ZJDatePickerStyle *style = [ZJDatePickerStyle new];
    style.datePickerMode = UIDatePickerModeDate;
    NSDate *nowDate = [NSDate date];
    style.minimumDate = nowDate;
//    NSDate *maxDate = [nowDate dateByAddingDays:1];
//    style.maximumDate = maxDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    style.date = self.currentPublishNode.couponBeginDate;
    
    [ZJUsefulPickerView showDatePickerWithToolBarText:@"优惠开始时间" withStyle:style withValueDidChangedHandler:^(NSDate *selectedDate) {
        
    } withCancelHandler:^{
        
    } withDoneHandler:^(NSDate *selectedDate) {
        weakSelf.currentPublishNode.couponBeginDate = selectedDate;
        [weakSelf chooseCouponEndDate];
    }];
}

- (void)chooseCouponEndDate {
    WEAKSELF
    ZJDatePickerStyle *style = [ZJDatePickerStyle new];
    style.datePickerMode = UIDatePickerModeDate;
    NSDate *nowDate = self.currentPublishNode.couponBeginDate;
    style.minimumDate = nowDate;
//    NSDate *maxDate = [nowDate dateByAddingDays:1];
//    style.maximumDate = maxDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    style.date = self.currentPublishNode.couponBeginDate;
    
    [ZJUsefulPickerView showDatePickerWithToolBarText:@"优惠结束时间" withStyle:style withValueDidChangedHandler:^(NSDate *selectedDate) {
        
    } withCancelHandler:^{
        weakSelf.currentPublishNode.couponBeginDate = nil;
    } withDoneHandler:^(NSDate *selectedDate) {
        weakSelf.currentPublishNode.couponEndDate = selectedDate;
        [weakSelf refreshDataSource];
    }];
}

- (void)chooseTradeMold {
    LLTradeMoldViewController *vc = [[LLTradeMoldViewController alloc] init];
    vc.oneNode = self.currentPublishNode.tradeMoldNode1;
    vc.twoNode = self.currentPublishNode.tradeMoldNode2;
    [self.navigationController pushViewController:vc animated:true];
    
    WEAKSELF
    vc.chooseBlock = ^(LLTradeMoldNode * _Nonnull node1, LLTradeMoldNode * _Nonnull node2) {
        weakSelf.currentPublishNode.tradeMoldNode1 = node1;
        weakSelf.currentPublishNode.tradeMoldNode2 = node2;
        [weakSelf refreshDataSource];
    };
}

- (void)chooseLocation {
    LLChooseLocationViewController *vc = [[LLChooseLocationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)chooseShopAddress {
    LLAddShopAddressViewController *vc = [[LLAddShopAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark -
#pragma mark - DataSource
- (NSArray *)ageArray {
    if (!_ageArray) {
        _ageArray = @[@"16~20",@"21~30",@"31~40",@"41~50",@"50以上"];
    }
    return _ageArray;
}

- (NSArray *)sexArray {
    if (!_sexArray) {
        _sexArray = @[@"男",@"女"];
    }
    return _sexArray;
}

- (NSArray *)hobbiesArray {
    if (!_hobbiesArray) {
        _hobbiesArray = @[@"爬山", @"运动", @"音乐", @"读书"];
    }
    return _hobbiesArray;
}

- (NSArray *)couponPriceArray {
    if (!_couponPriceArray) {
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (int i = 0; i < 15; i ++) {
            [tmpArray addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
        _couponPriceArray = [NSArray arrayWithArray:tmpArray];
    }
    return _couponPriceArray;
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

- (LLPublishImageViewCell *)publishImageViewCell {
    if (!_publishImageViewCell) {
        static NSString *cellIdentifier = @"LLPublishImageViewCell";
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        _publishImageViewCell = [cells objectAtIndex:0];
        WEAKSELF
        _publishImageViewCell.cellUpdateHeightBlock = ^{
            [weakSelf.tableView reloadData];
        };
    }
    return _publishImageViewCell;
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
    if (cellNode.cellType == LLPublishCellTypeInputTitle || cellNode.cellType == LLPublishCellTypeIntro || cellNode.cellType == LLPublishCellTypeTaskExplain || cellNode.cellType == LLPublishCellTypeLinkAddress) {
        
        static NSString *cellIdentifier = @"LLPublishInputViewCell";
        LLPublishInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        [cell updateCellWithData:cellNode];
        return cell;
        
    } else if (cellNode.cellType == LLPublishCellTypeImage) {
        
        [self.publishImageViewCell updateCellWithData:cellNode];
        return self.publishImageViewCell;
        
//        static NSString *cellIdentifier = @"LLPublishImageViewCell";
//        LLPublishImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if (!cell) {
//            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
//            cell = [cells objectAtIndex:0];
//            WEAKSELF
//            cell.cellUpdateHeightBlock = ^{
//                [weakSelf.tableView reloadData];
//            };
//        }
//        [cell updateCellWithData:cellNode];
//        return cell;
        
    } else if (cellNode.cellType == LLPublishCellTypeIDCard) {
        
        static NSString *cellIdentifier = @"LLPublishIDCardViewCell";
        LLPublishIDCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        cell.vc = self;
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
        case LLPublishCellTypeRedMold: {
            [self chooseRedMold];
        }
            break;
        case LLPublishCellTypeTaskMold: {
            [self chooseTaskMold];
        }
            break;
        case LLPublishCellTypeMore:{
            self.currentPublishNode.isMore = !self.currentPublishNode.isMore;
            [self refreshDataSource];
        }
            break;
        case LLPublishCellTypeCompanyMold: {
            [self chooseCompanyMold];
        }
            break;
        case LLPublishCellTypePubDate: {
            [self choosePublishDate];
        }
            break;
        case LLPublishCellTypeVisible: {
            [self chooseVisibleMold];
        }
            break;
        case LLPublishCellTypeAge: {
            [self chooseAge];
        }
            break;
        case LLPublishCellTypeSex: {
            [self chooseSex];
        }
            break;
        case LLPublishCellTypeHobbies: {
            [self chooseHobbies];
        }
            break;
        case LLPublishCellTypeCouponPrice: {
            [self chooseCouponPrice];
        }
            break;
        case LLPublishCellTypeCouponDate: {
            [self chooseCouponBeginDate];
        }
            break;
        case LLPublishCellTypeTradeMold: {
            [self chooseTradeMold];
        }
            break;
        case LLPublishCellTypeLocation: {
            [self chooseLocation];
        }
            break;
        case LLPublishCellTypeShopAddress: {
            [self chooseShopAddress];
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
