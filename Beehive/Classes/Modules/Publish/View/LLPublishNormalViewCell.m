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
<
UITextFieldDelegate
>
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
    self.tfDes.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    LLPublishCellNode *cellNode = (LLPublishCellNode *)node;
    self.node = cellNode;
    self.labTitle.text = cellNode.title;
    if (cellNode.inputMaxCount > 0 ) {
        NSString *maxText = [NSString stringWithFormat:@"(最多%d个字)",cellNode.inputMaxCount];
        NSString *attStr = [NSString stringWithFormat:@"%@%@",cellNode.title,maxText];
        self.labTitle.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:attStr range:NSMakeRange(cellNode.title.length, maxText.length) font:[FontConst PingFangSCRegularWithSize:10] color:kAppLightTitleColor];;
    }
    
    self.labDes.text = (cellNode.inputText && cellNode.inputText.length) > 0 ? cellNode.inputText : cellNode.placeholder;
    if (cellNode.inputType == LLPublishInputTypeSelect) {
        self.labDes.hidden = false;
        self.imgRight.hidden = false;
        self.tfDes.hidden = true;
        self.imgRight.image = [UIImage imageNamed:@"app_cell_right_icon"];
        self.labDes.textColor = kAppLightTitleColor;
        if (cellNode.inputText.length > 0) {
            self.labDes.textColor = kAppTitleColor;
        }
        if (cellNode.cellType == LLPublishCellTypeMore) {
            self.imgRight.image = [UIImage imageNamed:@"3_1_1.2"];
        }
        
    } else if (cellNode.inputType == LLPublishInputTypeInput) {
        self.labDes.hidden = true;
        self.imgRight.hidden = true;
        self.tfDes.hidden = false;
        self.tfDes.text = cellNode.inputText;
        
        self.tfDes.attributedPlaceholder = [WYCommonUtils stringToColorAndFontAttributeString:cellNode.placeholder range:NSMakeRange(0, cellNode.placeholder.length) font:[FontConst PingFangSCRegularWithSize:13] color:kAppLightTitleColor];
    }
    
    self.labTitle.font = [FontConst PingFangSCRegularWithSize:13];
    if (cellNode.titleFont) {
        self.labTitle.font = cellNode.titleFont;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        return false;
    }
//    if (!string.length && range.length > 0) {
//        return true;
//    }
    NSString *oldString = [textField.text copy];
    NSString *newString = [oldString stringByReplacingCharactersInRange:range withString:string];
    LLPublishCellNode *cellNode = (LLPublishCellNode *)self.node;
    cellNode.inputText = newString;
    
    if (textField == self.tfDes && textField.markedTextRange == nil) {
        if (cellNode.inputMaxCount > 0) {
            if (newString.length > cellNode.inputMaxCount && textField.text.length >= cellNode.inputMaxCount) {
                return NO;
            }
        }
    }
    return true;
}

@end
