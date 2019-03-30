//
//  LLPaymentWayView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPaymentWayView.h"
#import "LLPaymentWayNode.h"
#import "LLPaymentWayTableViewCell.h"

@interface LLPaymentWayView ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UIButton *paymentButton;

@property (nonatomic, assign) NSInteger paymentWay;

@property (nonatomic, strong) NSMutableArray *paymentWayLists;

@end

@implementation LLPaymentWayView

- (void)setup {
    [super setup];
}

- (void)setWayType:(LLPaymentWayType *)wayType {
    _wayType = wayType;
}

- (void)refreshPaymentWay {
    self.paymentWayLists = [NSMutableArray array];
    if (_wayType == LLPaymentWayTypeNormal) {
        LLPaymentWayNode *node = [[LLPaymentWayNode alloc] init];
        node.type = 0;
        node.name = @"钱包支付";
        node.des = @"可用余额0元";
        node.icon = @"1_7_4.1";
        [self.paymentWayLists addObject:node];
    }
    
    LLPaymentWayNode *node1 = [[LLPaymentWayNode alloc] init];
    node1.type = 1;
    node1.name = @"微信支付";
    node1.des = @"推荐微信用户使用";
    node1.icon = @"1_7_4.2";
    [self.paymentWayLists addObject:node1];
    
    LLPaymentWayNode *node2 = [[LLPaymentWayNode alloc] init];
    node2.type = 2;
    node2.name = @"支付宝支付";
    node2.des = @"推荐支付宝用户使用";
    node2.icon = @"1_7_4.3";
    [self.paymentWayLists addObject:node2];
    
    [self.tableView reloadData];
}

- (void)updateCellWithData:(id)node {
    
    [self refreshPaymentWay];
    if (self.wayType == LLPaymentWayTypeNormal) {
        [self.paymentButton setTitle:@"支付213.8元" forState:UIControlStateNormal];
    } else if (self.wayType == LLPaymentWayTypeVIP) {
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.locations = @[@(0.0),@(1.0)];//渐变点
        [gradientLayer setColors:@[(id)[[UIColor colorWithHexString:@"#7680fe"] CGColor],(id)[[UIColor colorWithHexString:@"#a779ff"] CGColor]]];//渐变数组
        [self.paymentButton.layer addSublayer:gradientLayer];
        [self.paymentButton setTitle:@"确认支付" forState:UIControlStateNormal];
    }
}

- (IBAction)paymentAction:(id)sender {
    if (self.paymentBlock) {
        self.paymentBlock(self.paymentWay);
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.paymentWayLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LLPaymentWayTableViewCell";
    LLPaymentWayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
//    cell.indexPath = indexPath;
    LLPaymentWayNode *node = self.paymentWayLists[indexPath.row];
    [cell updateCellWithData:node];
    cell.typeImageView.highlighted = false;
    if (self.paymentWay == node.type) {
        cell.typeImageView.highlighted = true;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    LLPaymentWayNode *node = self.paymentWayLists[indexPath.row];
    self.paymentWay = node.type;
    [self.tableView reloadData];
    
}

@end
