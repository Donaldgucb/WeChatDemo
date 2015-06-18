//
//  WCEditProfileViewController.h
//  WeChat
//
//  Created by Donald on 15/6/12.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCEditProfileViewControllerDelegate<NSObject>

//个人信息编辑完成
-(void)editProfileViewControllerDidSave;

@end

@interface WCEditProfileViewController : UITableViewController

@property(nonatomic,strong)UITableViewCell *cell;

@property(nonatomic,weak)id<WCEditProfileViewControllerDelegate> delegate;



@end
