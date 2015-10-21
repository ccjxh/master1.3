//
//  messageHelp.m
//  master
//
//  Created by jin on 15/9/14.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "messageHelp.h"

@implementation messageHelp

//+(messageHelp*)share{
//
//    
//    static dispatch_once_t once;
//    static messageHelp*help;
//    dispatch_once(&once, ^{
//    
//        if(!help)
//            help=[[messageHelp alloc]init];
//    });
//    return help;
//}
//
//
//
//-(void)sendTextMessageWithMessageText:(NSString *)message Buddy:(EMBuddy *)buddy{
//
//    EMChatText*tx=[[EMChatText alloc]initWithText:message];
//    EMTextMessageBody*body=[[EMTextMessageBody alloc]initWithChatObject:tx];
//    EMMessage*sendMessage=[[EMMessage alloc]initWithReceiver:buddy.username bodies:@[body]];
//    sendMessage.messageType=eMessageTypeChat;
//    EMMessage*temp=[[EaseMob sharedInstance].chatManager asyncSendMessage:sendMessage progress:self.delegate];
//    [[EaseMob sharedInstance].chatManager insertMessageToDB:temp append2Chat:YES];
//
//}

@end
