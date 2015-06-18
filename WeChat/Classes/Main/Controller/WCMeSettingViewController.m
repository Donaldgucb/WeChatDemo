//
//  WCMeSettingViewController.m
//  WeChat
//
//  Created by Donald on 15/6/16.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "WCMeSettingViewController.h"

@interface WCMeSettingViewController ()<UIActionSheetDelegate>

@end

@implementation WCMeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"设置";
    
}

#pragma mark 用户注销登录
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [[WCXmppTool sharedWCXmppTool] xmppUserLogout];
    NSUInteger section = indexPath.section;
    if (section==3) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"是否退出登陆" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"退出登陆", nil];
//        [sheet showInView:self.view];
        
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSLog(@"退出登陆");
         [[WCXmppTool sharedWCXmppTool] xmppUserLogout];
    }
}

@end
