//
//  dataBase+interface.h
//  master
//
//  Created by jin on 15/6/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "dataBase.h"
#import "datBase+normal.h"
#import "payModel.h"
@interface dataBase (interface)

//创建表单
-(void)CreateAllTables;

//添加以及跟新城市信息
-(void)addCityToDataBase:(NSArray*)array Pid:(NSInteger)pid;


//添加以及更新个人信息
-(void)addInformationWithModel:(PersonalDetailModel*)model;


//添加以及更新技能信息
-(BOOL)addSkillModel:(skillModel*)model;


//清楚所有缓存
-(BOOL)deleAllSave;

//添加以及更新支付
-(BOOL)addPay:(payModel*)model;

@end
