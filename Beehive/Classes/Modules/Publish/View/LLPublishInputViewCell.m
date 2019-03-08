//
//  LLPublishInputViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/8.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPublishInputViewCell.h"
#import "LLPublishCellNode.h"

@interface LLPublishInputViewCell ()
<
UITextViewDelegate
>
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UIView *viewInputContainer;
@property (nonatomic, weak) IBOutlet UILabel *labPlaceholder;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation LLPublishInputViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.viewInputContainer.layer.cornerRadius = 2;
    self.viewInputContainer.layer.masksToBounds = true;
    
    self.textView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    LLPublishCellNode *cellNode = (LLPublishCellNode *)node;
    self.node = cellNode;
    self.labTitle.text = cellNode.title;
    self.labPlaceholder.text = cellNode.placeholder;
    self.textView.text = cellNode.inputText;
    
    self.labPlaceholder.hidden = (cellNode.inputText.length > 0);
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    LLPublishCellNode *cellNode = (LLPublishCellNode *)self.node;
    cellNode.inputText = textView.text;
    self.labPlaceholder.hidden = (cellNode.inputText.length > 0);
}

@end
