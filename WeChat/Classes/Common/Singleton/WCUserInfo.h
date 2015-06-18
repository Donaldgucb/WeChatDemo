//
//  WCUserInfo.h
//  WeChat
//
//  Created by Donald on 15/6/9.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"


static NSString *domain = @"donald.local";

@interface WCUserInfo : NSObject

singleton_interface(WCUserInfo);

@property(nonatomic,copy)NSString *user;
@property(nonatomic,copy)NSString *pwd;
@property(nonatomic,copy)NSString *jid;

/**
 *  注册用户民和密码
 */
@property(nonatomic,copy)NSString *registerUser;
@property(nonatomic,copy)NSString *registerPwd;

/**
 记录用户登录状态  YES 为登录过// No 为注销
*/

@property(nonatomic,assign)BOOL loginStatus;


/**
    从沙盒读取用户登录数据
 */
-(void)loadUserInfoFromSanbox;

/**
    保存用户登录数据到沙盒
 */

-(void)saveUserInfoToSanbox;

@end
