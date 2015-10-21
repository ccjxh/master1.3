//
//  projectCaseAddViewController.h
//  master
//
//  Created by jin on 15/6/16.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface projectCaseAddViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)NSMutableArray*picArray;
@property(nonatomic)NSMutableArray*imageArray;
@property(nonatomic)UITableView*currentTableview;
@property(nonatomic)NSInteger type;//类型   0为新增   1为名称和内容修改
@property(nonatomic)NSInteger wordId;
@property(nonatomic)NSString*name;//案例工程名字
@property(nonatomic)NSString*introlduce;//案例工程说明
@property(nonatomic)NSInteger caseType;//2为普通  1为明星工程
@property(nonatomic,copy)void(^refershBlocl)();
@property(nonatomic,copy)void(^describChangeBlock)(NSString*content);
@end
