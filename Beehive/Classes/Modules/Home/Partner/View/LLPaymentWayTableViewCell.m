//
//  LLPaymentWayTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPaymentWayTableViewCell.h"
#import "LLPaymentWayNode.h"

@interface LLPaymentWayTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;

@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labDes;

@end

@implementation LLPaymentWayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.btnRecharge.layer.borderColor = kAppThemeColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    LLPaymentWayNode *paymentWayNode = (LLPaymentWayNode *)node;
    self.iconImageView.image = [UIImage imageNamed:paymentWayNode.icon];
    self.labTitle.text = paymentWayNode.name;
    self.labDes.text = paymentWayNode.des;
    self.btnRecharge.hidden = true;
    if (paymentWayNode.type == 0) {
        self.btnRecharge.hidden = false;
    }
}

@end
