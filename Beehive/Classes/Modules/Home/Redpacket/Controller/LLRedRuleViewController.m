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
    } else if (self.vcType ==LLInfoDetailsVcTypeAbout) {
        self.title = @"关于蜂巢";
    }
    self.view.backgroundColor = kAppBackgroundColor;
    self.ruleTextView.textColor = kAppTitleColor;
    
    if (self.vcType == LLInfoDetailsVcTypeRule) {
        self.ruleTextView.text = @"1.签到抽奖规则，签到抽奖规则\n2.签到抽奖规则，签到抽奖规则";
    } else if (self.vcType == LLInfoDetailsVcTypeNotice) {
        self.ruleTextView.text = self.text;
    } else if (self.vcType == LLInfoDetailsVcTypeAbout) {
        self.ruleTextView.text = @"关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢关于蜂巢";
    }
}

@end
