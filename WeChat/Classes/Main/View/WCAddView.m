//
//  WCAddView.m
//  WeChat
//
//  Created by Donald on 15/6/17.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "WCAddView.h"

@implementation WCAddView


+(instancetype)addView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"WCAddView" owner:nil options:nil] lastObject];
}

@end
