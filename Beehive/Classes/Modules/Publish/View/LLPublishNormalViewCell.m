//
//  LLPublishNormalViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/8.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPublishNormalViewCell.h"
#import "LLPublishCellNode.h"

@interface LLPublishNormalViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UILabel *labDes;
@property (nonatomic, weak) IBOutlet UIImageView *imgRight;
@property (nonatomic, weak) IBOutlet UITextField *tfDes;

@end

@implementation LLPublishNormalViewCell

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
    self.labDes.text = (cellNode.inputText && cellNode.inputText.length) > 0 ? cellNode.inputText : cellNode.placeholder;
    if (cellNode.inputType == LLPublishInputTypeSelect) {
        self.labDes.hidden = false;
        self.imgRight.hidden = false;
        self.tfDes.hidden = true;
        self.imgRight.image = [UIImage imageNamed:@"app_cell_right_icon"];
        if (cellNode.cellType == LLPublishCellTypeMore) {
            self.imgRight.image = [UIImage imageNamed:@"3_1_1.2"];
        }
        
    } else if (cellNode.inputType == LLPublishInputTypeInput) {
        self.labDes.hidden = true;
        self.imgRight.hidden = true;
        self.tfDes.hidden = false;
        self.tfDes.text = cellNode.inputText;
        
        self.tfDes.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:cellNode.placeholder range:NSMakeRange(0, cellNode.placeholder.length) font:[FontConst PingFangSCRegularWithSize:13] color:kAppSubTitleColor];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    LLPublishCellNode *cellNode = (LLPublishCellNode *)self.node;
    cellNode.inputText = textField.text;
    return true;
}

@end
