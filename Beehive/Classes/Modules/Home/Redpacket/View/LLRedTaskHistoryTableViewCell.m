//
//  LLRedTaskHistoryTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/14.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLRedTaskHistoryTableViewCell.h"
#import "LLHandleStatusView.h"
#import "LLRedTaskHistoryNode.h"

@interface LLRedTaskHistoryTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;

@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labTime;

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
    if ([node isKindOfClass:[LLRedpacketNode class]]) {
        LLRedpacketNode *redNode = (LLRedpacketNode *)node;
        NSString *url = @"";
        if (redNode.ImgUrls.count > 0) {
            url = redNode.ImgUrls[0];
        }
        [WYCommonUtils setImageWithURL:[NSURL URLWithString:url] setImage:self.imgIcon setbitmapImage:[UIImage imageNamed:@""]];
        self.labTitle.text = redNode.Title;
        
        [self.handleStatusView.readButton setTitle:[NSString stringWithFormat:@" %d", redNode.LookCount] forState:UIControlStateNormal];
        [self.handleStatusView.commentButton setTitle:[NSString stringWithFormat:@" %d", redNode.CommentCount] forState:UIControlStateNormal];
        [self.handleStatusView.favourButton setTitle:[NSString stringWithFormat:@" %d", redNode.GoodCount] forState:UIControlStateNormal];
        
        self.labTime.font = [FontConst PingFangSCRegularWithSize:11];
        NSString *dateStr = [WYCommonUtils dateMonthToDayDiscriptionFromDate:[WYCommonUtils dateFromUSDateString:redNode.ReleaseTime]];
        NSArray *dateArray = [dateStr componentsSeparatedByString:@"-"];
        if (dateArray.count > 1) {
            NSString *month = [dateArray objectAtIndex:0];
            NSString *day = [dateArray objectAtIndex:1];
            self.labTime.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:[NSString stringWithFormat:@"%@%@月", day, month] range:NSMakeRange(0, day.length) font:[FontConst PingFangSCMediumWithSize:17] color:kAppTitleColor];
        } else {
            self.labTime.text = @"";
        }
    }
}

@end
