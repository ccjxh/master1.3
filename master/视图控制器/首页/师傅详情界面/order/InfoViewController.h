//
//  InfoViewController.h
//  master
//
//  Created by xuting on 15/6/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic) NSInteger masterType; //判断是师傅(2)还是项目经理(1)  工人（3）
@property(nonatomic) NSInteger id; //用户id
@property(nonatomic) NSInteger cityId;  //城市id
@property (nonatomic,assign) NSInteger userPost; //判断项目经理或师傅
@property(nonatomic) AMPopTip*popTip;;
@property(nonatomic)NSMutableArray*recommends;//推荐人数组
@property(nonatomic)NSMutableArray*dataType;//根据请求到的不同数组  做出不同的请求
@end
