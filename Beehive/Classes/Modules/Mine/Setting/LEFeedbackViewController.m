//
//  LEFeedbackViewController.m
//  XWAPP
//
//  Created by hys on 2018/6/25.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEFeedbackViewController.h"

@interface LEFeedbackViewController ()
<
UITextViewDelegate
>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;

@end

@implementation LEFeedbackViewController

#pragma mark -
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupSubview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Private
- (void)setupSubview{
    [self setTitle:@"意见反馈"];
    if (self.vcType == LLFillInfoVcTypeSign) {
        self.title = @"签名";
    }
    self.view.backgroundColor = kAppBackgroundColor;
}

- (NSInteger)refreshTipLabel{
    NSInteger length = 200 - self.textView.text.length;
    self.tipLabel.text = [NSString stringWithFormat:@"还剩%ld字",length];
    self.tipLabel.textColor = [UIColor colorWithHexString:@"999999"];
    if (length < 0) {
        self.tipLabel.textColor = [UIColor redColor];
    }
    return length;
}

#pragma mark -
#pragma mark - Request
- (void)publishRequest{
    
    [self.textView resignFirstResponder];
    self.publishButton.enabled = NO;
    [SVProgressHUD showCustomWithStatus:nil];
    WEAKSELF;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"ReleaseFeedBack"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.textView.text forKey:@"contents"];
    [params setObject:self.textView.text forKey:@"title"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        self.publishButton.enabled = YES;
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        [SVProgressHUD showCustomInfoWithStatus:message];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(id responseObject, NSError *error) {
        self.publishButton.enabled = YES;
    }];
}

#pragma mark -
#pragma mark - IBActions
- (IBAction)publishAction:(id)sender {
    
    self.textView.text = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (self.vcType == LLFillInfoVcTypeSign) {
        if (self.textView.text.length == 0) {
            [SVProgressHUD showCustomInfoWithStatus:@"请输入您的签名"];
            return;
        }
        if (self.submitBlock) {
            self.submitBlock(self.textView.text);
        }
        [self.navigationController popViewControllerAnimated:true];
        return;
    }
    
    if (self.textView.text.length == 0) {
        [SVProgressHUD showCustomInfoWithStatus:@"请输入您想反馈的意见"];
        return;
    }
    [self publishRequest];
}

#pragma mark -
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    self.placeholderLabel.hidden = false;
    if (textView.text.length > 0) {
        self.placeholderLabel.hidden = true;
    }
    if ([self refreshTipLabel] < 0) {
        self.textView.text = [textView.text substringWithRange:NSMakeRange(0, 200)];
    }
    [self refreshTipLabel];
}

@end

