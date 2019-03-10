//
//  LLPublishChooseViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/10.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPublishChooseViewCell.h"
#import "LLPublishCellNode.h"

@interface LLPublishChooseViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UIImageView *imgview1;
@property (nonatomic, weak) IBOutlet UIImageView *imgview2;

@end

@implementation LLPublishChooseViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    LLPublishCellNode *cellNode = (LLPublishCellNode *)node;
    self.node = cellNode;
    self.labTitle.text = cellNode.title;
    self.imgview1.highlighted = true;
    self.imgview2.highlighted = false;
    if (cellNode.sexMold == 1) {
        self.imgview1.highlighted = false;
        self.imgview2.highlighted = true;
    }
}

- (IBAction)btn1Action:(id)sender {
    if (self.refreshBlock) {
        self.refreshBlock(0);
    }
}

- (IBAction)btn2Action:(id)sender {
    if (self.refreshBlock) {
        self.refreshBlock(1);
    }
}

@end
