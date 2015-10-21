//
//  cityViewController.h
//  master
//
//  Created by jin on 15/5/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//
typedef void (^area)(AreaModel*model);
#import "selectedCityinforView.h"
#import "ListRootViewController.h"
@interface cityViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)area TBlock;
@property(nonatomic)NSInteger type;//哪个视图控制push进来的   0是首页  
@property(nonatomic)NSString*city;//定位的城市;
@property(nonatomic) selectedCityinforView*backView;
@property(nonatomic)NSMutableArray*selectedArray;//已选中数组
@property (weak, nonatomic) IBOutlet UITableView *tableview;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@property(nonatomic)NSInteger count;//一共可以推几层
@end
