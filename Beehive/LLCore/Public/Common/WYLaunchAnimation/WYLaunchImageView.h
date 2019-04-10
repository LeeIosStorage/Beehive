//
//  WYLaunchImageView.h
//  WangYu
//
//  Created by XuLei on 16/2/18.
//  Copyright © 2016年 KID. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYLaunchImageView : UIImageView

@property (nonatomic, strong) NSString *URLString;

@property (nonatomic, copy) void (^clickedImageURLHandle)(NSString *URLString);

@end
