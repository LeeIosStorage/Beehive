//
//  LLRedRuleViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/3.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLRedRuleViewController.h"

@interface LLRedRuleViewController ()

@property (nonatomic, weak) IBOutlet UITextView *ruleTextView;

@end

@implementation LLRedRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"规则";
    if (self.vcType == LLInfoDetailsVcTypeNotice) {
        self.title = @"详情";
    } else if (self.vcType == LLInfoDetailsVcTypeAbout) {
        self.title = @"关于蜂巢";
        [self aboutMRedEnvelope];
    } else if (self.vcType == LLInfoDetailsVcTypeAdsBuyRule){
        self.title = @"购买规则";
        [self getBuyRule];
    } else if (self.vcType == LLInfoDetailsVcTypeQueenBeeExplain) {
        self.title = @"成为蜂王说明";
        [self getQueenBeeeExplain];
    } else if (self.vcType == LLInfoDetailsVcTypeRedRule) {
        self.title = @"红包规则";
        [self getRedExplain];
    }
    
    self.view.backgroundColor = kAppBackgroundColor;
    self.ruleTextView.textColor = kAppTitleColor;
    
    if (self.vcType == LLInfoDetailsVcTypeSignRule) {
        self.ruleTextView.text = @"1.签到抽奖规则，签到抽奖规则\n2.签到抽奖规则，签到抽奖规则";
    } else if (self.vcType == LLInfoDetailsVcTypeNotice) {
        self.ruleTextView.attributedText = [WYCommonUtils HTMLStringToColorAndFontAttributeString:self.text font:[FontConst PingFangSCRegularWithSize:13] color:kAppTitleColor];
    } else if (self.vcType == LLInfoDetailsVcTypeAbout) {
        self.ruleTextView.text = @"";
    }
}

- (void)refreshData {
    self.ruleTextView.attributedText = [WYCommonUtils HTMLStringToColorAndFontAttributeString:self.text font:[FontConst PingFangSCRegularWithSize:13] color:kAppTitleColor];
}

#pragma mark - Request
- (void)getBuyRule {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetBuyRule"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *caCheKey = @"GetBuyRule";
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                weakSelf.text = data[0];
            }
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)aboutMRedEnvelope {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"AboutMRedEnvelope"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *caCheKey = @"AboutMRedEnvelope";
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                weakSelf.text = data[0];
            }
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)getQueenBeeeExplain {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetQueenBeeeExplain"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *caCheKey = @"GetQueenBeeeExplain";
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                weakSelf.text = data[0];
            }
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)getRedExplain {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetRedExplain"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *caCheKey = @"GetRedExplain";
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                weakSelf.text = data[0];
            }
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

@end
