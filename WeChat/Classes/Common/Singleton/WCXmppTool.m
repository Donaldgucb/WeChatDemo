//
//  WCXmppTool.m
//  WeChat
//
//  Created by Donald on 15/6/10.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "WCXmppTool.h"


NSString *const WCLoginStatusChangeNotification = @"WCLoginStatusChangeNotification";

@interface WCXmppTool ()<XMPPStreamDelegate>
{
   
    XMPPResultBlock _reulstBlock;
    
    XMPPReconnect *_xmppReconnect;//自动重连
    
    XMPPvCardCoreDataStorage *_vCardStorage;//电子名片数据
    XMPPvCardAvatarModule *_avatar;//电子名片头像
    
    
    
    


}

//1、初始化XmppStream
-(void)setXmppStream;


//2、连接服务器
-(void)connectToHost;

//3、发送密码，进行授权
-(void)sendPwdToHost;


//4、发送在线消息
-(void)sendOnLineMessage;

//手动清空内存
-(void)teardownXmpp;

@end



@implementation WCXmppTool

singleton_implementation(WCXmppTool)


#pragma mark 私有方法
#pragma mark 初始化xmppStream
-(void)setXmppStream
{
    _xmppStream = [[XMPPStream alloc] init];
    
//#warning 每一个模块添加后都要激活
    
    
    //花名册
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    
    //自动重连
    
    _xmppReconnect = [[XMPPReconnect alloc] init];
    [_xmppReconnect activate:_xmppStream];
    
    //添加电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    
    
    
    
    //激活vCard
    [_vCard activate:_xmppStream];
    
    //添加电子头像模块
    _avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
    
    
    //消息模块
    
    _msgStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    
    _msgArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_msgStorage];
    
    //激活消息模块
    [_msgArchiving activate:_xmppStream];
    
    
    _xmppStream.enableBackgroundingOnSocket = YES;
    
    //xmppStream代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}



#pragma mark 清空内存
-(void)teardownXmpp
{
    //移除代理
    [_xmppStream removeDelegate:self];
    
    
    //停止模块
    [_xmppReconnect deactivate];
    [_roster deactivate];
    [_vCard deactivate];
    [_avatar deactivate];
    [_msgArchiving deactivate];

    
    //断开连接
    [_xmppStream disconnect];
    
    //清空资源
    _roster=nil;
    _rosterStorage = nil;
    _xmppReconnect =nil;
    _vCard = nil;
    _vCardStorage=nil;
    _avatar = nil;
    _xmppStream = nil;
    _msgArchiving = nil;
    _msgStorage = nil;
}


#pragma mark 连接服务器
-(void)connectToHost
{
    WCLog(@"开始连接服务器");
    if (!_xmppStream) {
        [self setXmppStream];
    }
    
    //发送连接状态通知给History控制器
    [self postNotifacationChange:XMPPResultBlockTypeConnect];
    
    //从沙盒中取出用户名
    NSString *user = nil;
    
    if ([self isregisterOperation]) {
        user = [WCUserInfo sharedWCUserInfo].registerUser;
    }
    else
    {
        user = [WCUserInfo sharedWCUserInfo].user;
    }
    
    XMPPJID *myJid = [XMPPJID jidWithUser:user domain:@"donald.local" resource:@"iphone"];
    
    _xmppStream.myJID =myJid;
    _xmppStream.hostName = @"donald.local";
    _xmppStream.hostPort = 5222;
    
    
    NSError *error = nil;
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    
    
    
}

#pragma mark 发送密码进行授权
-(void)sendPwdToHost
{
    NSError *error = nil;
    
    //从沙盒中取出密码
    NSString *pwd =[WCUserInfo sharedWCUserInfo].pwd;
    [_xmppStream authenticateWithPassword:pwd error:&error];
}

#pragma mark 发送在线信息
-(void)sendOnLineMessage
{
    XMPPPresence *presence = [XMPPPresence presence];
    [_xmppStream sendElement:presence];
    WCLog(@"发送在线消息");
}


#pragma mark XMPP代理方法

#pragma mark 与主机连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    WCLog(@"连接服务器成功!");
    
    if ([self isregisterOperation]) {//注册，发送密码进行注册
        NSString *pwd = [WCUserInfo sharedWCUserInfo].registerPwd;
        [_xmppStream registerWithPassword:pwd error:nil];
    }
    else//登陆，发送密码进行授权
    {
        [self sendPwdToHost];
        
    }
}


#pragma mark 与主机连接失败
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    WCLog(@"连接服务器失败%@",error);
    if (error && _reulstBlock) {
        _reulstBlock(XMPPResultBlockTypeNetError);
    }
    
    if (error) {
        [self postNotifacationChange:XMPPResultBlockTypeNetError];
    }
    
    
}

#pragma mark 授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    WCLog(@"授权成功");
    [self sendOnLineMessage];
    
    [self postNotifacationChange:XMPPResultBlockTypeLoginSuccess];
    
    //回调方法到WCOtherLoginControoler中处理登陆到主界面
    if (_reulstBlock) {
        _reulstBlock(XMPPResultBlockTypeLoginSuccess);
    }
    
}



#pragma mark 授权失败，登录服务器失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    WCLog(@"登录失败");
    
    [self postNotifacationChange:XMPPResultBlockTypeLoginFailure];
    
    //回调方法到WCOtherLoginControoler中处理登陆失败
    if (_reulstBlock) {
        _reulstBlock(XMPPResultBlockTypeLoginFailure);
    }
}

#pragma mark 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
    WCLog(@"注册成功");
    if (_reulstBlock) {
        _reulstBlock(XMPPResultBlockTypeRegisterSuccess);
    }
    
}

#pragma mark 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    
    WCLog(@"注册失败 %@",error);
    if (_reulstBlock) {
        _reulstBlock(XMPPResultBlockTypeRegisterFailure);
    }
}


#pragma mark 接收服务器发送的消息
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    WCLog(@"接收消息");
    if ([UIApplication sharedApplication].applicationState !=UIApplicationStateActive) {
        WCLog(@"后台接收消息");
        
        //创建本地通知
        UILocalNotification *localNoti = [[UILocalNotification alloc]init];
        
        //设置本地通知的内容
        localNoti.alertBody = [NSString stringWithFormat:@"%@\n%@",message.fromStr,message.body];
        
        //设置本地通知的声音
        localNoti.soundName = @"default";
        
        //设置本地通知的执行时间
        localNoti.fireDate = [NSDate date];
        
        //执行本地通知
        [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
        
        
    }
    
}

//
-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    //XMPPPresence 在线 离线
    
    //presence.from 消息是谁发送过来
}


#pragma mark 发送登陆状态改变通知
-(void)postNotifacationChange:(XMPPResultBlockType)resultType
{
    NSDictionary *userInfo = @{@"loginStatus":@(resultType)};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WCLoginStatusChangeNotification object:nil userInfo:userInfo];
}


#pragma mark 公用方法
#pragma mark 注销用户
-(void)xmppUserLogout
{
    //发送不在线信息
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    [_xmppStream disconnect];
    WCLog(@"用户注销退出登录");
    
    //回到登录界面
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    self.window.rootViewController =storyboard.instantiateInitialViewController;
    
    [UIStoryboard showInitialVCWithName:@"Login"];
    
    [WCUserInfo sharedWCUserInfo].loginStatus = NO;
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSanbox];
}

#pragma mark 用户登录
-(void)xmppUserLogin:(XMPPResultBlock)resultBlock
{
    _reulstBlock = resultBlock;
    //开始连接服务器
    
    //连接之前先断开连接
    [_xmppStream disconnect];
    
    [self connectToHost];
    
}

#pragma mark 用户注册
-(void)xmppUserRegister:(XMPPResultBlock)resultBlock
{
    _reulstBlock = resultBlock;
    //开始连接服务器
    
    //连接之前先断开连接
    [_xmppStream disconnect];
    
    [self connectToHost];
}


-(void)dealloc
{
    [self teardownXmpp];
}

@end
