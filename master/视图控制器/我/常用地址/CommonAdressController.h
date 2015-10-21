//
//  CommonAdressController.h
//  master
//
//  Created by xuting on 15/5/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonAdressController : RootViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *commonAdressTbView;
@property(nonatomic)NSInteger type;//0为我的服务进来  1为订单界面进入
@property(nonatomic,copy)void(^addressBlock)(normalAdress*model);
@property(nonatomic)NSInteger currentPage;
@end
