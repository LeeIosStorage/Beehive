//
//  LLRedpacketDetailsViewController.m
//  Beehive
//
//  Created by liguangjun on 2019/3/14.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLRedpacketDetailsViewController.h"
#import "LLRedpacketDetailsHeaderView.h"
#import "LLMessageCommentViewCell.h"
#import "LLCommentBottomView.h"
#import "LEShareSheetView.h"
#import "LLRedTaskShowAlertView.h"
#import "LEAlertMarkView.h"
#import "LLRedrReceiveDetailsViewController.h"
#import "LLPersonalHomeViewController.h"
#import "LLRedpacketNode.h"
#import "LLCommentNode.h"

@interface LLRedpacketDetailsViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
LEShareSheetViewDelegate
>
{
    LEShareSheetView *_shareSheetView;
}
@property (nonatomic, strong) NSMutableArray *commentLists;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) LLRedpacketDetailsHeaderView *redpacketDetailsHeaderView;

@property (nonatomic, strong) LLCommentBottomView *commentBottomView;

@property (nonatomic, assign) NSInteger currentPage;

@property (assign, nonatomic) int nextCursor;

@end

@implementation LLRedpacketDetailsViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
    [self getRedDetail];
}

- (void)setup {
    self.title = @"红包详情";
    
    [self createBarButtonItemAtPosition:LLNavigationBarPositionRight normalImage:[UIImage imageNamed:@"message_details_more"] highlightImage:[UIImage imageNamed:@"message_details_more"] text:@"" action:@selector(moreAction:)];
    self.view.backgroundColor = kAppSectionBackgroundColor;
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.estimatedRowHeight = 73;
    _tableView.rowHeight = UITableViewAutomaticDimension;
//    _tableView
    _tableView.sectionFooterHeight = UITableViewAutomaticDimension;
    
    self.currentPage = 0;
    self.commentLists = [NSMutableArray array];
    if (self.redpacketNode.RedType == 3) {
        self.vcType = LLRedpacketDetailsVcTypeAsk;
    } else {
        self.vcType = LLRedpacketDetailsVcTypeTask;
    }
    
    self.tableView.tableHeaderView = self.redpacketDetailsHeaderView;
    [self.redpacketDetailsHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        //top布局一定要加上 不然origin.y可能为负值
        make.top.width.equalTo(self.tableView);
    }];
    
    [self.tableView reloadData];
    
    [self.view addSubview:self.commentBottomView];
    [self.commentBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(49);
    }];
    
    WEAKSELF
    self.redpacketDetailsHeaderView.segmentedHeadView.clickBlock = ^(NSInteger index) {
        if (index == 0) {
            weakSelf.currentPage = 0;
            [weakSelf.tableView reloadData];
        } else if (index == 1) {
            weakSelf.currentPage = 1;
            [weakSelf.tableView reloadData];
        }
    };
    self.redpacketDetailsHeaderView.redReceiveBlock = ^{
        LLRedrReceiveDetailsViewController *vc = [[LLRedrReceiveDetailsViewController alloc] init];
        vc.redId = [weakSelf.redpacketNode.Id description];
        [weakSelf.navigationController pushViewController:vc animated:true];
    };
    self.redpacketDetailsHeaderView.avatarBlock = ^{
        LLPersonalHomeViewController *vc = [[LLPersonalHomeViewController alloc] init];
        vc.userId = [weakSelf.redpacketNode.UserId description];
        [weakSelf.navigationController pushViewController:vc animated:true];
    };
    self.redpacketDetailsHeaderView.advertBlock = ^{
        if (weakSelf.redpacketNode.UrlAddress.length > 0) {
            [LELinkerHandler handleDealWithHref:weakSelf.redpacketNode.UrlAddress From:weakSelf.navigationController];
        }
    };
    
    self.nextCursor = 1;
    [self addMJ];
}

- (void)refreshData {
    
    if (self.redpacketNode.RedType == 3) {
        self.vcType = LLRedpacketDetailsVcTypeAsk;
    } else {
        self.vcType = LLRedpacketDetailsVcTypeTask;
    }
    self.redpacketDetailsHeaderView.type = self.vcType;
    [self.redpacketDetailsHeaderView updateCellWithData:self.redpacketNode];
    
    LLRedpacketDetailsHeaderView *headView = (LLRedpacketDetailsHeaderView *)self.tableView.tableHeaderView;
    [self.tableView layoutIfNeeded];
    self.tableView.tableHeaderView = headView;
    
    [self.tableView reloadData];
    
    [self refreshStateUI];
}

- (void)refreshStateUI {
    self.commentBottomView.btnCollect.selected = self.redpacketNode.IsCollection;
    self.commentBottomView.btnLike.selected = self.redpacketNode.IsGood;
}

#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    WEAKSELF;
    self.tableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        weakSelf.nextCursor = 1;
        [weakSelf getCommentList];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //上啦加载
    self.tableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getCommentList];
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

#pragma mark - Request
- (void)getRedDetail {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetRedDetail"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.redpacketNode.Id forKey:@"id"];
    NSString *caCheKey = [NSString stringWithFormat:@"GetRedDetail-%@",self.redpacketNode.Id];
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:[LLRedpacketNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                weakSelf.redpacketNode = data[0];
            }
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)getCommentList {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetCommentList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.redpacketNode.Id forKey:@"id"];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"pageIndex"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"pageSize"];
    //type：类别（1：普通红包；2：红包任务；3：提问红包；4：便民信息）；
    NSInteger type = 0;
    if (self.redpacketNode.RedType > 0) {
        type = self.redpacketNode.RedType;
    }
    [params setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    
    NSString *caCheKey = [NSString stringWithFormat:@"GetCommentList-%ld-%@", type,self.redpacketNode.Id];
    BOOL needCache = false;
    if (self.nextCursor == 1) needCache = true;
    [self.networkManager POST:requesUrl needCache:needCache caCheKey:caCheKey parameters:params responseClass:[LLCommentNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        NSArray *tmpListArray = [NSArray array];
        if ([dataObject isKindOfClass:[NSArray class]]) {
            tmpListArray = (NSArray *)dataObject;
        }
        if (weakSelf.nextCursor == 1) {
            weakSelf.commentLists = [NSMutableArray array];
        }
        [weakSelf.commentLists addObjectsFromArray:tmpListArray];
        
        if (!isCache) {
            if (tmpListArray.count < DATA_LOAD_PAGESIZE_COUNT) {
                [weakSelf.tableView.mj_footer setHidden:YES];
            }else{
                [weakSelf.tableView.mj_footer setHidden:NO];
                weakSelf.nextCursor ++;
            }
        }
        
        [weakSelf.tableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)sendComment:(NSString *)content {
    [self.view endEditing:true];
    [SVProgressHUD showCustomWithStatus:@"发送中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"CommentRedEnvelopes"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.redpacketNode.Id forKey:@"id"];
    [params setValue:content forKey:@"contents"];
    //type：类别（0：红包；1：便民信息）
    [params setObject:[NSNumber numberWithInteger:0] forKey:@"type"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLRedpacketNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:message];
        weakSelf.commentBottomView.textField.text = nil;
        [weakSelf.tableView.mj_header beginRefreshing];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)collectionRequest {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"RedEnvelopesCollection"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.redpacketNode.Id forKey:@"id"];
    //type：类别（0：商品；1：红包；2：便民信息）
    [params setObject:[NSNumber numberWithInt:1] forKey:@"type"];
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
                
            }
        }
        weakSelf.redpacketNode.IsCollection = !weakSelf.redpacketNode.IsCollection;
        [weakSelf refreshStateUI];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)likeRequest {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"RedEnvelopesGood"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.redpacketNode.Id forKey:@"id"];
    //type：类别（0：红包；1：便民信息）
    [params setObject:[NSNumber numberWithInt:0] forKey:@"type"];
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
                
            }
        }
        weakSelf.redpacketNode.IsGood = !weakSelf.redpacketNode.IsGood;
        [weakSelf refreshStateUI];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)adoptAnswerRequest:(LLCommentNode *)commentNode {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"AdoptAnswer"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:commentNode.Id forKey:@"id"];
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
                
            }
        }
        commentNode.IsOptimum = true;
        [weakSelf.tableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

#pragma mark - Action
- (void)moreAction:(id)sender {
    [self redTaskAlertViewShow];
}

- (void)shareAction {
    [self.view endEditing:true];
    LEShareModel *shareModel = [[LEShareModel alloc] init];
    shareModel.shareTitle = @"领红包";
    shareModel.shareDescription = @"";
    shareModel.shareWebpageUrl = [NSString stringWithFormat:@"%@/%@",[WYAPIGenerate sharedInstance].baseURL, kLLH5_DownLoad_Html_Url];
    //    shareModel.shareImage = [];
    _shareSheetView = [[LEShareSheetView alloc] init];
    _shareSheetView.owner = self;
    _shareSheetView.shareModel = shareModel;
    [_shareSheetView showShareAction];
}

- (void)redTaskAlertViewShow {
    LLRedTaskShowAlertView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"LLRedTaskShowAlertView" owner:self options:nil] firstObject];
    tipView.frame = CGRectMake(0, 0, 270, 115);
    __weak UIView *weakView = tipView;
    WEAKSELF
    tipView.clickBlock = ^{
        if ([weakView.superview isKindOfClass:[LEAlertMarkView class]]) {
            LEAlertMarkView *alert = (LEAlertMarkView *)weakView.superview;
            [alert dismiss];
        }
//        [weakSelf ];
    };
    LEAlertMarkView *alert = [[LEAlertMarkView alloc] initWithCustomView:tipView type:LEAlertMarkViewTypeCenter];
    [alert show];
}

- (void)adoptAnswerWithCell:(LLMessageCommentViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        LLCommentNode *node = self.commentLists[indexPath.row];
        [self adoptAnswerRequest:node];
    }
}

#pragma mark -
#pragma mark - NSNotification
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        [self.commentBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-keyboardRect.size.height);
        }];
        [self.view layoutIfNeeded];
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        [self.commentBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(0);
        }];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - set
- (LLRedpacketDetailsHeaderView *)redpacketDetailsHeaderView {
    if (!_redpacketDetailsHeaderView) {
        _redpacketDetailsHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LLRedpacketDetailsHeaderView" owner:self options:nil] firstObject];
    }
    return _redpacketDetailsHeaderView;
}

- (LLCommentBottomView *)commentBottomView {
    if (!_commentBottomView) {
        _commentBottomView = [[LLCommentBottomView alloc] init];
        
        WEAKSELF
        _commentBottomView.commentBottomViewSendBlock = ^(NSString * _Nonnull commentText) {
            [weakSelf sendComment:commentText];
        };
        _commentBottomView.commentBottomViewHandleBlock = ^(NSInteger index) {
            if (index == 0) {
                [weakSelf shareAction];
            } else if (index == 1) {
                [weakSelf likeRequest];
            } else if (index == 2) {
                [weakSelf collectionRequest];
            }
        };
    }
    return _commentBottomView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentPage == 1) {
        return 0;
    }
    return self.commentLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.currentPage == 0) {
        return 0;
    }
    return 130;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.currentPage == 0) {
        return nil;
    }
    static NSString *headerIdentifier = @"UITableViewHeaderFooterView";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
        header.backgroundColor = kAppBackgroundColor;
        header.contentView.backgroundColor = kAppBackgroundColor;
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kAppTitleColor;
        label.font = [FontConst PingFangSCRegularWithSize:13];
        label.numberOfLines = 0;
        label.tag = 201;
        [header.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(UIEdgeInsetsMake(15, 10, 25, 10));
            make.left.equalTo(header.contentView).offset(10);
            make.right.equalTo(header.contentView).offset(-10);
            make.top.equalTo(header.contentView).offset(10);
//            make.bottom.equalTo(header.contentView).offset(-10);
        }];
        
        UIImageView *imgLine = [UIImageView new];
        imgLine.backgroundColor = LineColor;
        [header.contentView addSubview:imgLine];
        [imgLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(header);
            make.height.mas_equalTo(0.5);
        }];
    }
    UILabel *label = (UILabel *)[header.contentView viewWithTag:201];
    label.text = self.redpacketNode.TaskSummary;
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LLMessageCommentViewCell";
    LLMessageCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    
    WEAKSELF
    cell.adoptAnswerBlock = ^(id  _Nonnull cell) {
        [weakSelf adoptAnswerWithCell:cell];
    };
    [cell updateCellWithData:self.commentLists[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    //    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self.view endEditing:YES];
    }
}

@end
