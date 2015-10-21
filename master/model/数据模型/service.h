//
//  service.h
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"

@interface service : model
@property(nonatomic)NSInteger workExperience;
@property(nonatomic)NSArray*serviceRegions;//服务地区
@property(nonatomic)NSString*serviceDescribe;//服务描述
@property(nonatomic)NSString*workStatus;//目前状态
@property(nonatomic)NSArray*servicerSkills;//技能
@property(nonatomic)NSInteger star;//星数
@property(nonatomic)NSInteger phoneCount;//电话次数
@property(nonatomic)NSInteger orderCount;//收藏次数
@end
