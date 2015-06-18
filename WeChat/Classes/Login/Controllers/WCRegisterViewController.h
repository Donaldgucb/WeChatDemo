//
//  WCRegisterViewController.h
//  WeChat
//
//  Created by Donald on 15/6/9.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCRegisterViewControllerDelegate <NSObject>

/**
 *  注册的控制器完成注册
 */
-(void)registerViewDidFinishRegister;

@end


@interface WCRegisterViewController : UIViewController

@property(nonatomic,weak)id<WCRegisterViewControllerDelegate> delegate;

@end
