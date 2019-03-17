//
//  LLBeePresentAffirmView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeePresentAffirmView.h"

@interface LLBeePresentAffirmView ()

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *beeLabel;

@end

@implementation LLBeePresentAffirmView

- (void)setup {
    [super setup];
}

- (IBAction)cancelAction:(id)sender {
    if (self.clickBlock) {
        self.clickBlock(0);
    }
}

- (IBAction)affirmAction:(id)sender {
    if (self.clickBlock) {
        self.clickBlock(1);
    }
}

- (void)updateCellWithData:(id)node {
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.avatarImageView setbitmapImage:nil];
    self.nickNameLabel.text = @"郑和";
    
    NSString *beeStr = [NSString stringWithFormat:@"赠送蜂蜜：¥ %@",@"100.00"];
    self.beeLabel.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:beeStr range:NSMakeRange(0, 5) font:[FontConst PingFangSCRegularWithSize:13] color:kAppTitleColor];
    
}

@end
