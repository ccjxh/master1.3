//
//  myCaseViewController.h
//  master
//
//  Created by jin on 15/7/1.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface myCaseViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)NSInteger currentPage;
@property(nonatomic)BOOL isshow;//显示删除按钮
@property(nonatomic)NSInteger type;//0为我的工程案例  1为指定用户工程案例
@property(nonatomic)NSInteger id;//用户id
@property(nonatomic)NSMutableArray*deleArray;//删除数组
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)NSString*rightStstus;//navagation右按钮状态
@end
