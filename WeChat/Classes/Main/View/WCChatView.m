//
//  WCChatView.m
//  WeChat
//
//  Created by Donald on 15/6/16.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "WCChatView.h"

@implementation WCChatView


+(instancetype)inputView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"WCChatView" owner:nil options:nil] lastObject];
}


@end
