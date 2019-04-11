//
//  LLFundHandleHeaderView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLFundHandleHeaderView.h"
#import "LLFundAmountCollectionViewCell.h"
#import "LLWalletDetailsNode.h"

static NSString *const kLLFundAmountViewCell = @"LLFundAmountCollectionViewCell";

@interface LLFundHandleHeaderView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UITextFieldDelegate
>

@property (nonatomic, strong) LLWalletDetailsNode *walletDetailsNode;

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
    self.textField.delegate = self;
    
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
    self.amountArray = [NSMutableArray arrayWithArray:@[@"10",@"20",@"50",@"100",@"200",@"500"]];
    if (_vcType == LLFundHandleVCTypeDeposit) {
        self.amountArray = [NSMutableArray arrayWithArray:@[@"10",@"20",@"30",@"40",@"50",@"100",@"200",@"500"]];
    }
    if (self.chooseAmountBlock) {
        if (self.vcType == LLFundHandleVCTypeDeposit) {
            NSString *amount = self.amountArray[0];
            if (self.textField.text.length > 0) {
                amount = self.textField.text;
            }
            self.chooseAmountBlock(amount);
            return;
        }
        NSString *amount = [NSString stringWithFormat:@"%.0f",[self.amountArray[0] intValue]/[LELoginUserManager exchangeRate]];
        self.chooseAmountBlock(amount);
    }
}

- (void)updateCellWithData:(id)node {
    self.walletDetailsNode = (LLWalletDetailsNode *)node;
    
    [self refreshRateTipLabel:[self.amountArray[0] floatValue]];
    
    int cny = [self.walletDetailsNode.Money intValue]*[LELoginUserManager exchangeRate];
    NSString *labBalance = [NSString stringWithFormat:@"%.2f蜂蜜(%d元)",[self.walletDetailsNode.Money floatValue], cny];
    self.labBalance.text = labBalance;
    
    if (_vcType == LLFundHandleVCTypeWithdraw) {
        self.textFieldConstraintH.constant = 0;
        self.labTipBalance.text = @"钱包余额";
        self.labTipAmount.text = @"提现金额";
        self.labTipExplain.text = @"提现说明";
        [self.btnSubmit setTitle:@"确认提现" forState:UIControlStateNormal];
        
        NSString *withdrawWayName = @"立即绑定";
        if (self.walletDetailsNode.NickName.length > 0) {
            withdrawWayName = self.walletDetailsNode.NickName;
        }
        self.labWithdrawWayName.text = withdrawWayName;
        self.labExplain.attributedText = [WYCommonUtils HTMLStringToColorAndFontAttributeString:self.walletDetailsNode.WithdrawalExplain font:[FontConst PingFangSCRegularWithSize:13] color:kAppTitleColor];
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
        self.labExplain.attributedText = [WYCommonUtils HTMLStringToColorAndFontAttributeString:self.walletDetailsNode.Explain font:[FontConst PingFangSCRegularWithSize:13] color:kAppTitleColor];
    }
}

- (void)refreshRateTipLabel:(CGFloat)money {
    CGFloat deduct = (self.walletDetailsNode.Ratio/100.0)*money;
    CGFloat account = money - deduct;
    self.labRateTip.text = [NSString stringWithFormat:@"扣除¥ %.2f（费率%d%%），实际到账%.2f", deduct, self.walletDetailsNode.Ratio, account];
}

- (IBAction)affirmAction:(id)sender {
    if (self.affirmBlock) {
        self.affirmBlock();
    }
}

- (IBAction)bindAction:(id)sender {
    if (self.bindWXBlock) {
        BOOL need = YES;
        if (self.walletDetailsNode.NickName.length > 0) {
            need = NO;
        }
        self.bindWXBlock(need);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        return false;
    }
    //    if (!string.length && range.length > 0) {
    //        return true;
    //    }
    NSString *oldString = [textField.text copy];
    NSString *newString = [oldString stringByReplacingCharactersInRange:range withString:string];
    
    if (self.chooseAmountBlock) {
        if (self.vcType == LLFundHandleVCTypeDeposit) {
            self.chooseAmountBlock(newString);
            if (newString.length > 0) {
                self.currentAmountId = -1;
                [self.amountCollectionView reloadData];
            } else {
                self.textField.text = newString;
                [self collectionView:self.amountCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }
        }
    }
    
//    if (textField == self.tfDes && textField.markedTextRange == nil) {
//        if (cellNode.inputMaxCount > 0) {
//            if (newString.length > cellNode.inputMaxCount && textField.text.length >= cellNode.inputMaxCount) {
//                return NO;
//            }
//        }
//    }
    return true;
}

- (CGSize)calculateGridImageViewSize {
    CGFloat viewWidth = (SCREEN_WIDTH-10*5)/4;
    if (self.vcType == LLFundHandleVCTypeWithdraw) {
        viewWidth = (SCREEN_WIDTH-10*4)/3;
    }
    return CGSizeMake(viewWidth, 48);
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
    cell.labAmount.textColor = kAppSubTitleColor;
    cell.labBeeCount.textColor = kAppTitleColor;
    if (self.currentAmountId == indexPath.row) {
        cell.layer.borderColor = kAppThemeColor.CGColor;
        cell.labAmount.textColor = kAppThemeColor;
        cell.labBeeCount.textColor = kAppThemeColor;
    }
    NSString *amount = self.amountArray[indexPath.row];
    NSString *beeCount = [NSString stringWithFormat:@"%.0f蜂蜜",[amount intValue]/[LELoginUserManager exchangeRate]];
    cell.labAmount.text = [NSString stringWithFormat:@"%@元",amount];
    cell.labBeeCount.text = beeCount;
    return cell;
}

#pragma mark
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.currentAmountId = indexPath.row;
    [self.amountCollectionView reloadData];
    NSString *money = self.amountArray[indexPath.row];
    [self refreshRateTipLabel:[money floatValue]];
    if (self.chooseAmountBlock) {
        if (self.vcType == LLFundHandleVCTypeDeposit) {
            NSString *amount = money;
            if (self.textField.text.length > 0) {
                amount = self.textField.text;
            }
            self.chooseAmountBlock(amount);
            return;
        }
        NSString *amount = [NSString stringWithFormat:@"%.0f",[money intValue]/[LELoginUserManager exchangeRate]];
        self.chooseAmountBlock(amount);
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
