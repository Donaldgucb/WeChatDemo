//
//  WCEditProfileViewController.m
//  WeChat
//
//  Created by Donald on 15/6/12.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "WCEditProfileViewController.h"


@interface WCEditProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WCEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = self.cell.textLabel.text;
    
    self.textField.text = self.cell.detailTextLabel.text;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClickBtn)];
    
}

-(void)saveClickBtn
{
    //1、更改cell的detailtext的文本值
    self.cell.detailTextLabel.text = self.textField.text;
    
    [self.cell layoutSubviews];
    //2、当前的控制器消失
    [self.navigationController popViewControllerAnimated:YES];
    
    
    if ([self.delegate respondsToSelector:@selector(editProfileViewControllerDidSave)]) {
        [self.delegate editProfileViewControllerDidSave];
    }
    
}


@end
