//
//  WCNavigationController.m
//  WeChat
//
//  Created by Donald on 15/6/9.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "WCNavigationController.h"

@interface WCNavigationController ()

@end

@implementation WCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}




+(void)initialize
{

}


+(void)setupNavTheme
{
    UINavigationBar *bar = [UINavigationBar appearance];
    //设置背景图片
    [bar setBackgroundImage:[UIImage imageNamed:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];

    //设置导航栏字体
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [bar setTitleTextAttributes:attr];
    
    //设置状态栏的样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}





@end
