//
//  WCLoginViewController.m
//  WeChat
//
//  Created by Donald on 15/6/9.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "WCLoginViewController.h"
#import "WCRegisterViewController.h"
#import "WCNavigationController.h"
#import "WCOtherLoginViewController.h"

@interface WCLoginViewController ()<WCRegisterViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@end

@implementation WCLoginViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置密码框背景图片
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    //设置密码框左边icon图片
    [self.pwdField addLeftViewWithImage:@"Card_Lock"];
    
    //设置登陆按钮背景图片
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    self.userLabel.text = [WCUserInfo sharedWCUserInfo].user;
    
}


- (IBAction)clickLoginBTN:(id)sender {
    
    //保存用户名密码到沙盒里面
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.user =self.userLabel.text;
    userInfo.pwd =self.pwdField.text;
    
    if (self.userLabel.text) {
        [super login];
    }
    else
        [MBProgressHUD showError:@"您没有输入用户名" toView:self.view];

    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //获取注册控制器
    id segueVc = segue.destinationViewController;
    
    //判断是否为注册控制器
    if ([segueVc isKindOfClass:[WCNavigationController class]]) {
        WCNavigationController *nav = segueVc;
        if ([nav.topViewController isKindOfClass:[WCRegisterViewController class]]) {
            WCRegisterViewController *registerVc = (WCRegisterViewController *)nav.topViewController;
            //设置代理
            registerVc.delegate =self;
            
        }
    }
}

#pragma mark WCRegisterViewController的代理方法
-(void)registerViewDidFinishRegister
{
    WCLog(@"注册完成");
    //注册完成
    self.userLabel.text = [WCUserInfo sharedWCUserInfo].registerUser;

    [MBProgressHUD showSuccess:@"请重新输入登陆密码" toView:self.view];
}

#pragma mark 点击背景View隐藏键盘
- (IBAction)view_TouchDown:(id)sender {
    
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}



@end
