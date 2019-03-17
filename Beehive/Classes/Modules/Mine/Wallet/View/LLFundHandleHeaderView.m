//
//  LLFundHandleHeaderView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLFundHandleHeaderView.h"
#import "LLFundAmountCollectionViewCell.h"

static NSString *const kLLFundAmountViewCell = @"LLFundAmountCollectionViewCell";

@interface LLFundHandleHeaderView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, weak) IBOutlet UIView *viewBalance;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewBalanceConstraintH;
@property (nonatomic, weak) IBOutlet UILabel *labTipBalance;
@property (nonatomic, weak) IBOutlet UILabel *labBalance;

@property (nonatomic, weak) IBOutlet UIView *viewWithdrawWay;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewWithdrawWayConstraintH;
@property (nonatomic, weak) IBOutlet UILabel *labWithdrawWayName;
@property (nonatomic, weak) IBOutlet UILabel *labWithdrawWay;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewSpaceConstraintH;

@property (nonatomic, weak) IBOutlet UILabel *labTipAmount;
@property (nonatomic, weak) IBOutlet UICollectionView *amountCollectionView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *collectionViewConstraintH;
@property (nonatomic, strong) NSMutableArray *amountArray;
@property (nonatomic, assign) NSInteger currentAmountId;

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textFieldConstraintH;

@property (nonatomic, weak) IBOutlet UIButton *btnSubmit;
@property (nonatomic, weak) IBOutlet UILabel *labRateTip;

@property (nonatomic, weak) IBOutlet UILabel *labTipExplain;
@property (nonatomic, weak) IBOutlet UILabel *labExplain;

@end

@implementation LLFundHandleHeaderView

- (void)setup {
    [super setup];
    
    self.currentAmountId = 0;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.amountCollectionView.collectionViewLayout = flowLayout;
    self.amountCollectionView.delegate = self;
    self.amountCollectionView.dataSource = self;
    self.amountCollectionView.showsHorizontalScrollIndicator = false;
    self.amountCollectionView.showsVerticalScrollIndicator = false;
    [self.amountCollectionView registerNib:[UINib nibWithNibName:kLLFundAmountViewCell bundle:nil] forCellWithReuseIdentifier:kLLFundAmountViewCell];
}

- (void)setVcType:(LLFundHandleVCType)vcType {
    _vcType = vcType;
    self.amountArray = [NSMutableArray arrayWithArray:@[@"1",@"5",@"10",@"20",@"50",@"100",@"200",@"500"]];
    if (_vcType == LLFundHandleVCTypeDeposit) {
        self.amountArray = [NSMutableArray arrayWithArray:@[@"10",@"20",@"30",@"40",@"50",@"100",@"200",@"500"]];
    }
}

- (void)updateCellWithData:(id)node {
    if (_vcType == LLFundHandleVCTypeWithdraw) {
        self.textFieldConstraintH.constant = 0;
        self.labTipBalance.text = @"钱包余额";
        self.labTipAmount.text = @"提现金额";
        self.labTipExplain.text = @"提现说明";
        [self.btnSubmit setTitle:@"确认提现" forState:UIControlStateNormal];
        self.labExplain.text = @"1. 提现说明提现说明提现说明提现说明。 \n2.提现说明提现说明提现说明提现说明提现说明提现说明。";
    } else if (_vcType == LLFundHandleVCTypeDeposit) {
        self.viewBalanceConstraintH.constant = 0;
        self.viewWithdrawWayConstraintH.constant = 0;
        self.viewSpaceConstraintH.constant = 0;
        self.labRateTip.hidden = true;
        self.labTipExplain.hidden = true;
        self.labExplain.hidden = true;
        self.labTipAmount.text = @"充值金额";
        [self.btnSubmit setTitle:@"确认充值" forState:UIControlStateNormal];
    } else if (_vcType == LLFundHandleVCTypePresent) {
        self.textFieldConstraintH.constant = 0;
        self.viewWithdrawWayConstraintH.constant = 0;
        self.labRateTip.hidden = true;
        self.labTipBalance.text = @"蜂蜜余额";
        self.labTipAmount.text = @"赠送金额";
        self.labTipExplain.text = @"赠送说明";
        [self.btnSubmit setTitle:@"确认赠送" forState:UIControlStateNormal];
        self.labExplain.text = @"1. 赠送说明。 \n2.赠送说明赠送说明赠送说明赠送说明赠送说明赠送说明赠送说明赠送说明赠送说明赠送说明赠送说明赠送说明赠送说明。";
    }
}

- (IBAction)affirmAction:(id)sender {
    if (self.affirmBlock) {
        self.affirmBlock();
    }
}

- (CGSize)calculateGridImageViewSize {
    CGFloat viewWidth = (SCREEN_WIDTH-10*5)/4;
    return CGSizeMake(viewWidth, 38);
}

#pragma mark
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.amountArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LLFundAmountCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLLFundAmountViewCell forIndexPath:indexPath];
    
    cell.layer.borderColor = LineColor.CGColor;
    cell.labAmount.textColor = kAppTitleColor;
    if (self.currentAmountId == indexPath.row) {
        cell.layer.borderColor = kAppThemeColor.CGColor;
        cell.labAmount.textColor = kAppThemeColor;
    }
    NSString *amount = self.amountArray[indexPath.row];
    cell.labAmount.text = [NSString stringWithFormat:@"%@元",amount];
    return cell;
}

#pragma mark
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.currentAmountId = indexPath.row;
    [self.amountCollectionView reloadData];
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
