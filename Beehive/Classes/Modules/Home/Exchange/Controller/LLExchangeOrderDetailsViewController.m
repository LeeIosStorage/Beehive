//
//  LLExchangeOrderDetailsViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLExchangeOrderDetailsViewController.h"

@interface LLExchangeOrderDetailsViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UIImageView *imgAvatar;
@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;
@property (nonatomic, weak) IBOutlet UIImageView *imgSex;
@property (nonatomic, weak) IBOutlet UILabel *labNickName;

@property (nonatomic, weak) IBOutlet UILabel *labShopName;
@property (nonatomic, weak) IBOutlet UILabel *labShopTipName;

@property (nonatomic, weak) IBOutlet UILabel *labQuanPrice;
@property (nonatomic, weak) IBOutlet UILabel *labTime;
@property (nonatomic, weak) IBOutlet UILabel *labValidity;
@property (nonatomic, weak) IBOutlet UILabel *labFull;
@property (nonatomic, weak) IBOutlet UILabel *labScope;

@property (nonatomic, weak) IBOutlet UILabel *labAddress;

@property (nonatomic, weak) IBOutlet UILabel *labExchangeType;
@property (nonatomic, weak) IBOutlet UILabel *labExchangePhone;
@property (nonatomic, weak) IBOutlet UILabel *labExchangeDate;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LLExchangeOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
    [self refreshDataRequest];
}

- (void)setup {
    self.title = @"详情";
    
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    self.headerView.height = 445;
    self.tableView.tableHeaderView = self.headerView;
    
    [self.tableView reloadData];
}

- (void)refreshData {
    
    [self refreshHeadViewUI];
    [self.tableView reloadData];
}

- (void)refreshHeadViewUI {
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:self.exchangeOrderNode.HeadImg] setImage:self.imgAvatar setbitmapImage:nil];
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:self.exchangeOrderNode.GoodsImg] setImage:self.imgIcon setbitmapImage:nil];
    UIImage *sexImage = [UIImage imageNamed:@"user_sex_man"];
    if (self.exchangeOrderNode.Sex == 1) {
        sexImage = [UIImage imageNamed:@"user_sex_woman"];
    }
    self.imgSex.image = sexImage;
    self.labNickName.text = self.exchangeOrderNode.UserName;
    
    self.labShopName.text = self.exchangeOrderNode.GoodsName;
    self.labShopTipName.text = [NSString stringWithFormat:@"实付%@蜂蜜",self.exchangeOrderNode.Money];
    
    NSString *buyType = @"";
    if (self.exchangeOrderNode.BuyType == 1) {
        buyType = @"电子券";
    }
    self.labExchangeType.text = [NSString stringWithFormat:@"兑换类型：%@", buyType];
    self.labExchangePhone.text = [NSString stringWithFormat:@"商家电话：%@", self.exchangeOrderNode.Phone];
    self.labExchangeDate.text = [NSString stringWithFormat:@"兑换时间：%@", self.exchangeOrderNode.AddTime];
    
    self.labAddress.text = self.exchangeOrderNode.Address;
    
    self.labQuanPrice.text = [NSString stringWithFormat:@"¥ %@",self.exchangeOrderNode.CouponMoney];
    self.labFull.text = self.exchangeOrderNode.CouponExplain;
    self.labScope.text = self.exchangeOrderNode.CouponName;
    self.labTime.text = self.exchangeOrderNode.CouponTime;
    self.labValidity.text = [NSString stringWithFormat:@"有效期%ld天",self.exchangeOrderNode.Days];
    
}

#pragma mark - Request
- (void)refreshDataRequest {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetBuyDetail"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.exchangeOrderNode.Id forKey:@"id"];
    NSString *caCheKey = [NSString stringWithFormat:@"GetBuyDetail-%@",self.exchangeOrderNode.Id];
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:[LLExchangeOrderNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                weakSelf.exchangeOrderNode = data[0];
            }
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (IBAction)callTelAction:(id)sender {
    [WYCommonUtils callTelephone:self.exchangeOrderNode.Phone];
}

#pragma mark - SetGet
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 57;
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

@end
