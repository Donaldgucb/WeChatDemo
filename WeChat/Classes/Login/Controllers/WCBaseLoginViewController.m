//
//  WCBaseLoginViewController.m
//  WeChat
//
//  Created by Donald on 15/6/9.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "WCBaseLoginViewController.h"
#import "AppDelegate.h"

@interface WCBaseLoginViewController ()

@end

@implementation WCBaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)login
{
    
    //隐藏键盘
    [self.view endEditing:YES];
    
    //自己定义的block时,要对self 进行弱引用
    __weak typeof(self) selfVC = self;
    
    [MBProgressHUD showMessage:@"正在登陆中..." toView:self.view];
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [WCXmppTool sharedWCXmppTool].registerOperation=NO;
    [[WCXmppTool sharedWCXmppTool] xmppUserLogin:^(XMPPResultBlockType type){
        [selfVC handleResultType:type];
    }];
    


}


#pragma mark 处理登入信息结果
-(void)handleResultType:(XMPPResultBlockType)type{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        switch (type) {
            case XMPPResultBlockTypeLoginSuccess:
                WCLog(@"登陆成功");
                [self enterMainPage];
                break;
            case XMPPResultBlockTypeLoginFailure:
                WCLog(@"登陆失败");
                [MBProgressHUD showError:@"账户或密码不正确" toView:self.view];
                break;
            case XMPPResultBlockTypeNetError:
                [MBProgressHUD showError:@"网络不给力" toView:self.view];
                break;
            default:
                break;
        }
    });
    
    
    
}

//登陆成功进入主界面
-(void)enterMainPage
{
    //改变登录状态
    [WCUserInfo sharedWCUserInfo].loginStatus = YES;
    
    
    //保存用户数据到沙盒
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSanbox];
    
    
    //调用模态窗口的时候，它自己内部会进行一个强引用，需要先dismis该强引用
    [self dismissViewControllerAnimated:NO completion:nil];
    //登陆主界面
    //此方法是在子线程中实现，所以刷新页面需要在主线程中来完成
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    self.view.window.rootViewController = storyboard.instantiateInitialViewController;
    
    [UIStoryboard showInitialVCWithName:@"Main"];
    
}


@end
