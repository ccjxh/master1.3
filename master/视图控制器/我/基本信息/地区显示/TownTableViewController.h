//
//  TownTableViewController.h
//  master
//
//  Created by xuting on 15/5/28.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BlockRegion)(NSString *region,long regionId);
@interface TownTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *townTableView;
@property (nonatomic,assign) NSInteger cityId;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) BlockRegion blockRegion;
@property (nonatomic,assign) int flag; //判断是个人信息国籍还是提交订单地区

@end
