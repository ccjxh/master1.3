//
//  findMasterViewController.h
//  master
//
//  Created by jin on 15/8/21.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"
#import "SDCycleScrollView.h"
@interface findMasterViewController : RootViewController<CLLocationManagerDelegate,TencentSessionDelegate>
@property(nonatomic)CLLocationManager*mapManager;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *adview;
@property(nonatomic)NSString*orginCity;//定位的城市
@property(nonatomic)TencentOAuth*tencentOAuth;//QQ分享句柄
@property(nonatomic)NSArray*permissions;//QQ允许授权的列表

@end
