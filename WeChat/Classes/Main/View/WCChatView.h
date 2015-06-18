//
//  WCChatView.h
//  WeChat
//
//  Created by Donald on 15/6/16.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCChatView : UIView
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;

+(instancetype)inputView;

@end
