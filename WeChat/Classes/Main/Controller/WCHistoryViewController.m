//
//  WCHistoryViewController.m
//  WeChat
//
//  Created by Donald on 15/6/17.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "WCHistoryViewController.h"

@interface WCHistoryViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end

@implementation WCHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WCLoginStatusChange:) name:WCLoginStatusChangeNotification object:nil];
}



-(void)WCLoginStatusChange:(NSNotification *)noti
{
    WCLog(@"%@",noti.userInfo);
    int loginStatus = [noti.userInfo[@"loginStatus"]intValue];
    
    //主线程更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (loginStatus) {
            case XMPPResultBlockTypeConnect://正在连接中
                [self.indicatorView startAnimating];
                self.titleLable.text = @"连接中...";
                break;
            case XMPPResultBlockTypeLoginSuccess://登陆成功
                [self.indicatorView stopAnimating];
                self.titleLable.text = @"微信";
                break;
            case XMPPResultBlockTypeNetError://连接失败
                [self.indicatorView stopAnimating];
                self.titleLable.text = @"微信";
                break;
            case XMPPResultBlockTypeLoginFailure://登陆失败
                [self.indicatorView stopAnimating];
                self.titleLable.text = @"微信";
                break;
                
            default:
                break;
        }
    });
    
}

@end
