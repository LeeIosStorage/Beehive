//
//  LLBeeLobbyHeaderView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/18.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeLobbyHeaderView.h"

@interface LLBeeLobbyHeaderView ()

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;

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
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.avatarImageView setbitmapImage:nil];
}

@end
