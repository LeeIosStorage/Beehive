//
//  LLBeePresentAffirmView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeePresentAffirmView.h"
#import "LLUserInfoNode.h"

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
    LLUserInfoNode *someNode = (LLUserInfoNode *)node;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:someNode.HeadImg] setImage:self.avatarImageView setbitmapImage:nil];
    self.nickNameLabel.text = someNode.UserName;
    self.phoneLabel.text = someNode.Phone;
    
    NSString *beeStr = [NSString stringWithFormat:@"赠送蜂蜜：¥ %.0f",someNode.Money];
    self.beeLabel.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:beeStr range:NSMakeRange(0, 5) font:[FontConst PingFangSCRegularWithSize:13] color:kAppTitleColor];
    
}

@end
