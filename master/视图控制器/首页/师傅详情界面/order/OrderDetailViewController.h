//
//  OrderDetailViewController.h
//  master
//
//  Created by xuting on 15/6/3.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"
#import "MasterDetailModel.h"

@interface OrderDetailViewController : RootViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *order_region;
@property (weak, nonatomic) IBOutlet UITextField *order_textField;
@property (weak, nonatomic) IBOutlet UITableView *order_tableView;
@property (assign, nonatomic) NSInteger masterId; //用户id
@property (nonatomic,copy) NSString *name;  //用户姓名
@property (nonatomic,copy) NSString *mobile;  //用户手机号码
@property (weak, nonatomic) IBOutlet UIButton *adressButton;
@property (nonatomic,strong) MasterDetailModel *model;
@property(nonatomic)CLLocationManager*mapManager;
@property(nonatomic)CLGeocoder*geocoder;
@property(nonatomic)NSString*serviceRegion;
@property(nonatomic)NSMutableArray*allSkills;//个人拥有的技能数组
@end
