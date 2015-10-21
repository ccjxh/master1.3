//
//  findWorkListModel.h
//  master
//
//  Created by jin on 15/8/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"
/*
 
找工作列表数据模型
 **/
@interface findWorkListModel : model
@property(nonatomic)NSString*title;//标题
@property(nonatomic)NSString*address;//地址
@property(nonatomic)NSString*phone;
@property(nonatomic)NSString*publishTime;//发布时间
@property(nonatomic)NSInteger id;
@property(nonatomic)NSString*publishState;//发布状态
@property(nonatomic)NSString*contacts;//联系人
@property(nonatomic)NSInteger auditState;//审核状态
@property(nonatomic)NSDictionary*publisher;//发布人
@property(nonatomic)NSInteger peopleNumber;//需要人数
@property(nonatomic)NSString*workRequire;//职位要求
@property(nonatomic)NSDictionary*pay;//薪资
@property(nonatomic)NSDictionary*workSite;//工作地点
@property(nonatomic)NSDictionary*payType;//支付单位
@property(nonatomic)NSString*billsNo;//单据编号
@property(nonatomic)NSString*fullAddress;//完整地址
@property(nonatomic)NSString*auditOpinion;//审核意见
@end
