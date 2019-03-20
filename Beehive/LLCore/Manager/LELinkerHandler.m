
//
//  LELinkerHandler.m
//  XWAPP
//
//  Created by hys on 2018/6/20.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LELinkerHandler.h"
//#import "DetailController.h"
#import "LEWebViewController.h"

@implementation LELinkerHandler

+(id)handleDealWithHref:(NSString *)href From:(UINavigationController*)nav{
    NSURL *realUrl = [NSURL URLWithString:href];
    if (realUrl == nil) {
        realUrl = [NSURL URLWithString:[href stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    NSString* scheme = [realUrl.scheme lowercaseString];
    if ([scheme isEqualToString:@"lecategory"]) {
        NSDictionary *paramDic = [WYCommonUtils getParamDictFromUrl:realUrl];
        if ([[realUrl host] isEqualToString:@"news"]){
            return nil;
//            DetailController *detailVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailController"];
//            detailVc.newsId = [[paramDic objectForKey:@"objId"] description];
//            return detailVc;
        }
        return nil;
        
    } else if([scheme hasPrefix:@"http"]){
        LEWebViewController *vc = [[LEWebViewController alloc] initWithURLString:href];
        [nav pushViewController:vc animated:true];
    }
    return nil;
}

@end
