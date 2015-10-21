//
//  myFriendView.h
//  master
//
//  Created by jin on 15/9/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+UzysAnimatedGifPullToRefresh.h"
@interface myFriendView : RootView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView*tableview;
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,copy)void(^friendDidSelect)(NSIndexPath*indexPath);
@property(nonatomic,copy)void(^delegateFriend)(NSIndexPath*indexpath);
@end
