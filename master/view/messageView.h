//
//  messageView.h
//  master
//
//  Created by jin on 15/9/8.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootView.h"
#import "keyboardBar.h"
#import "keyboardMoreView.h"
//#import "GJGCChatInputPanel.h"

@protocol MessageDelegate<NSObject>;
@required
-(void)sendMessage:(NSString*)messageText;
@end
@interface messageView : RootView
@property(nonatomic)UITableView*chatListTable;
@property(nonatomic)id<MessageDelegate>delegate;
//@property(nonatomic)EMConversation*convenit;
//@property (nonatomic,strong)GJGCChatInputPanel *inputPanel;


@end
