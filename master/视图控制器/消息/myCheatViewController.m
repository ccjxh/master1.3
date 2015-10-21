//
//  myCheatViewController.m
//  master
//
//  Created by jin on 15/9/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "myCheatViewController.h"
#import "messageView.h"
//#import "XMChatBar.h"
#import "messageHelp.h"

@interface myCheatViewController ()

@end

@implementation myCheatViewController
{

    messageView*_backView;
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager]setEnable:NO];
    
}



-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager]setEnable:YES];
    
    
}
- (void)viewDidLoad {
//    [super viewDidLoad];
//    _currentPage=1;
//    [self createUI];
//    [self CreateFlow];
//    [self request];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];  
    // Do any additional setup after loading the view.
}


//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
////获取聊天记录
//-(void)request{
//
//    //获取会话
//    EMConversation *netConversations = [[EaseMob sharedInstance].chatManager conversationForChatter:self.buddy.username conversationType:eConversationTypeChat];
//    _backView.convenit=netConversations;
//    [_backView.chatListTable reloadData];
//    CGRect rect=_backView.frame;
//    if (_backView.chatListTable.contentSize.height>=rect.size.height) {
//       
//         [_backView.chatListTable setContentOffset:CGPointMake(0, _backView.chatListTable.contentSize.height-_backView.chatListTable.frame.size.height+60)];
//    }
//}
//
//
//-(void)createUI{
//
//    _backView=[[messageView alloc]init];
//    _backView.delegate=self;
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
//    //注册为SDK的ChatManager的delegate
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
//    self.view=_backView;
//   
//}
//
//
//-(void)sendMessage:(NSString *)messageText{
//
//    [messageHelp share].delegate=self;
//    [[messageHelp share]sendTextMessageWithMessageText:messageText Buddy:self.buddy];
//     EMConversation *netConversations= [[EaseMob sharedInstance].chatManager conversationForChatter:self.buddy.username conversationType:YES];
//    _backView.convenit=netConversations;
//    [_backView.chatListTable reloadData];
//    [_backView.chatListTable setContentOffset:CGPointMake(0, _backView.chatListTable.contentSize.height-_backView.chatListTable.frame.size.height)];
//    
//}
//
//
//-(void)didSendMessage:(EMMessage *)message error:(EMError *)error{
//
//    [self request];
//
//}
//
//
//-(void)didReceiveMessage:(EMMessage *)message{
//
//    [self request];
//
//}
//

@end
