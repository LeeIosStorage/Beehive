//
//  LLBeeKingUserShowView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/10.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeKingUserShowView.h"
#import "LLHomeNode.h"

@interface LLBeeKingUserShowView ()

@property (nonatomic, weak) IBOutlet UIImageView *imgAvatar;
@property (nonatomic, weak) IBOutlet UILabel *labName;
@property (nonatomic, weak) IBOutlet UILabel *labDes;

@end

@implementation LLBeeKingUserShowView

- (void)setup {
    [super setup];
    self.backgroundColor = [UIColor colorWithHexString:@"#555555"];
}

- (void)updateCellWithData:(id)node {
    LLHomeNode *someNode = (LLHomeNode *)node;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:someNode.QueenHeadImg] setImage:self.imgAvatar setbitmapImage:nil];
    self.labName.text = someNode.QueenName;
    self.labDes.text = [NSString stringWithFormat:@"%@蜂王", someNode.CountyName];
}

- (IBAction)avatarClickAction:(id)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
