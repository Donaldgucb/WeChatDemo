//
//  AppDelegate.m
//  XMPP框架导入
//
//  Created by Donald on 15/6/4.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "AppDelegate.h"
#import "WCNavigationController.h"
#import "XMPPFramework.h"
#import "DDLog.h"
#import "DDTTYLogger.h"




@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 打开XMPP的日志
//    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    //打印沙盒的路径
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    WCLog(@"%@",path);
    
    
    [WCNavigationController setupNavTheme];
    
    //从沙盒获取用户登录数据
    [[WCUserInfo sharedWCUserInfo] loadUserInfoFromSanbox];
    
    //如果已经登入，直接进入主界面
    if ([WCUserInfo sharedWCUserInfo].loginStatus) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = storyboard.instantiateInitialViewController;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //自动登录服务器
            [[WCXmppTool sharedWCXmppTool] xmppUserLogin:nil];
        
        });
        
    }
    
    
    //如果是IOS8以上系统，需要注册本地通知
    if ([[UIDevice currentDevice].systemVersion doubleValue]>8.0) {
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    }

    return YES;
    
    
    
    
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




@end
