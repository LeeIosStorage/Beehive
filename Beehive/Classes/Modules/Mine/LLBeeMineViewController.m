//
//  LLBeeMineViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/2/27.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeMineViewController.h"
#import "LLMessageDetailsViewController.h"
#import "LLMineCollectionViewCell.h"
#import "LLMineCollectionHeaderView.h"
#import "LLMineNode.h"
#import "LLMessageViewController.h"
#import "LLMineWalletViewController.h"
#import "LLBeeQunViewController.h"
#import "LLCollectListViewController.h"
#import "LLAttentionListViewController.h"
#import "LLPublishHistoryViewController.h"
#import "LLBeeLobbyViewController.h"
#import "LLBeeTaskViewController.h"
#import "LLInvitationCodeViewController.h"
#import "LLExchangeOrderViewController.h"
#import "LLNoticeViewController.h"
#import "LLSettingViewController.h"
#import "LLBeeVIPViewController.h"
#import "LLTuiSpecialistViewController.h"
#import "LLPersonalInfoViewController.h"
#import "LLEditAdViewController.h"

static NSString *const kLLMineCollectionViewCell = @"LLMineCollectionViewCell";
static NSString *const kLLMineCollectionHeaderView = @"LLMineCollectionHeaderView";

@interface LLBeeMineViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation LLBeeMineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

#pragma mark -
#pragma mark - Private
- (void)setup {
    self.navigationItem.title = @"我的";
    
    self.view.backgroundColor = kAppSectionBackgroundColor;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 245);
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.alwaysBounceVertical = true;
    UIEdgeInsets insets = self.collectionView.contentInset;
    insets.top = -HitoStatusBarHeight;
    self.collectionView.contentInset = insets;
    
    [self.collectionView registerNib:[UINib nibWithNibName:kLLMineCollectionViewCell bundle:nil] forCellWithReuseIdentifier:kLLMineCollectionViewCell];
    [self.collectionView registerNib:[UINib nibWithNibName:kLLMineCollectionHeaderView bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLLMineCollectionHeaderView];
    
    
    self.dataSource = [NSMutableArray array];
    for (int i = 0; i < 12; i ++) {
        LLMineNode *node = [[LLMineNode alloc] init];
        if (i == 0) { node.title = @"钱包"; node.icon = @"5_0.7"; node.vcType = i;}
        if (i == 1) {node.title = @"蜂群"; node.icon = @"5_0.8"; node.vcType = i;}
        if (i == 2) {node.title = @"蜂王大厅"; node.icon = @"5_0.9"; node.vcType = i;}
        if (i == 3) {node.title = @"蜂巢任务"; node.icon = @"5_0.10"; node.vcType = i;}
        if (i == 4) {node.title = @"邀请码"; node.icon = @"5_0.11"; node.vcType = i;}
        if (i == 5) {node.title = @"兑换订单"; node.icon = @"5_0.12"; node.vcType = i;}
        if (i == 6) {node.title = @"系统公告"; node.icon = @"5_0.13"; node.vcType = i;}
        if (i == 7) {node.title = @"帮助中心"; node.icon = @"5_0.14"; node.vcType = i;}
        if (i == 8) {node.title = @"更多设置"; node.icon = @"5_0.15"; node.vcType = i;}
        if (i == 9) {node.title = @"徽章VIP"; node.icon = @"5_0.16"; node.vcType = i;}
        if (i == 10) {node.title = @"推广专员"; node.icon = @"5_0.17"; node.vcType = i;}
        if (i == 11) {node.title = @"广告图"; node.icon = @"5_0.12"; node.vcType = i;}
        [self.dataSource addObject:node];
    }
    
    [self.collectionView reloadData];
}

- (CGSize)calculateGridImageViewSize {
    CGFloat viewWidth = SCREEN_WIDTH/3;
    return CGSizeMake(viewWidth, 80);
}

#pragma mark -
#pragma mark - Action
- (void)messageAction {
    LLMessageViewController *vc = [[LLMessageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)avatarAction {
    LLPersonalInfoViewController *vc = [[LLPersonalInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)mineCollectAction {
    LLCollectListViewController *vc = [[LLCollectListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)mineAttentionAction {
    LLAttentionListViewController *vc = [[LLAttentionListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)historyAction {
    LLPublishHistoryViewController *vc = [[LLPublishHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark -
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        LLMineCollectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLLMineCollectionHeaderView forIndexPath:indexPath];
        WEAKSELF
        header.headerViewClickBlock = ^(NSInteger index) {
            if (index == 0) {
                [weakSelf messageAction];
            } else if (index == 1) {
                [weakSelf mineCollectAction];
            } else if (index == 2) {
                [weakSelf mineAttentionAction];
            } else if (index == 3) {
                [weakSelf historyAction];
            } else if (index == 4) {
                [weakSelf avatarAction];
            }
        };
        [header updateHeadViewWithData:nil];
        return header;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LLMineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLLMineCollectionViewCell forIndexPath:indexPath];
    
    [cell updateCellWithData:self.dataSource[indexPath.row]];
    return cell;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LLMineNode *node = self.dataSource[indexPath.row];
    switch (node.vcType) {
        case LLMineNodeTypeWallet: {
            LLMineWalletViewController *vc = [[LLMineWalletViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case LLMineNodeTypeBeeQun: {
            LLBeeQunViewController *vc = [[LLBeeQunViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case LLMineNodeTypeBeeLobby: {
            LLBeeLobbyViewController *vc = [[LLBeeLobbyViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case LLMineNodeTypeBeeTask: {
            LLBeeTaskViewController *vc = [[LLBeeTaskViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case LLMineNodeTypeCode: {
            LLInvitationCodeViewController *vc = [[LLInvitationCodeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case LLMineNodeTypeOrder: {
            LLExchangeOrderViewController *vc = [[LLExchangeOrderViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case LLMineNodeTypeNotice: {
            LLNoticeViewController *vc = [[LLNoticeViewController alloc] init];
            vc.vcType = LLNoticeVcTypeNotice;
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case LLMineNodeTypeHelp: {
            LLNoticeViewController *vc = [[LLNoticeViewController alloc] init];
            vc.vcType = LLNoticeVcTypeHelp;
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case LLMineNodeTypeSet: {
            LLSettingViewController *vc = [[LLSettingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case LLMineNodeTypeVIP: {
            LLBeeVIPViewController *vc = [[LLBeeVIPViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case LLMineNodeTypeTui: {
            LLTuiSpecialistViewController *vc = [[LLTuiSpecialistViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case LLMineNodeTypeAdvert: {
            LLEditAdViewController *vc = [[LLEditAdViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        default:
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self calculateGridImageViewSize];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
