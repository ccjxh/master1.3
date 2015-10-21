//
//  skillSelectViewController.h
//  master
//
//  Created by jin on 15/5/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface skillSelectViewController : RootViewController
@property(nonatomic,copy)void(^skillArray)(NSMutableArray*ValueArray);
@property(nonatomic)NSMutableArray*Array;//已经选择的数组
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)NSMutableArray*tempArray;
@property(nonatomic)NSMutableArray*allSkills;
@property(nonatomic)NSInteger type;//1为指定技能数组
-(void)initData;
@end
