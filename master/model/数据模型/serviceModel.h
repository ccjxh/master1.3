//
//  serviceModel.h
//  master
//
//  Created by jin on 15/5/21.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"
/**我的服务数据模型*/
@interface serviceModel : model
@property(nonatomic)NSInteger id;
@property(nonatomic)NSInteger workExperience;//工作经验
@property(nonatomic)NSString* serviceDescribe;//服务介绍
@property(nonatomic)NSString*workStatus;//状态
@property(nonatomic)NSArray*servicerSkills;//技能
@property(nonatomic)NSArray*allServiceRegions;//服务区域
@property(nonatomic)NSString*startWork;//开始工作时间
@property(nonatomic)NSArray* certificate;//证件
@property(nonatomic)NSArray*recommendInfo;//推荐人
@property(nonatomic)NSArray*starProjectCase;//明星工程
@end
