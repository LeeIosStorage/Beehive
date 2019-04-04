//
//  LLMineCollectTableViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMineCollectTableViewCell.h"
#import "LLHandleStatusView.h"
#import "LLRedpacketNode.h"
#import "LLMessageListNode.h"
#import "LLCollectionListNode.h"

@interface LLMineCollectTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imgIcon;

@property (nonatomic, weak) IBOutlet UILabel *labTitle;

@property (nonatomic, weak) IBOutlet LLHandleStatusView *handleStatusView;

@end

@implementation LLMineCollectTableViewCell

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
        
    } else if ([node isKindOfClass:[LLMessageListNode class]]) {
        LLMessageListNode *msgNode = (LLMessageListNode *)node;
        
        NSString *url = @"";
        if (msgNode.ImgUrls.count > 0) {
            url = msgNode.ImgUrls[0];
        }
        [WYCommonUtils setImageWithURL:[NSURL URLWithString:url] setImage:self.imgIcon setbitmapImage:[UIImage imageNamed:@""]];
        self.labTitle.text = msgNode.Title;
        
        [self.handleStatusView.readButton setTitle:[NSString stringWithFormat:@" %d", msgNode.LookCount] forState:UIControlStateNormal];
        [self.handleStatusView.commentButton setTitle:[NSString stringWithFormat:@" %d", msgNode.CommentCount] forState:UIControlStateNormal];
        [self.handleStatusView.favourButton setTitle:[NSString stringWithFormat:@" %d", msgNode.GoodCount] forState:UIControlStateNormal];
    } else if ([node isKindOfClass:[LLCollectionListNode class]]) {
        LLCollectionListNode *someNode = (LLCollectionListNode *)node;
        NSString *url = @"";
        if (someNode.ImgUrls.count > 0) {
            url = someNode.ImgUrls[0];
        }
        [WYCommonUtils setImageWithURL:[NSURL URLWithString:url] setImage:self.imgIcon setbitmapImage:[UIImage imageNamed:@""]];
        self.labTitle.text = someNode.Title;
        
        [self.handleStatusView.readButton setTitle:[NSString stringWithFormat:@" %d", someNode.LookCount] forState:UIControlStateNormal];
        [self.handleStatusView.commentButton setTitle:[NSString stringWithFormat:@" %d", someNode.CommentCount] forState:UIControlStateNormal];
        [self.handleStatusView.favourButton setTitle:[NSString stringWithFormat:@" %d", someNode.GoodsCount] forState:UIControlStateNormal];
    }
}

@end
