//
//  orderDetailOrderViewController.h
//  master
//
//  Created by jin on 15/6/2.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface orderDetailOrderViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)NSInteger id; //订单id
@property(nonatomic)NSString*bespeak;//预约时间
@property(nonatomic)NSString*remark;//备注
@property(nonatomic)NSString*orderStatus;//订单状态
@property(nonatomic)NSInteger type;//当前订单状态
@property(nonatomic)NSDictionary*currentDict;//数据字典
@property(nonatomic)NSMutableArray*skillArray;
@property(nonatomic)UIButton*statusButton;
@property(nonatomic)NSInteger recommentStatus;//单据评价状态
@property(nonatomic)NSInteger masterID;//雇主评论记录的ID
@property(nonatomic)NSInteger billStatus;//订单状态
@property(nonatomic)NSInteger replystatus;//回复状态   1为已回复
@property(nonatomic)NSString*reasonofrefuse;//拒绝的理由
@property(nonatomic)NSString*billsNo;    //订单ID
@property(nonatomic)BOOL isShowReason;//是否显示拒绝理由
@property(nonatomic)NSMutableArray*billArray;
-(void)requestWithUrl:(NSString*)urlString;
-(void)send;
-(void)finish;
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(UITableViewCell*)getbeskeak:(UITableView*)tableview;
-(UITableViewCell*)getRemark:(UITableView*)tableview;
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(UIView*)createButton;
-(void)refuseShow:(NSString*)message;  //显示拒绝状态及理由
-(void)update;//收到通知刷新状态
@end
