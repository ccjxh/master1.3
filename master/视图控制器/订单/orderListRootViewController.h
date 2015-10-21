//
//  orderListRootViewController.h
//  master
//
//  Created by jin on 15/6/2.
//  Copyright (c) 2015年 JXH. All rights reserved.
//
#import "RootViewController.h"

@interface orderListRootViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)NSInteger currentPage;
@property(nonatomic)NSMutableArray*pageArray;//当前页数数组
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)NSInteger totalCount;//共多少条数据
@property(nonatomic)NSInteger totlaPage;//总共多少页
@property(nonatomic)NSInteger type;//0为我的下单   1为我的接单
@property(nonatomic)DAPagesContainer*pagesContainer;
-(void)sendRequesr;
-(void)requestWithURL:(NSString*)url;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
