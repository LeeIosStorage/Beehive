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
#import "LLPubDataInfoNode.h"
#import "LLPublishTipViewCell.h"

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
@property (nonatomic, strong) NSArray *visibleMoldArray;
@property (nonatomic, strong) NSArray *ageArray;
@property (nonatomic, strong) NSArray *sexArray;
@property (nonatomic, strong) NSArray *hobbiesArray;
@property (nonatomic, strong) NSArray *couponPriceArray;

@property (nonatomic, assign) NSInteger payType;
@property (nonatomic, strong) NSString *payPwd;

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
        [self getRedDataInfo];
    } else if (self.publishVcType == LLPublishViewcTypeConvenience) {
        self.title = @"发布信息";
    } else {
        [self getRedDataInfo];
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
    
    [self refreshDataSource];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)refreshDataSource {
    
//    self.dataSource = [NSMutableArray array];
    
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
    
    NSMutableArray *newMutArray = [NSMutableArray array];
    //配置发布信息
    LLPublishCellNode *cellNode = [[LLPublishCellNode alloc] init];
    cellNode.title = @"红包类型";
    cellNode.inputText = @"普通红包";
    if (self.currentPublishNode.redMold == 1) {
        cellNode.inputText = @"红包任务";
    }
    cellNode.cellType = LLPublishCellTypeRedMold;
    [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode]];
    
    if (self.currentPublishNode.redMold == 0) {
        
        LLPublishCellNode *cellNode1 = [self nodeForCellTypeWithType:LLPublishCellTypeInputTitle];
        [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode1]];
        
        LLPublishCellNode *cellNode2 = [self nodeForCellTypeWithType:LLPublishCellTypeImage];
        [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode2]];
        
    } else if (self.currentPublishNode.redMold == 1) {
        
        LLPublishCellNode *cellNode = [[LLPublishCellNode alloc] init];
        cellNode.title = @"选择类型";
        cellNode.inputText = @"上传图片";
        if (self.currentPublishNode.taskMold == 1) {
            cellNode.inputText = @"输入链接";
        }
        cellNode.cellType = LLPublishCellTypeTaskMold;
        [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode]];
        
        LLPublishCellNode *cellNode1 = [self nodeForCellTypeWithType:LLPublishCellTypeTaskName];
        LLPublishCellNode *cellNode2 = [self nodeForCellTypeWithType:LLPublishCellTypeTaskExplain];
        [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode1, cellNode2, nil]];
        
        if (self.currentPublishNode.taskMold == 0) {
            
            LLPublishCellNode *cellNode1 = [self nodeForCellTypeWithType:LLPublishCellTypeInputTitle];
            [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode1]];
            
            LLPublishCellNode *cellNode2 = [self nodeForCellTypeWithType:LLPublishCellTypeImage];
            [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode2]];
            
        } else if (self.currentPublishNode.taskMold == 1) {
            LLPublishCellNode *cellNode2 = [self nodeForCellTypeWithType:LLPublishCellTypeLinkAddress];
            [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode2, nil]];
        }
    }
    
    LLPublishCellNode *cellNode3 = [self nodeForCellTypeWithType:LLPublishCellTypeLocation];
    [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode3]];
    
    LLPublishCellNode *cellNode4 = [self nodeForCellTypeWithType:LLPublishCellTypeRedAmount];
    LLPublishCellNode *cellNode5 = [self nodeForCellTypeWithType:LLPublishCellTypeRedCount];
    [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode4, cellNode5, nil]];
    
    LLPublishCellNode *cellNode6 = [self nodeForCellTypeWithType:LLPublishCellTypePubDate];
    LLPublishCellNode *cellNode7 = [self nodeForCellTypeWithType:LLPublishCellTypeVisible];
    [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode6, cellNode7, nil]];
    
    LLPublishCellNode *cellNode8 = [[LLPublishCellNode alloc] init];
    cellNode8.title = @"精准筛选";
    cellNode8.placeholder = @"最多选两项";
    cellNode8.cellType = LLPublishCellTypeMore;
    LLPublishCellNode *cellNode9 = [self nodeForCellTypeWithType:LLPublishCellTypeAge];
    LLPublishCellNode *cellNode10 = [self nodeForCellTypeWithType:LLPublishCellTypeSex];
    LLPublishCellNode *cellNode11 = [self nodeForCellTypeWithType:LLPublishCellTypeHobbies];
    if (self.currentPublishNode.isMore) {
        [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode8, cellNode9, cellNode10, cellNode11, nil]];
    } else {
        [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode8, nil]];
    }
    
    LLPublishCellNode *cellNode12 = [self nodeForCellTypeWithType:LLPublishCellTypeIntro];
    [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode12]];
    
    self.dataSource = [NSMutableArray arrayWithArray:newMutArray];
    [self.tableView reloadData];
}

- (void)refreshExchangeData {
    
    NSMutableArray *newMutArray = [NSMutableArray array];
    
    LLPublishCellNode *cellNode1 = [self nodeForCellTypeWithType:LLPublishCellTypeInputTitle];
    [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode1]];
    
    LLPublishCellNode *cellNode2 = [self nodeForCellTypeWithType:LLPublishCellTypeImage];
    [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode2]];
    
    LLPublishCellNode *cellNode3 = [self nodeForCellTypeWithType:LLPublishCellTypeShopAddress];
    [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode3]];
    
    LLPublishCellNode *cellNode40 = [self nodeForCellTypeWithType:LLPublishCellTypeOldPrice];
    LLPublishCellNode *cellNode4 = [self nodeForCellTypeWithType:LLPublishCellTypeExchangeCount];
    [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode40, cellNode4, nil]];
    
    LLPublishCellNode *cellNodeTip = [[LLPublishCellNode alloc] init];
    cellNodeTip.cellType = LLPublishCellTypeTip;
    [newMutArray addObject:[NSMutableArray arrayWithObject:cellNodeTip]];
    
    LLPublishCellNode *cellNode6 = [self nodeForCellTypeWithType:LLPublishCellTypePubDate];
    LLPublishCellNode *cellNode7 = [self nodeForCellTypeWithType:LLPublishCellTypeVisible];
    [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode6, cellNode7, nil]];
    
    LLPublishCellNode *cellNode8 = [[LLPublishCellNode alloc] init];
    cellNode8.title = @"设置电子券";
//    cellNode8.placeholder = @"最多选两项";
    cellNode8.cellType = LLPublishCellTypeMore;
    LLPublishCellNode *cellNode9 = [self nodeForCellTypeWithType:LLPublishCellTypeCouponName];
    LLPublishCellNode *cellNode10 = [self nodeForCellTypeWithType:LLPublishCellTypeCouponExplain];
    LLPublishCellNode *cellNode11 = [self nodeForCellTypeWithType:LLPublishCellTypeCouponPrice];
    LLPublishCellNode *cellNode12 = [self nodeForCellTypeWithType:LLPublishCellTypeCouponDate];
    if (self.currentPublishNode.isMore) {
        [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode8, cellNode9, cellNode10, cellNode11, cellNode12, nil]];
    } else {
        [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode8, nil]];
    }
    
    LLPublishCellNode *cellNode13 = [self nodeForCellTypeWithType:LLPublishCellTypeIntro];
    [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode13, nil]];
    
    self.dataSource = [NSMutableArray arrayWithArray:newMutArray];
    [self.tableView reloadData];
}

- (void)refreshAskData {
    
    NSMutableArray *newMutArray = [NSMutableArray array];
    
    LLPublishCellNode *cellNode1 = [self nodeForCellTypeWithType:LLPublishCellTypeInputTitle];
    [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode1]];
    
    LLPublishCellNode *cellNode2 = [self nodeForCellTypeWithType:LLPublishCellTypeImage];
    [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode2]];
    
    LLPublishCellNode *cellNode3 = [self nodeForCellTypeWithType:LLPublishCellTypeLocation];
    [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode3]];
    
    LLPublishCellNode *cellNode4 = [self nodeForCellTypeWithType:LLPublishCellTypeRedAmount];
    LLPublishCellNode *cellNode5 = [self nodeForCellTypeWithType:LLPublishCellTypeRedCount];
    [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode4, cellNode5, nil]];
    
    LLPublishCellNode *cellNode6 = [self nodeForCellTypeWithType:LLPublishCellTypePubDate];
    LLPublishCellNode *cellNode7 = [self nodeForCellTypeWithType:LLPublishCellTypeVisible];
    [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode6, cellNode7, nil]];
    
    LLPublishCellNode *cellNode12 = [self nodeForCellTypeWithType:LLPublishCellTypeIntro];
    [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode12]];
    
    self.dataSource = [NSMutableArray arrayWithArray:newMutArray];
    [self.tableView reloadData];
}

- (void)refreshConvenienceData {
    
    NSMutableArray *newMutArray = [NSMutableArray array];
    
    LLPublishCellNode *cellNode = [self nodeForCellTypeWithType:LLPublishCellTypeTradeMold];
    LLPublishCellNode *cellNode1 = [[LLPublishCellNode alloc] init];
    cellNode1.title = @"选择类型";
    cellNode1.inputText = @"个人";
    if (self.currentPublishNode.companyMold == 1) {
        cellNode1.inputText = @"企业";
    }
    cellNode1.cellType = LLPublishCellTypeCompanyMold;
    [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode, cellNode1, nil]];
    
    LLPublishCellNode *cellNode2 = [self nodeForCellTypeWithType:LLPublishCellTypePhone];
    [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode2, nil]];
    
    LLPublishCellNode *cellNode3 = [self nodeForCellTypeWithType:LLPublishCellTypeLocation];
    [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode3]];
    
    LLPublishCellNode *cellNode4 = [self nodeForCellTypeWithType:LLPublishCellTypeInputTitle];
    [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode4]];
    
    LLPublishCellNode *cellNode5 = [[LLPublishCellNode alloc] init];
    cellNode5.title = @"上传图片";
    cellNode5.uploadImageDatas = [NSMutableArray array];
    cellNode5.cellType = LLPublishCellTypeIDCard;
    [newMutArray addObject:[NSMutableArray arrayWithObject:cellNode5]];
    
    self.dataSource = [NSMutableArray arrayWithArray:newMutArray];
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
            cellNode.inputText = self.visibleMoldArray[self.currentPublishNode.visibleMold];
            break;
        case LLPublishCellTypeAge:
            cellNode.title = @"年龄状态";
            cellNode.titleFont = [FontConst PingFangSCRegularWithSize:12];
            cellNode.placeholder = @"请选择";
            if (self.currentPublishNode.ageMold >= 0 && self.ageArray.count > 0) {
                LLPubDataInfoNode *node = self.ageArray[self.currentPublishNode.ageMold];
                cellNode.inputText = node.DataContent;
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
                    LLPubDataInfoNode *node = self.hobbiesArray[row];
                    [mStr appendString:node.DataContent];
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
        case LLPublishCellTypeLocation:
            cellNode.title = @"选择位置";
            cellNode.placeholder = @"请选择";
            if (self.currentPublishNode.address.length > 0) {
                cellNode.inputText = self.currentPublishNode.address;
            }
            break;
        case LLPublishCellTypeExchangeCount:
            cellNode.title = @"蜂蜜兑换数";
            cellNode.placeholder = @"请输入";
            cellNode.inputType = LLPublishInputTypeInput;
            break;
        case LLPublishCellTypeOldPrice:
            cellNode.title = @"商品原价";
            cellNode.placeholder = @"请输入";
            cellNode.inputType = LLPublishInputTypeInput;
            break;
        case LLPublishCellTypeIntro:
            if (self.publishVcType == LLPublishViewcTypeExchange) {
                cellNode.title = @"兑换说明";
                cellNode.placeholder = @"输入文字...";
                cellNode.inputMaxCount = 200;
            } else {
                cellNode.title = @"红包任务介绍";
                cellNode.placeholder = @"红包任务介绍...";
            }
            break;
        case LLPublishCellTypeImage:
            cellNode.title = @"添加照片";
            cellNode.placeholder = @"最多9张";
            break;
        case LLPublishCellTypeShopAddress:{
            cellNode.title = @"到点地址";
            cellNode.placeholder = @"请添加";
            NSMutableString *addressText = [NSMutableString string];
            if (self.currentPublishNode.contacts.length > 0) [addressText appendString:self.currentPublishNode.contacts];
            if (self.currentPublishNode.phone.length > 0) [addressText appendFormat:@" %@",self.currentPublishNode.phone];
            if (self.currentPublishNode.address.length > 0) [addressText appendFormat:@" %@",self.currentPublishNode.address];
            if (self.currentPublishNode.houseNumber.length > 0) [addressText appendFormat:@" %@",self.currentPublishNode.houseNumber];
            cellNode.inputText = addressText;
        }
            break;
        case LLPublishCellTypePhone:
            cellNode.title = @"手机号";
            cellNode.placeholder = @"请输入";
            cellNode.inputType = LLPublishInputTypeInput;
            break;
        case LLPublishCellTypeInputTitle:
            cellNode.title = @"标题";
            cellNode.inputMaxCount = 200;
            cellNode.placeholder = @"输入文字...";
            break;
        case LLPublishCellTypeTaskName:
            cellNode.title = @"任务名称";
            cellNode.placeholder = @"请输入";
            cellNode.inputType = LLPublishInputTypeInput;
            break;
        case LLPublishCellTypeTaskExplain:
            cellNode.title = @"任务说明";
            cellNode.placeholder = @"输入文字...";
            break;
        case LLPublishCellTypeRedAmount:
            cellNode.title = @"红包金额";
            cellNode.placeholder = @"请输入";
            cellNode.inputType = LLPublishInputTypeInput;
            break;
        case LLPublishCellTypeRedCount:
            cellNode.title = @"红包个数";
            cellNode.placeholder = @"请输入";
            cellNode.inputType = LLPublishInputTypeInput;
            break;
        case LLPublishCellTypeCouponName:
            cellNode.title = @"优惠券名称";
            cellNode.titleFont = [FontConst PingFangSCRegularWithSize:12];
            cellNode.placeholder = @"请输入";
            cellNode.inputMaxCount = 20;
            cellNode.inputType = LLPublishInputTypeInput;
            break;
        case LLPublishCellTypeCouponExplain:
            cellNode.title = @"优惠券说明";
            cellNode.titleFont = [FontConst PingFangSCRegularWithSize:12];
            cellNode.placeholder = @"请输入";
            cellNode.inputMaxCount = 10;
            cellNode.inputType = LLPublishInputTypeInput;
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

#pragma mark - Request
- (void)getRedDataInfo {
//    [SVProgressHUD showCustomWithStatus:@"发布中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetDataInfo"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *caCheKey = @"GetDataInfo";
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
//        [SVProgressHUD dismiss];
//        if (requestType != WYRequestTypeSuccess) {
//            [SVProgressHUD showCustomErrorWithStatus:message];
//            return ;
//        }
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                NSDictionary *dic = data[0];
                id ageArray = dic[@"AgeList"];
                weakSelf.ageArray = [NSArray modelArrayWithClass:[LLPubDataInfoNode class] json:ageArray];
                id hobbyList = dic[@"HobbyList"];
                weakSelf.hobbiesArray = [NSArray modelArrayWithClass:[LLPubDataInfoNode class] json:hobbyList];
            }
        }
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];

}

- (void)publishGoodsRequest {
    [SVProgressHUD showCustomWithStatus:@"发布中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"AddGoodsInfo"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *title = [self nodeForCellTypeWithType:LLPublishCellTypeInputTitle].inputText;
    if (title.length > 0) [params setObject:title forKey:@"title"];
    
    NSMutableArray *imageDatas = [NSMutableArray array];
    for (NSData *imageData in [self nodeForCellTypeWithType:LLPublishCellTypeImage].uploadImageDatas) {
        NSString *dataStr = [imageData base64EncodedStringWithOptions:0];
        [imageDatas addObject:[NSString stringWithFormat:@"data:image/jpeg;base64,%@",dataStr]];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:imageDatas options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [params setObject:jsonStr forKey:@"imgUrl"];
    
    NSString *oldPrice = [self nodeForCellTypeWithType:LLPublishCellTypeOldPrice].inputText;
    if (oldPrice.length > 0) [params setObject:oldPrice forKey:@"oldPrice"];
    NSString *nowPrice = [self nodeForCellTypeWithType:LLPublishCellTypeExchangeCount].inputText;
    if (nowPrice.length > 0) [params setObject:nowPrice forKey:@"nowPrice"];
    [params setObject:[NSNumber numberWithInteger:self.currentPublishNode.visibleMold] forKey:@"visualUser"];
    
    if (self.currentPublishNode.phone.length > 0) [params setObject:self.currentPublishNode.phone forKey:@"phone"];
    if (self.currentPublishNode.contacts.length > 0) [params setObject:self.currentPublishNode.contacts forKey:@"contacts"];
    if (self.currentPublishNode.address.length > 0) {
        NSString *address = self.currentPublishNode.address;
        if (self.currentPublishNode.houseNumber.length > 0) {
            address = [NSString stringWithFormat:@"%@ %@",self.currentPublishNode.address, self.currentPublishNode.houseNumber];
        }
        [params setObject:address forKey:@"address"];
    }
    [params setObject:[NSNumber numberWithFloat:self.currentPublishNode.coordinate.longitude] forKey:@"longitude"];
    [params setObject:[NSNumber numberWithFloat:self.currentPublishNode.coordinate.latitude] forKey:@"latitude"];
    
    NSString *couponName = [self nodeForCellTypeWithType:LLPublishCellTypeCouponName].inputText;
    if (couponName.length > 0) [params setObject:couponName forKey:@"couponName"];
    NSString *couponExplain = [self nodeForCellTypeWithType:LLPublishCellTypeCouponExplain].inputText;
    if (couponExplain.length > 0) [params setObject:couponExplain forKey:@"couponExplain"];
    if (self.currentPublishNode.couponPrice.length > 0) [params setObject:self.currentPublishNode.couponPrice forKey:@"couponPrice"];
    NSString *convertExplain = [self nodeForCellTypeWithType:LLPublishCellTypeIntro].inputText;
    if (convertExplain.length > 0) [params setObject:convertExplain forKey:@"convertExplain"];

    NSString *releaseTime = @"";
    if (self.currentPublishNode.date) {
        releaseTime = [WYCommonUtils dateYearToDayDiscriptionFromDate:self.currentPublishNode.date];
    }
    if (releaseTime.length > 0) [params setObject:releaseTime forKey:@"release"];
    
    NSString *starTime = @"";
    if (self.currentPublishNode.couponBeginDate) {
        starTime = [WYCommonUtils dateYearToDayDiscriptionFromDate:self.currentPublishNode.couponBeginDate];
    }
    if (starTime.length > 0) [params setObject:starTime forKey:@"starTime"];
    
    NSString *endTime = @"";
    if (self.currentPublishNode.couponEndDate) {
        endTime = [WYCommonUtils dateYearToDayDiscriptionFromDate:self.currentPublishNode.couponEndDate];
    }
    if (endTime.length > 0) [params setObject:endTime forKey:@"endTime"];
    
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:message];
//        if ([dataObject isKindOfClass:[NSArray class]]) {
//            NSArray *data = (NSArray *)dataObject;
//            if (data.count > 0) {
//                NSDictionary *dic = data[0];
//            }
//        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:true];
        });
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

//便民
- (void)addFacilitateRequest {
    [SVProgressHUD showCustomWithStatus:@"发布中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"AddFacilitate"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *title = [self nodeForCellTypeWithType:LLPublishCellTypeInputTitle].inputText;
    if (title.length > 0) [params setObject:title forKey:@"title"];
    
    NSMutableArray *imageDatas = [NSMutableArray array];
    NSArray *uploadImages = [self nodeForCellTypeWithType:LLPublishCellTypeIDCard].uploadImageDatas;
    for (UIImage *image in uploadImages) {
        NSData *imageData = UIImageJPEGRepresentation(image, WY_IMAGE_COMPRESSION_QUALITY);
        NSString *dataStr = [imageData base64EncodedStringWithOptions:0];
        [imageDatas addObject:[NSString stringWithFormat:@"data:image/jpeg;base64,%@",dataStr]];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:imageDatas options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [params setObject:jsonStr forKey:@"imgUrl"];
    
    NSString *oneTypeId = [self.currentPublishNode.tradeMoldNode1.tId description];
    if (oneTypeId.length > 0) [params setObject:oneTypeId forKey:@"oneTypeId"];
    NSString *twoTypeId = [self.currentPublishNode.tradeMoldNode2.tId description];
    if (twoTypeId.length > 0) [params setObject:twoTypeId forKey:@"twoTypeId"];
    [params setObject:[NSNumber numberWithInteger:self.currentPublishNode.companyMold + 1] forKey:@"type"];
    
    NSString *phone = [self nodeForCellTypeWithType:LLPublishCellTypePhone].inputText;
    if (phone.length > 0) [params setObject:phone forKey:@"phone"];
    
    NSString *address = self.currentPublishNode.address;
    if (address.length > 0) [params setObject:address forKey:@"address"];
    [params setObject:[NSNumber numberWithFloat:self.currentPublishNode.coordinate.longitude] forKey:@"longitude"];
    [params setObject:[NSNumber numberWithFloat:self.currentPublishNode.coordinate.latitude] forKey:@"latitude"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:message];
        //        if ([dataObject isKindOfClass:[NSArray class]]) {
        //            NSArray *data = (NSArray *)dataObject;
        //            if (data.count > 0) {
        //                NSDictionary *dic = data[0];
        //            }
        //        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:true];
        });
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

//发布红包
- (void)addRedEnvelopesRequest {
    [SVProgressHUD showCustomWithStatus:@"发布中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"AddRedEnvelopes"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *title = [self nodeForCellTypeWithType:LLPublishCellTypeInputTitle].inputText;
    if (self.currentPublishNode.taskMold == 1) {
        title = [self nodeForCellTypeWithType:LLPublishCellTypeTaskName].inputText;
    }
    if (title.length == 0) title = @"";
    [params setObject:title forKey:@"title"];
    
    NSMutableArray *imageDatas = [NSMutableArray array];
    for (NSData *imageData in [self nodeForCellTypeWithType:LLPublishCellTypeImage].uploadImageDatas) {
        NSString *dataStr = [imageData base64EncodedStringWithOptions:0];
        [imageDatas addObject:[NSString stringWithFormat:@"data:image/jpeg;base64,%@",dataStr]];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:imageDatas options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [params setObject:jsonStr forKey:@"imgUrl"];
    
    NSInteger redMold = self.currentPublishNode.redMold + 1;
    if (self.publishVcType == LLPublishViewcTypeAsk) {
        redMold = 3;
    }
    [params setObject:[NSNumber numberWithInteger:redMold] forKey:@"redType"];
    
    NSInteger type = 0;//默认0
    if (self.currentPublishNode.redMold == 1) {
        type = self.currentPublishNode.taskMold + 1;
    }
    [params setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    
    NSString *taskName = [self nodeForCellTypeWithType:LLPublishCellTypeTaskName].inputText;
    if (taskName.length == 0) taskName = @"";
    [params setValue:taskName forKey:@"taskName"];
    NSString *taskSummary = [self nodeForCellTypeWithType:LLPublishCellTypeTaskExplain].inputText;
    if (taskSummary.length == 0) taskSummary = @"";
    [params setValue:taskSummary forKey:@"taskSummary"];
    [params setObject:[NSNumber numberWithInteger:self.currentPublishNode.visibleMold] forKey:@"visibleUser"];
    
    [params setObject:[NSNumber numberWithInteger:self.currentPublishNode.radiusType] forKey:@"radiusType"];
    NSString *address = self.currentPublishNode.address;
    if (address.length > 0) [params setObject:address forKey:@"address"];
    NSDecimalNumber *longitude = [[NSDecimalNumber alloc] initWithDouble:self.currentPublishNode.coordinate.longitude];
    NSDecimalNumber *latitude = [[NSDecimalNumber alloc] initWithDouble:self.currentPublishNode.coordinate.latitude];
    [params setValue:longitude forKey:@"longitude"];
    [params setValue:latitude forKey:@"latitude"];
    
    NSString *money = [self nodeForCellTypeWithType:LLPublishCellTypeRedAmount].inputText;
    if (money.length > 0) [params setObject:money forKey:@"money"];
    NSString *count = [self nodeForCellTypeWithType:LLPublishCellTypeRedCount].inputText;
    if (count.length > 0) [params setObject:count forKey:@"count"];
    
    NSString *screenAge = @"";
    if (self.currentPublishNode.ageMold >= 0 && self.ageArray.count > 0) {
        LLPubDataInfoNode *node = self.ageArray[self.currentPublishNode.ageMold];
        if (node.DataContent) screenAge = node.DataContent;
    }
    [params setObject:screenAge forKey:@"screenAge"];
    
    [params setObject:[NSNumber numberWithInteger:self.currentPublishNode.sexMold] forKey:@"screenSex"];
    
    NSString *hobbiesIndexs = @"||";
    NSMutableArray *hobbiesIds = [NSMutableArray array];
    for (id index in self.currentPublishNode.hobbiesIndexs) {
        LLPubDataInfoNode *node = [self.hobbiesArray objectAtIndex:[index integerValue]];
        [hobbiesIds addObject:node.Id];
    }
    if (hobbiesIds.count > 0) {
        hobbiesIndexs = [NSString stringWithFormat:@"|%@|",[hobbiesIds componentsJoinedByString:@"|"]];
    }
    [params setObject:hobbiesIndexs forKey:@"screenHobby"];
    
    NSString *releaseTime = @"0001-01-01";
    if (self.currentPublishNode.date) {
        releaseTime = [WYCommonUtils dateYearToDayDiscriptionFromDate:self.currentPublishNode.date];
    }
    if (releaseTime.length > 0) [params setObject:releaseTime forKey:@"releaseTime"];
    
    NSString *summary = [self nodeForCellTypeWithType:LLPublishCellTypeIntro].inputText;
    if (summary.length > 0) [params setObject:summary forKey:@"summary"];
    
    NSString *linkAddress = [self nodeForCellTypeWithType:LLPublishCellTypeLinkAddress].inputText;
    if (linkAddress.length == 0) linkAddress = @"";
    [params setValue:linkAddress forKey:@"urlAddress"];
    
    self.payType = 0;
    self.payPwd = [LELoginUserManager payPassWord];
    [params setObject:[NSNumber numberWithInteger:self.payType] forKey:@"payType"];
    [params setObject:self.payPwd forKey:@"payPwd"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:message];
        //        if ([dataObject isKindOfClass:[NSArray class]]) {
        //            NSArray *data = (NSArray *)dataObject;
        //            if (data.count > 0) {
        //                NSDictionary *dic = data[0];
        //            }
        //        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:true];
        });
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

#pragma mark - Action
- (void)publishAction:(id)sender {
    if (self.publishVcType == LLPublishViewcTypeExchange) {
        [self publishGoodsRequest];
    } else if (self.publishVcType == LLPublishViewcTypeConvenience) {
        [self addFacilitateRequest];
    } else {
        [self addRedEnvelopesRequest];
    }
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
    [ZJUsefulPickerView showSingleColPickerWithToolBarText:@"可见用户" withData:self.visibleMoldArray withDefaultIndex:weakSelf.currentPublishNode.visibleMold withCancelHandler:^{
        
    } withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
        weakSelf.currentPublishNode.visibleMold = selectedIndex;
        [weakSelf refreshDataSource];
    }];
}

- (void)chooseAge {
    NSMutableArray *tmpAgeArray = [NSMutableArray array];
    for (LLPubDataInfoNode *node in self.ageArray) {
        [tmpAgeArray addObject:node.DataContent];
    }
    WEAKSELF
    [ZJUsefulPickerView showSingleColPickerWithToolBarText:@"选择年龄阶段" withData:tmpAgeArray withDefaultIndex:self.currentPublishNode.ageMold withCancelHandler:^{
        
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
    NSMutableArray *hobbiesTitles = [NSMutableArray array];
    for (LLPubDataInfoNode *node in self.hobbiesArray) {
        [hobbiesTitles addObject:node.DataContent];
    }
    WEAKSELF
    [ZJUsefulPickerView showMultipleSelPickerWithToolBarText:@"选择兴趣爱好" withData:hobbiesTitles withDefaultIndexs:self.currentPublishNode.hobbiesIndexs withCancelHandler:^{
        
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
    
    WEAKSELF
    vc.chooseLocationCoordinateBlock = ^(CLLocationCoordinate2D currentCoordinate, NSString * _Nonnull address, NSInteger radiusType) {
        weakSelf.currentPublishNode.coordinate = currentCoordinate;
        weakSelf.currentPublishNode.address = address;
        weakSelf.currentPublishNode.radiusType = radiusType;
        [weakSelf refreshDataSource];
    };
}

- (void)chooseShopAddress {
    LLAddShopAddressViewController *vc = [[LLAddShopAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
    WEAKSELF
    vc.addShopAddressBlock = ^(LLPublishCellNode * _Nonnull shopAddressNode) {
        weakSelf.currentPublishNode.phone = shopAddressNode.phone;
        weakSelf.currentPublishNode.address = shopAddressNode.address;
        weakSelf.currentPublishNode.contacts = shopAddressNode.contacts;
        weakSelf.currentPublishNode.houseNumber = shopAddressNode.houseNumber;
        weakSelf.currentPublishNode.coordinate = shopAddressNode.coordinate;
        [weakSelf refreshDataSource];
    };
}

#pragma mark -
#pragma mark - DataSource
- (NSArray *)visibleMoldArray {
    if (!_visibleMoldArray) {
        _visibleMoldArray = @[@"所有人可见", @"本省可见", @"本市可见", @"本县区可见", @"关注自己可见"];
    }
    return _visibleMoldArray;
}

- (NSArray *)ageArray {
    if (!_ageArray) {
        _ageArray = [NSArray array];
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
        _hobbiesArray = [NSArray array];
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
    
    NSArray *array = self.dataSource[section];
    BOOL isTip = NO;
    if (array.count > 1) {
        LLPublishCellNode *node = array[1];
        if (node.cellType == LLPublishCellTypeExchangeCount) {
            isTip = YES;
        }
    }
    static NSString *headerIdentifier = @"UITableViewHeaderFooterView";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
        header.backgroundColor = kAppSectionBackgroundColor;
        header.contentView.backgroundColor = kAppSectionBackgroundColor;
        
        UIImageView *imgLine = [UIImageView new];
        imgLine.tag = 220;
        imgLine.backgroundColor = LineColor;
        [header addSubview:imgLine];
        [imgLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(header);
            make.height.mas_equalTo(0.5);
        }];
    }
    UIImageView *imgLine = (UIImageView *)[header viewWithTag:220];
    imgLine.hidden = isTip;
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
    } else if (cellNode.cellType == LLPublishCellTypeTip) {
        static NSString *cellIdentifier = @"LLPublishTipViewCell";
        LLPublishTipViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
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
