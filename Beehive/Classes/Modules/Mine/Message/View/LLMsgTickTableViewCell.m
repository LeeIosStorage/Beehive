//
//  LLMsgTickTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/13.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMsgTickTableViewCell.h"
#import "LLCellOriginalContentView.h"
#import "LLNoticeNode.h"

@interface LLMsgTickTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labDes;
@property (nonatomic, weak) IBOutlet LLCellOriginalContentView *oriContentView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *oriContentViewConstraintH;

@end

@implementation LLMsgTickTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgIcon.layer.cornerRadius = 14;
    self.imgIcon.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    LLNoticeNode *someNode = (LLNoticeNode *)node;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:someNode.HeadImg] setImage:self.imgIcon setbitmapImage:nil];
    NSString *userName = someNode.UserName;
    self.labTitle.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:[NSString stringWithFormat:@"%@ %@",userName, someNode.Title] range:NSMakeRange(0, userName.length) font:self.labTitle.font color:[UIColor colorWithHexString:@"#a597fe"]];
//    self.labTitle.text = someNode.UserName;
    self.labDes.text = someNode.AddTime;
    
    NSString *url = @"";
    if (someNode.ImgUrls.count > 0) {
        url = someNode.ImgUrls[0];
    }
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:url] setImage:self.oriContentView.imgIcon setbitmapImage:nil];
    self.oriContentView.labTitle.text = someNode.DataTitle;
    self.oriContentView.labDes.text = someNode.DataAddTime;
    
    if (someNode.NoticeType == 1) {
        self.oriContentViewConstraintH.constant = 85;
        self.oriContentView.hidden = false;
    } else {
        self.oriContentViewConstraintH.constant = 0;
        self.oriContentView.hidden = true;
        self.labTitle.text = someNode.Title;
    }
}

@end
