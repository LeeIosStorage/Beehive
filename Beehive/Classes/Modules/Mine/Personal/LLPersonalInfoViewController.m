//
//  LLPersonalInfoViewController.m
//  Beehive
//
//  Created by liguangjun on 2019/3/18.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLPersonalInfoViewController.h"
#import "LLPublishCellNode.h"
#import "LLPublishNormalViewCell.h"
#import "LLPublishIDCardViewCell.h"
#import "ZJUsefulPickerView.h"
#import "LEFeedbackViewController.h"
#import "NSString+Unwrapped.h"
#import "UIButton+WebCache.h"

@interface LLPersonalInfoViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LLPublishCellNode *currentPublishNode;

@property (nonatomic, strong) NSArray *sexArray;
@property (nonatomic, strong) NSArray *hobbiesArray;

@end

@implementation LLPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"个人信息";
    [self createBarButtonItemAtPosition:LLNavigationBarPositionRight normalImage:nil highlightImage:nil text:@"保存" action:@selector(saveAction:)];
    
    self.tableView.backgroundColor = kAppSectionBackgroundColor;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    
    self.currentPublishNode = [[LLPublishCellNode alloc] init];
    self.currentPublishNode.sexMold = [[LELoginUserManager sex] integerValue];
//    self.currentPublishNode.hobbiesIndexs = [LELoginUserManager ];
    
    [self refreshDataSource];
}

- (void)refreshDataSource {
    //    self.dataSource = [NSMutableArray array];
    
    NSMutableArray *newMutArray = [NSMutableArray array];
    //配置发布信息
    LLPublishCellNode *cellNode = [self nodeForCellTypeWithType:LLPublishCellTypeAvatar];
    LLPublishCellNode *cellNode1 = [self nodeForCellTypeWithType:LLPublishCellTypeNickName];
    [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode, cellNode1, nil]];
    
    LLPublishCellNode *cellNode2 = [self nodeForCellTypeWithType:LLPublishCellTypeSex];
    LLPublishCellNode *cellNode5 = [self nodeForCellTypeWithType:LLPublishCellTypeBirthdayDate];
    [newMutArray addObject:[NSMutableArray arrayWithObjects:cellNode2, cellNode5, nil]];
    
    LLPublishCellNode *cellNode3 = [self nodeForCellTypeWithType:LLPublishCellTypeHobbies];
    LLPublishCellNode *cellNode4 = [self nodeForCellTypeWithType:LLPublishCellTypeSignature];
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
        case LLPublishCellTypeAvatar:
            cellNode.title = @"头像";
            if (!cellNode.uploadImageDatas) {
                cellNode.uploadImageDatas = [NSMutableArray array];
            }
            break;
        case LLPublishCellTypeNickName:
            cellNode.title = @"昵称";
            cellNode.placeholder = @"请输入";
            cellNode.inputText = [LELoginUserManager nickName];
            cellNode.inputType = LLPublishInputTypeInput;
            break;
        case LLPublishCellTypeSex:
            cellNode.title = @"性别";
            cellNode.placeholder = @"未设置";
            if (self.currentPublishNode.sexMold >= 0) {
                cellNode.inputText = self.sexArray[self.currentPublishNode.sexMold];
            }
            break;
        case LLPublishCellTypeBirthdayDate:
            cellNode.title = @"生日";
            cellNode.placeholder = @"未设置";
            if (self.currentPublishNode.date) {
                cellNode.inputText = [WYCommonUtils dateYearToDayDiscriptionFromDate:self.currentPublishNode.date];
            }
            break;
        case LLPublishCellTypeHobbies:
            cellNode.title = @"兴趣爱好";
            cellNode.placeholder = @"未设置";
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
        case LLPublishCellTypeSignature:
            cellNode.title = @"签名";
            cellNode.placeholder = @"未设置";
//            cellNode.inputText = [LELoginUserManager ];
            break;
        default:
            break;
    }
    return cellNode;
}

#pragma mark - Request
- (void)updateUserInfoReqeust {
    [SVProgressHUD showCustomWithStatus:@"保存中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"UpdateUserInfo"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableArray *imageDatas = [NSMutableArray array];
    NSArray *uploadImages = [self nodeForCellTypeWithType:LLPublishCellTypeAvatar].uploadImageDatas;
    for (UIImage *image in uploadImages) {
        NSData *imageData = UIImageJPEGRepresentation(image, WY_IMAGE_COMPRESSION_QUALITY);
        NSString *dataStr = [imageData base64EncodedStringWithOptions:0];
        [imageDatas addObject:[NSString stringWithFormat:@"data:image/jpeg;base64,%@",dataStr]];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:imageDatas options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [params setObject:jsonStr forKey:@"headImg"];
    
    [params setObject:[self nodeForCellTypeWithType:LLPublishCellTypeBirthdayDate].inputText ? [self nodeForCellTypeWithType:LLPublishCellTypeBirthdayDate].inputText : @"" forKey:@"birthday"];
    NSString *name = [self nodeForCellTypeWithType:LLPublishCellTypeNickName].inputText;
    if (!name) name = @"";
    [params setObject:name forKey:@"name"];
    NSString *autograph = [self nodeForCellTypeWithType:LLPublishCellTypeSignature].inputText;
    if (!autograph) autograph = @"";
    [params setObject:autograph forKey:@"autograph"];
    NSString *hobbiesIndexs = @"";
    if (self.currentPublishNode.hobbiesIndexs.count > 0) {
        hobbiesIndexs = [self.currentPublishNode.hobbiesIndexs componentsJoinedByString:@","];
    }
    [params setObject:hobbiesIndexs forKey:@"hobbyIds"];
    [params setObject:[NSNumber numberWithInteger:self.currentPublishNode.sexMold] forKey:@"sex"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {

        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:message];
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                NSDictionary *dic = data[0];
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:true];
        });

    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

#pragma mark - Action
- (void)saveAction:(id)sender {
    [self updateUserInfoReqeust];
}

- (void)chooseSex {
    WEAKSELF
    [ZJUsefulPickerView showSingleColPickerWithToolBarText:@"选择性别" withData:self.sexArray withDefaultIndex:self.currentPublishNode.sexMold withCancelHandler:^{
        
    } withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
        weakSelf.currentPublishNode.sexMold = selectedIndex;
        [weakSelf refreshDataSource];
    }];
}

- (void)chooseBirthdayDate {
    WEAKSELF
    ZJDatePickerStyle *style = [ZJDatePickerStyle new];
    style.datePickerMode = UIDatePickerModeDate;
    style.maximumDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    NSDate *birthdayDate = [dateFormatter dateFromString:self.userModel.birthdayDate];
    //    if (birthdayDate == nil) {
    //        birthdayDate = [NSDate date];
    //    }
    //
    //    style.date = birthdayDate;
    
    [ZJUsefulPickerView showDatePickerWithToolBarText:@"生日" withStyle:style withValueDidChangedHandler:^(NSDate *selectedDate) {
        
    } withCancelHandler:^{
        
    } withDoneHandler:^(NSDate *selectedDate) {
        weakSelf.currentPublishNode.date = selectedDate;
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

- (void)writeSignature {
    LEFeedbackViewController *vc = [[LEFeedbackViewController alloc] init];
    vc.vcType = LLFillInfoVcTypeSign;
    [self.navigationController pushViewController:vc animated:true];
    
    WEAKSELF
    vc.submitBlock = ^(NSString *text) {
        [weakSelf nodeForCellTypeWithType:LLPublishCellTypeSignature].inputText = text;
        [weakSelf.tableView reloadData];
    };
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
    return 10;
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
    if (cellNode.cellType == LLPublishCellTypeAvatar) {
        
        static NSString *cellIdentifier = @"LLPublishIDCardViewCell";
        LLPublishIDCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
            cell.btn2.layer.cornerRadius = 32.5;
            cell.btn2.layer.masksToBounds = true;
        }
        cell.vc = self;
        [cell updateCellWithData:cellNode];
        if (cellNode.uploadImageDatas.count <= 0) {
            [cell.btn2 sd_setImageWithURL:[NSURL URLWithString:[LELoginUserManager headImgUrl]] forState:UIControlStateNormal];
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
        case LLPublishCellTypeSex: {
            [self chooseSex];
        }
            break;
        case LLPublishCellTypeBirthdayDate: {
            [self chooseBirthdayDate];
        }
            break;
        case LLPublishCellTypeHobbies: {
            [self chooseHobbies];
        }
            break;
        case LLPublishCellTypeSignature: {
            [self writeSignature];
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
