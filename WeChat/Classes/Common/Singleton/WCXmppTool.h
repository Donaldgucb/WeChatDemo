//
//  WCXmppTool.h
//  WeChat
//
//  Created by Donald on 15/6/10.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPFramework.h"

@interface WCXmppTool : NSObject
extern NSString *const WCLoginStatusChangeNotification;
singleton_interface(WCXmppTool);

typedef enum {
    XMPPResultBlockTypeConnect,//正在连接中
    XMPPResultBlockTypeLoginSuccess,//登陆成功
    XMPPResultBlockTypeLoginFailure,//登陆是吧
    XMPPResultBlockTypeNetError,
    XMPPResultBlockTypeRegisterSuccess,//注册成功
    XMPPResultBlockTypeRegisterFailure//注册失败
    
}XMPPResultBlockType;

typedef void (^XMPPResultBlock)(XMPPResultBlockType type);



@property(nonatomic,strong)XMPPRosterCoreDataStorage *rosterStorage;//花名册数据存储模块
@property(nonatomic,strong)XMPPRoster *roster;//花名册模块
@property(nonatomic,strong)XMPPStream *xmppStream;
@property(nonatomic,strong)XMPPMessageArchivingCoreDataStorage *msgStorage;//保存消息数据

@property(nonatomic,strong)XMPPMessageArchiving *msgArchiving;//消息模块

/**
 *  电子名片模型
 *
 */
@property(nonatomic,strong)XMPPvCardTempModule *vCard;//电子名片

/**
 *  判断用户是否注册
 *
 */
@property(nonatomic,assign,getter=isregisterOperation)BOOL registerOperation;

/**
 *  用户注册
 *
 */
-(void)xmppUserRegister:(XMPPResultBlock)resultBlock;

/**
 *  //xmpp登陆
 *
 *
 */
-(void)xmppUserLogin:(XMPPResultBlock)resultBlock;

/**
 *  //用户注销
 *
 *
 */
-(void)xmppUserLogout;


@end
