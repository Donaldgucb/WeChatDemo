//
//  WCAddContactsViewController.m
//  WeChat
//
//  Created by Donald on 15/6/15.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "WCAddContactsViewController.h"

@interface WCAddContactsViewController ()<UITextFieldDelegate>


@end

@implementation WCAddContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    
}


#pragma mark textField代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSString *user = textField.text;
    
    if (![textField isTelphoneNum]) {
        [self showAlert:@"请输入正确的手机号码"];
        return YES;
    }
    
    //不能添加自己为好友
    if ([user isEqualToString:[WCUserInfo sharedWCUserInfo].user]) {
        [self showAlert:@"不能添加自己为好友"];
        
        return YES;
    }
    
    
    
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@",user,domain];
    
    XMPPJID *friendJid = [XMPPJID jidWithString:jidStr];
    
    
    //不能添加已为好友的ID 为好友
    if ([[WCXmppTool sharedWCXmppTool].rosterStorage userExistsWithJID:friendJid xmppStream:[WCXmppTool sharedWCXmppTool].xmppStream]) {
        [self showAlert:@"您已添加该好友"];
        return YES;
    };
    
    //添加朋友
    [[WCXmppTool sharedWCXmppTool].roster subscribePresenceToUser:friendJid];
    
    [MBProgressHUD showSuccess:@"添加好友成功"];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    return YES;
}

-(void)showAlert:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"谢谢" otherButtonTitles:nil, nil];
    [alert show];
}

@end
