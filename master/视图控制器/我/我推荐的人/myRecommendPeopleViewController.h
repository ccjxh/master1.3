//
//  myRecommendPeopleViewController.h
//  master
//
//  Created by jin on 15/6/8.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface myRecommendPeopleViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)NSInteger orderID;   //单据ID
@property(nonatomic)NSInteger recommentType;//推荐结果
@property(nonatomic)peoplr*p;
@property(nonatomic)NSInteger totlaPage;
@end
