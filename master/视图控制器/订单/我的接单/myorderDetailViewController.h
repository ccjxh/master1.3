//
//  myorderDetailViewController.h
//  master
//
//  Created by jin on 15/6/3.
//  Copyright (c) 2015年 JXH. All rights reserved.
//
/**我的接单详情*/
#import "orderDetailOrderViewController.h"
typedef void(^networkBlock)(BOOL isGhange);
@interface myorderDetailViewController : orderDetailOrderViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)UIView*messageView;
@property(nonatomic)UITextView*tv;
@property(nonatomic,copy)networkBlock block;//是否进行网络请求操作
@end
