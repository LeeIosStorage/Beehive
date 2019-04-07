//
//  LLBeeLobbyHeaderView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/18.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeLobbyHeaderView.h"
#import "LLQueenBeeInfoNode.h"

@interface LLBeeLobbyHeaderView ()

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;

@end

@implementation LLBeeLobbyHeaderView

- (void)setup {
    [super setup];
}

- (IBAction)beeKingAction:(id)sender {
    if (self.beeKingBlock) {
        self.beeKingBlock();
    }
}

- (IBAction)adsAction:(id)sender {
    if (self.handleBlock) {
        self.handleBlock(0);
    }
}

- (IBAction)inviteAction:(id)sender {
    if (self.handleBlock) {
        self.handleBlock(1);
    }
}

- (IBAction)robAction:(id)sender {
    if (self.handleBlock) {
        self.handleBlock(2);
    }
}

- (void)updateHeadViewWithData:(id)node {
    LLQueenBeeInfoNode *someNode = (LLQueenBeeInfoNode *)node;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:[LELoginUserManager headImgUrl]] setImage:self.avatarImageView setbitmapImage:nil];
    NSString *money = [NSString stringWithFormat:@"%.2f",someNode.Money];
    self.moneyLabel.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:[NSString stringWithFormat:@"%@元",money] range:NSMakeRange(money.length, 1) font:[FontConst PingFangSCRegularWithSize:12] color:kAppBackgroundColor];
}

@end
