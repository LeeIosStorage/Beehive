//
//  LLPublishHistoryViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPublishHistoryViewController.h"
#import "LEPublishMenuView.h"
#import "LLPublishHistoryListViewController.h"

@interface LLPublishHistoryViewController ()

@end

@implementation LLPublishHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"发布历史";
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self showPublishView];
}

- (void)showPublishView {
    NSArray *items = [NSArray arrayWithObjects:
                      @{@"title":@"红包任务", @"icon":@"publish_red_task"},
                      @{@"title":@"兑换商品", @"icon":@"publish_duihuan"},
                      @{@"title":@"提问红包", @"icon":@"publish_tiwen"},
                      @{@"title":@"便民信息", @"icon":@"publish_bianmin"}, nil];
    [self addItems:items];
}

- (void)addItems:(NSArray *)items {
    for (int i = 0; i < items.count; i ++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:itemView];
        CGFloat top = 90;
        if (i > 1) {
            top = 90 + 82 + 60;
        }
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 82));
            if (i%2 == 0) {
                make.right.equalTo(self.view.mas_centerX).offset(-40);
            } else {
                make.left.equalTo(self.view.mas_centerX).offset(40);
            }
            make.top.equalTo(self.view).offset(top);
        }];
        
        NSDictionary *dic = items[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:dic[@"icon"]] forState:UIControlStateNormal];
        button.tag = 10 + i;
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(itemView);
            make.height.mas_equalTo(60);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kAppTitleColor;
        label.font = [FontConst PingFangSCRegularWithSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = dic[@"title"];
        [itemView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(itemView);
            make.centerX.equalTo(itemView);
        }];
    }
}

- (void)clickAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 10;
    
    LLPublishHistoryListViewController *vc = [[LLPublishHistoryListViewController alloc] init];
    if (index == 0) {
        vc.publishVcType = LLPublishViewcTypeRedpacket;
    } else if (index == 1) {
        vc.publishVcType = LLPublishViewcTypeExchange;
    } else if (index == 2) {
        vc.publishVcType = LLPublishViewcTypeAsk;
    } else if (index == 3) {
        vc.publishVcType = LLPublishViewcTypeConvenience;
    }
    [self.navigationController pushViewController:vc animated:true];
}

@end
