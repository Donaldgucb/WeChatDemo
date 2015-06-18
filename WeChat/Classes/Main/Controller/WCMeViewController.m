//
//  WCMeViewController.m
//  WeChat
//
//  Created by Donald on 15/6/9.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "WCMeViewController.h"
#import "AppDelegate.h"
#import "WCXmppTool.h"
#import "XMPPvCardTemp.h"

@interface WCMeViewController ()
- (IBAction)logoutBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *portraitView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *userName;



@end

@implementation WCMeViewController





-(void)viewWillAppear:(BOOL)animated
{
      //xmpp提供了一个方法，直接获取个人信息
    //xmpp提供了一个方法，直接获取个人信息
    XMPPvCardTemp *myVCard =[WCXmppTool sharedWCXmppTool].vCard.myvCardTemp;
    
    // 设置头像
    if(myVCard.photo){
        self.portraitView.image = [UIImage imageWithData:myVCard.photo];
    }
    
    
    //设置用户昵称
    self.nickName.text =myVCard.nickname;
    
    //设置用户名
    NSString *user = [WCUserInfo sharedWCUserInfo].user;
    self.userName.text = [NSString stringWithFormat:@"微信号:%@",user];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 显示当前用户个人信息
    
    // 如何使用CoreData获取数据
    // 1.上下文【关联到数据】
    
    // 2.FetchRequest
    
    // 3.设置过滤和排序
    
    // 4.执行请求获取数据
    
  
    
    
 
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger section = indexPath.section;
    if (section==0) {
        [self performSegueWithIdentifier:@"MeInfo" sender:nil];
    }
    else if(section ==3)
        [self performSegueWithIdentifier:@"MeSetting" sender:nil];

    
}





#pragma mark 用户注销登录

@end
