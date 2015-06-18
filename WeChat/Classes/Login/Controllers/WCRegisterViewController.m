//
//  WCRegisterViewController.m
//  WeChat
//
//  Created by Donald on 15/6/9.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "WCRegisterViewController.h"
#import "AppDelegate.h"

@interface WCRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;




@end

@implementation WCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //判断当设备为Iphone时，改变登陆View两边的约束条件
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftConstraint.constant =10;
        self.rightConstraint.constant = 10;
    }
    
    //设置textField背景图片
    self.userName.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdTextField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    //设置登陆按钮背景图片
    [self.registBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];

}

#pragma mark 点击注册
- (IBAction)clickRegistBtn:(id)sender {
    //隐藏键盘
    [self.view endEditing: YES];
    //判断是否为手机号码
    if (![self.userName isTelphoneNum]) {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
        return;
    }

    
    
    //保存用户注册的用户名和密码到沙盒
    [WCUserInfo sharedWCUserInfo].registerUser = self.userName.text;
    [WCUserInfo sharedWCUserInfo].registerPwd = self.pwdTextField.text;
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSanbox];
    
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [WCXmppTool sharedWCXmppTool].registerOperation=YES;
    
    
    //对self进行弱引用
    __weak typeof(self)selfVc = self;
    
    [MBProgressHUD showMessage:@"正在注册中..." toView:self.view];
    [[WCXmppTool sharedWCXmppTool] xmppUserRegister:^(XMPPResultBlockType type){
        
        [selfVc handleRegisterResult:type];
    }];
    
 
    
    
}

#pragma mark 处理block返回值
-(void)handleRegisterResult:(XMPPResultBlockType)type
{
    //刷新页面需要回到主线程来实现
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        switch (type) {
            case XMPPResultBlockTypeNetError:
                [MBProgressHUD showError:@"网络不给力" toView:self.view];
                break;
            case XMPPResultBlockTypeRegisterSuccess:
                [self bactToLoginView];//返回主页面
                break;
                
            case XMPPResultBlockTypeLoginFailure:
                [MBProgressHUD showError:@"注册失败或用户名重复" toView:self.view];
                break;
            default:
                break;
        }
    });
}

#pragma mark 注册成功后返回登陆页面
-(void)bactToLoginView
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [MBProgressHUD showSuccess:@"注册成功" toView:self.view];
    //改变登录状态
    
    //如果控制器响应了代理，则实现代理方法
    if ([self.delegate respondsToSelector:@selector(registerViewDidFinishRegister)]) {
        [self.delegate registerViewDidFinishRegister];
    }
    
}

- (IBAction)dismissToLoginView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)dealloc
{
    WCLog(@"%s",__func__);
    
}

- (IBAction)textChange {
    
    BOOL canRegist = (self.userName.text.length!=0&&self.pwdTextField.text.length!=0);
    
    if (canRegist) {
        self.registBtn.enabled=YES;
    }
    
}


@end
