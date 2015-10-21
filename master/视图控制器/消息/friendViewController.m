//
//  friendViewController.m
//  master
//
//  Created by jin on 15/9/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "friendViewController.h"
#import "myFriendView.h"
#import "myCheatViewController.h"
//#import "GJGCChatFriendViewController.h"
#import "searchFriendViewController.h"
@interface friendViewController ()

@end

@implementation friendViewController
//{
//   
//    __block  myFriendView*backView;
//    
//}
//
//-(void)dealloc{
//
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"huanxinLogin" object:nil];
//}
//
//-(void)viewDidAppear:(BOOL)animated{
//
//    [super viewDidAppear:animated];
//    [[IQKeyboardManager sharedManager]setEnable:NO];
//
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    
//    [super viewWillDisappear:animated];
//    [[IQKeyboardManager sharedManager]setEnable:YES];
//    
//
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self createUI];
//    [self customNavigation];
//    [self CreateFlow];
//    [self noData];
//    [self netIll];
//    [self request];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];  
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUI) name:@"huanxinLogin" object:nil];
//    
//}
//
//-(void)updateUI{
//
//    [self request];
//}
//
//- (void)didReceiveMemoryWarning {
//    
//    [super didReceiveMemoryWarning];
//    
//    // Dispose of any resources that can be recreated.
//}
//
//-(void)request{
//
///
//}
//
//-(void)createUI{
//
//    self.automaticallyAdjustsScrollViewInsets=NO;
//    backView=[[myFriendView alloc]init];
//    backView.tableview.bounces=YES;
//    __weak typeof(self)WeSelf=self;
//    __weak typeof(myFriendView*)WeView=backView;
//    backView.friendDidSelect=^(NSIndexPath*indexPath){
//        if (indexPath.section==0) {
//        //系统助手处理
//            return ;
//        }
//        myCheatViewController*cvc=[[myCheatViewController alloc]init];
//        EMBuddy*buddy=WeView.dataArray[indexPath.section-1];
//        cvc.buddy=buddy;
//        cvc.hidesBottomBarWhenPushed=YES;
//        [WeSelf pushWinthAnimation:WeSelf.navigationController Viewcontroller:cvc];
//    };
//    __weak typeof(self)weakSelf=self;
//    backView.tableviewPullDown=^(){
//        
//        [weakSelf pullDown];
//        
//    };
//    backView.tableviewPullUp=^(){
//        
//        [weakSelf pullUp];
//        
//    };
//    
//    self.view=backView;
//    backView.delegateFriend=^(NSIndexPath*indexPath){
//        EMBuddy*buddy=WeView.dataArray[indexPath.section-1];
//        // 删除好友
//        BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeBuddy:buddy.username removeFromRemote:YES error:nil];
//        if (isSuccess ) {
//            [WeView makeToast:@"删除成功" duration:1 position:@"center" Finish:^{
//                [WeView.dataArray removeObjectAtIndex:indexPath.section-1];
//                [WeView.tableview reloadData];
//                
//            }];
//        }
//    };
//}
//
//
////下拉刷新
//-(void)pullDown{
//
//    self.isRefersh=YES;
//    [self request];
//
//}
//
//
////上拉加载
//-(void)pullUp{
//
//    
//
//}
//
//-(void)customNavigation{
//    
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
//    
//}
//
//
////添加好友
//-(void)addFriend{
//
//    searchFriendViewController*svc=[[searchFriendViewController alloc]initWithNibName:@"searchFriendViewController" bundle:nil];
//    [self pushWinthAnimation:self.navigationController Viewcontroller:svc];
//
//}
//
@end
