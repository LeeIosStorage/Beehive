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
    self.ruleTextView.text = @"1.签到抽奖规则，签到抽奖规则\n2.签到抽奖规则，签到抽奖规则";
    self.ruleTextView.textColor = kAppTitleColor;
}

@end
