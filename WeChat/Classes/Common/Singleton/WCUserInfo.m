//
//  WCUserInfo.m
//  WeChat
//
//  Created by Donald on 15/6/9.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "WCUserInfo.h"

#define UserKey @"user"
#define PwdKey @"pwd"
#define RegisterUserKey @"registerUser"
#define RegisterPwdKey @"registerPwd"
#define LoginStatusKey @"LoginStatus"



@implementation WCUserInfo


singleton_implementation(WCUserInfo)



-(void)saveUserInfoToSanbox
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.user forKey:UserKey];
    [defaults setObject:self.pwd forKey:PwdKey];
    [defaults setBool:self.loginStatus forKey:LoginStatusKey];
    [defaults setObject:self.registerUser forKey:RegisterUserKey];
    [defaults setObject:self.registerPwd forKey:RegisterPwdKey];
    //同步数据
    [defaults synchronize];

}

-(void)loadUserInfoFromSanbox
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.user = [defaults objectForKey:UserKey];
    self.pwd = [defaults objectForKey:PwdKey];
    self.loginStatus = [defaults boolForKey:LoginStatusKey];
    self.registerUser = [defaults objectForKey:RegisterUserKey];
    self.registerPwd = [defaults objectForKey:RegisterPwdKey];

}

-(NSString *)jid
{
    return [NSString stringWithFormat:@"%@@%@",self.user,domain];
}

@end
