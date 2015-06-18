//
//  WCProfileViewController.m
//  WeChat
//
//  Created by Donald on 15/6/12.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "WCProfileViewController.h"
#import "WCXmppTool.h"
#import "XMPPvCardTemp.h"
#import "WCEditProfileViewController.h"



@interface WCProfileViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,WCEditProfileViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nickName;//昵称
@property (weak, nonatomic) IBOutlet UILabel *WeiXinNoLabel;//微信号
@property (weak, nonatomic) IBOutlet UILabel *OrgNameLabel;//公司
@property (weak, nonatomic) IBOutlet UILabel *OrgUnitLabel;//部门
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;//职位
@property (weak, nonatomic) IBOutlet UILabel *telLabel;//电话
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;//邮件

@end

@implementation WCProfileViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"个人信息";
    
    //显示个人信息
    //xmpp提供了一个方法，直接获取个人信息
    XMPPvCardTemp *myVCard =[WCXmppTool sharedWCXmppTool].vCard.myvCardTemp;
    
    // 设置头像
    if(myVCard.photo){
        self.headView.image = [UIImage imageWithData:myVCard.photo];
    }
    
    
    //设置用户昵称
    self.nickName.text =myVCard.nickname;
    
    //设置用户名
    NSString *user = [WCUserInfo sharedWCUserInfo].user;
    self.WeiXinNoLabel.text =user;
    
    //设置公司
    self.OrgNameLabel.text = myVCard.orgName;
    
    //设置部门
    if (myVCard.orgUnits.count>0) {
        
        self.OrgUnitLabel.text = [myVCard.orgUnits firstObject];
    }

    //设置职位
    self.TitleLabel.text = myVCard.title;
    
    //设置电话
#warning 这个电话的数据没有进行解析
    //使用note字段进行替代
    self.telLabel.text = myVCard.note;
    
    //设置邮件  使用mailer充当
    self.emailLabel.text = myVCard.mailer;
}





#pragma mark - Table view data source


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

     UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
    
    NSInteger tag = cell.tag;
    
    if (tag==2) {//不进行操作
        return;
    }
    
    if (tag==0) {//设置头像
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        [sheet showInView:self.view];
    }
    else//进入下一个页面进行修改
    {
        [self performSegueWithIdentifier:@"EditvCardSegue" sender:cell];
    }
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //获取目标控制器
    id destVc = segue.destinationViewController;
    if ([destVc isKindOfClass:[WCEditProfileViewController class]]) {
        WCEditProfileViewController *editProfile = (WCEditProfileViewController *)destVc;
        editProfile.cell =sender;
        editProfile.delegate=self;
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==2) {//取消
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate =self;
    imagePicker.allowsEditing = YES;
    
    
    if (buttonIndex==0) {//拍照
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    else//从相册选择
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    
    //显示图片选择器
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    
    
}



#pragma mark ImagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    WCLog(@"%@",info);
    
    //设置编辑后的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    self.headView.image = image;
    
    //隐藏当前的模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    //保存到服务器
    
    [self editProfileViewControllerDidSave];
    
}

#pragma mark 编辑信息代理方法
-(void)editProfileViewControllerDidSave
{
    XMPPvCardTemp *myVCard = [WCXmppTool sharedWCXmppTool].vCard.myvCardTemp;
    
    //头像
     myVCard.photo = UIImagePNGRepresentation(self.headView.image);
    
    //昵称
    myVCard.nickname = self.nickName.text;
    
    //公司
    myVCard.orgName = self.OrgNameLabel.text;
    //部门
    if (self.OrgUnitLabel.text.length>0) {
        myVCard.orgUnits = @[self.OrgUnitLabel.text];
        
    }

    //职位
    myVCard.title = self.TitleLabel.text;
    
    //手机
    myVCard.note = self.telLabel.text;
    //邮箱
    myVCard.mailer = self.emailLabel.text;
    
    
    [[WCXmppTool sharedWCXmppTool].vCard updateMyvCardTemp:myVCard];
}

@end
