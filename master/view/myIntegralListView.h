//
//  myIntegralListView.h
//  master
//
//  Created by jin on 15/9/28.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "RootView.h"
#import "SLExpandableTableView.h"
/*我的积分列表界面**/
@interface myIntegralListView : RootView <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)NSMutableDictionary*showDict;//是否展示的字典
@property(nonatomic,strong)UITableView*tableview;
@property(nonatomic,copy)void(^changeDictValue)(NSInteger section);
-(id)init;
-(void)reloadData;
@end
