//
//  RefershTableview.h
//  master
//
//  Created by jin on 15/8/21.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 
 */
@interface RefershTableview : UITableView
@property(nonatomic)BOOL isSupportPulldown;//是否支持下拉刷新
@property(nonatomic)BOOL isSupportPullup;//是否支持上拉加载
@property(nonatomic)NSInteger currentPage;//当前页数

-(void)tablePullDownWithBlock:(void(^)(UITableView*self))block;
-(void)tablePullUpWithBlock:(void(^)(UITableView*self))block;
@end
