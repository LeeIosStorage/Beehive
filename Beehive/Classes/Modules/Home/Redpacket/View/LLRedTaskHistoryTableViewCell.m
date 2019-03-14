//
//  LLRedTaskHistoryTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/14.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLRedTaskHistoryTableViewCell.h"
#import "LLHandleStatusView.h"

@interface LLRedTaskHistoryTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;

@property (nonatomic, weak) IBOutlet LLHandleStatusView *handleStatusView;

@end

@implementation LLRedTaskHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:@""] setImage:self.imgIcon setbitmapImage:[UIImage imageNamed:@"app_def"]];
}

@end
