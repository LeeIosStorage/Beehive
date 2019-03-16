//
//  LLBuyAdViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBuyAdViewController.h"
#import "ZJPayPopupView.h"
#import "LLPayPasswordResetViewController.h"
#import "LLPaymentWayView.h"
#import "LEAlertMarkView.h"

@interface LLBuyAdViewController ()
<
ZJPayPopupViewDelegate
>
@property (nonatomic, strong) ZJPayPopupView *payPopupView;

@property (nonatomic, weak) IBOutlet UILabel *labUnitPrice;
@property (nonatomic, weak) IBOutlet UILabel *labMoney;
@property (nonatomic, weak) IBOutlet UILabel *labMaxDay;
@property (nonatomic, weak) IBOutlet UILabel *labBuyTip;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@property (nonatomic, assign) int dayCount;

@end

@implementation LLBuyAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"租广告位";
    self.dayCount = 1;
    self.textField.text = @"1";
}

- (void)paymentWayViewShow {
    [self.view endEditing:true];
    LLPaymentWayView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"LLPaymentWayView" owner:self options:nil] firstObject];
    tipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 265);
    [tipView updateCellWithData:nil];
    __weak UIView *weakView = tipView;
    WEAKSELF
    tipView.paymentBlock = ^(NSInteger type) {
        if ([weakView.superview isKindOfClass:[LEAlertMarkView class]]) {
            LEAlertMarkView *alert = (LEAlertMarkView *)weakView.superview;
            [alert dismiss];
        }
        if (type == 0) {
            [weakSelf payPopupViewShow];
        }
    };
    LEAlertMarkView *alert = [[LEAlertMarkView alloc] initWithCustomView:tipView type:LEAlertMarkViewTypeBottom];
    [alert show];
}

- (void)payPopupViewShow {
    self.payPopupView = [[ZJPayPopupView alloc] init];
    self.payPopupView.delegate = self;
    [self.payPopupView showPayPopView];
}

- (IBAction)minusAction:(id)sender {
    self.dayCount --;
    if (self.dayCount < 0) {
        self.dayCount = 0;
    }
    self.textField.text = [NSString stringWithFormat:@"%d",self.dayCount];
}

- (IBAction)addAction:(id)sender {
    self.dayCount ++;
    if (self.dayCount > 123) {
        self.dayCount = 123;
    }
    self.textField.text = [NSString stringWithFormat:@"%d",self.dayCount];
}

- (IBAction)bugAction:(id)sender {
    [self paymentWayViewShow];
}

#pragma mark - ZJPayPopupViewDelegate
- (void)didClickForgetPasswordButton
{
    LLPayPasswordResetViewController *vc = [[LLPayPasswordResetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)didPasswordInputFinished:(NSString *)password
{
    if ([password isEqualToString:@"147258"])
    {
        NSLog(@"输入的密码正确");
    }
    else
    {
        NSLog(@"输入错误:%@",password);
        [self.payPopupView didInputPayPasswordError];
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
    self.dayCount = [newString intValue];
    
    if (textField == self.textField && textField.markedTextRange == nil) {
        
    }
    return true;
}

@end
