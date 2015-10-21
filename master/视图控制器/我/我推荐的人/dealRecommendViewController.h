//
//  dealRecommendViewController.h
//  master
//
//  Created by jin on 15/6/9.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface dealRecommendViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)NSInteger currentPage;
@property(nonatomic) NSInteger id; //用户id
@property(nonatomic) NSInteger cityId;  //城市id
@property(nonatomic) NSInteger masterType; //判断是师傅(2)还是项目经理(1)
@property(nonatomic)NSInteger orderID;//单据ID
@property(nonatomic)NSInteger recommendType;
@property(nonatomic)MasterDetailModel*model;
@property(nonatomic)UIViewController*vc;
@end
