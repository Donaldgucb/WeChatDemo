//
//  WCContactsViewController.m
//  WeChat
//
//  Created by Donald on 15/6/15.
//  Copyright (c) 2015年 www.Funboo.com.cn. All rights reserved.
//

#import "WCContactsViewController.h"
#import "WCChatViewController.h"

@interface WCContactsViewController ()<NSFetchedResultsControllerDelegate>
{

    NSFetchedResultsController *_resultContorl;
}

@property (nonatomic,strong)NSArray *friends;


@end

@implementation WCContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self loadFriends2];
    
    
}


-(void)loadFriends{
    //使用CoreData获取数据
    // 1.上下文【关联到数据库XMPPRoster.sqlite】
    NSManagedObjectContext *context = [WCXmppTool sharedWCXmppTool].rosterStorage.mainThreadManagedObjectContext;
    
    
    // 2.FetchRequest【查哪张表】
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 3.设置过滤和排序
//     过滤当前登录用户的好友
    NSString *jid = [WCUserInfo sharedWCUserInfo].jid;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr=%@",jid];
    request.predicate = pre;

    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    // 4.执行请求获取数据
    self.friends = [context executeFetchRequest:request error:nil];
    NSLog(@"%@",self.friends);
    
    
}


-(void)loadFriends2{
    //使用CoreData获取数据
    // 1.上下文【关联到数据库XMPPRoster.sqlite】
    NSManagedObjectContext *context = [WCXmppTool sharedWCXmppTool].rosterStorage.mainThreadManagedObjectContext;
    
    
    // 2.FetchRequest【查哪张表】
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 3.设置过滤和排序
    // 过滤当前登录用户的好友
    //    NSString *jid = [WCUserInfo sharedWCUserInfo].jid;
    //    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr=%@",jid];
    //    request.predicate = pre;
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    // 4.执行请求获取数据
    
    _resultContorl = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultContorl.delegate =self;
    
    NSError *err = nil;
    [_resultContorl performFetch:&err];
    
    if(err)
    {
        WCLog(@"%@",err);
    }
    
}


#pragma mark 当通讯录的朋友列表数据改变时，调用该方法
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    WCLog(@"数据发生改变");
    
    //刷新表格
    [self.tableView reloadData];
}




-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultContorl.fetchedObjects.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    // 获取对应好友
    XMPPUserCoreDataStorageObject *friend =_resultContorl.fetchedObjects[indexPath.row];
    
    switch ([friend.sectionNum intValue]) {
        case 0:
            cell.detailTextLabel.text = @"在线";
            break;
        case 1:
            cell.detailTextLabel.text = @"离开";
            break;
        case 2:
            cell.detailTextLabel.text = @"离线";
            break;
        default:
            break;
    }
    
  
    
    
    cell.textLabel.text = friend.jidStr;
    
    return cell;

    
}



#pragma mark 左滑删除好友
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        // 获取对应好友
        XMPPUserCoreDataStorageObject *friend =_resultContorl.fetchedObjects[indexPath.row];
        XMPPJID *friendJid = friend.jid;
        
        //删除好友
        [[WCXmppTool sharedWCXmppTool].roster removeUser:friendJid];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPUserCoreDataStorageObject *friend =_resultContorl.fetchedObjects[indexPath.row];
    [self performSegueWithIdentifier:@"chatSegue" sender:friend.jid];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id destVc = segue.destinationViewController;
    if([destVc isKindOfClass:[WCChatViewController class]]){
        WCChatViewController *chatControl = (WCChatViewController*)destVc;
        chatControl.friendJid =sender;
    }
}

@end
