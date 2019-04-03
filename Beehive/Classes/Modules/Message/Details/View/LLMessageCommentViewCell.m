//
//  LLMessageCommentViewCell.m
//  Beehive
//
//  Created by liguangjun on 2019/3/6.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLMessageCommentViewCell.h"
#import "LLCommentNode.h"

@interface LLMessageCommentViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;

@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;

@property (nonatomic, weak) IBOutlet UIButton *btnAdoptAnswer;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentLabBottom;

@end

@implementation LLMessageCommentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.avatarImageView.layer.cornerRadius = 16.5;
    self.avatarImageView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)adoptAnswer:(id)sender {
    if (self.adoptAnswerBlock) {
        self.adoptAnswerBlock(self);
    }
}

- (void)updateCellWithData:(id)node {
    LLCommentNode *commentNode = (LLCommentNode *)node;
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:commentNode.HeadImg] setImage:self.avatarImageView setbitmapImage:nil];
    self.nickNameLabel.text = commentNode.UserName;
    self.timeLabel.text = [WYCommonUtils dateDiscriptionFromNowBk:[WYCommonUtils dateFromUSDateString:commentNode.AddTime]];
    self.contentLabel.text = commentNode.Contents;
    
    self.contentLabBottom.constant = 14;
    self.btnAdoptAnswer.hidden = true;
    if (commentNode.DataType == 3) {
        self.btnAdoptAnswer.hidden = false;
        self.contentLabBottom.constant = 50;
        self.btnAdoptAnswer.enabled = true;
        self.btnAdoptAnswer.backgroundColor = kAppThemeColor;
        [self.btnAdoptAnswer setTitle:@"采纳答案" forState:UIControlStateNormal];
        if (commentNode.IsOptimum) {
            self.btnAdoptAnswer.enabled = false;
            self.btnAdoptAnswer.backgroundColor = kAppLightTitleColor;
            [self.btnAdoptAnswer setTitle:@"已采纳" forState:UIControlStateNormal];
        }
    }
}

@end
