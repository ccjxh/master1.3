//
//  billListModel.h
//  master
//
//  Created by jin on 15/6/2.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"
/**订单列表详情*/
@interface billListModel : model
@property(nonatomic)NSInteger id;
@property(nonatomic)NSString*billsNo;//遍号
@property(nonatomic)NSString*region;//地区
@property(nonatomic)NSString*address;//地址
@property(nonatomic)NSString*startTime;//开始时间
@property(nonatomic)NSString*finishTime;//完成时间
@property(nonatomic)NSString*contract;//缔结
@property(nonatomic)NSString*phone;//电话
@property(nonatomic)NSArray*skills;//技能数组
@property(nonatomic)NSDictionary*master;
@property(nonatomic)NSDictionary*buyer;
@property(nonatomic)BOOL isDelegate;//是否可以删除
@property(nonatomic)NSInteger orderStatus;//单据状态
@end
