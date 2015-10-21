//
//  findWorkDetail.h
//  master
//
//  Created by jin on 15/8/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
/*找工作详情**/
@interface findWorkDetail : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)UITableView*tableview;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)findWorkDetailModel*model;
@property(nonatomic)NSInteger type;//0为找工作push   1为我的发布push
@property(nonatomic,copy)void(^deleBlock)(NSInteger ID);//删除单据
@property(nonatomic,copy)void(^reportBlock)();
@end
