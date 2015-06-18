//
//  WCLoginViewController.m
//  WeChat
//
//  Created by Donald on 15/6/8.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "WCOtherLoginViewController.h"
#import "AppDelegate.h"

@interface WCOtherLoginViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation WCOtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //判断当设备为Iphone时，改变登陆View两边的约束条件
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftConstraint.constant =10;
        self.rightConstraint.constant = 10;
    }
    
    //设置textField背景图片
    self.userTextField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdTextField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    //设置登陆按钮背景图片
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    
}


#pragma mark 返回登陆首页
- (IBAction)dismissController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark 点击登陆按钮
- (IBAction)loginBtnClick:(id)sender {
    
    //保存用户名密码到沙盒里面
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.user =self.userTextField.text;
    userInfo.pwd =self.pwdTextField.text;
    
    
    if (![self.userTextField isTelphoneNum]) {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
    }
    else
        [super login];
    
}



-(void)dealloc
{
    WCLog(@"%s",__func__);
}

@end
