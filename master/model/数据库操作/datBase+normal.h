//
//  datBase+normal.h
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "payModel.h"


@interface dataBase (normal)

-(void)createTable;

//插入城市信息
-(void)inserCity:(NSArray*)array Pid:(NSInteger)pid;

//跟新城市信息
-(BOOL)updateWintCity:(AreaModel*)model;

//根据城市名字查找城市信息
-(AreaModel*)findWithCity:(NSString*)cityName;

//根据城市id查找城市下的地区信息
-(NSMutableArray*)findWithPid:(NSInteger)pid;

//根据首字母查找城市信息
-(NSMutableArray*)findWithFlag:(NSString*)flag;


//删除所有城市信息
-(BOOL)deleAllCityInformation;



//插入技能信息
-(BOOL)inserSkillModel:(skillModel*)model;


//跟新技能信息
-(BOOL)updateWintSkillModel:(skillModel*)model;


//查找全部技能
-(NSMutableArray*)findAllSkill;


//删除所有技能信息
-(BOOL)deleAllSkillInformation;


//插入技能信息
-(BOOL)inserSkillModel:(skillModel*)model;


//插入个人信息
-(BOOL)inserInformationWithPeopleInfoematin:(PersonalDetailModel*)model;


//跟新个人信息
-(BOOL)updateInformationWithWithPeopleInfoematin:(PersonalDetailModel*)model;


//查找个人信息
-(PersonalDetailModel*)findPersonInformation:(NSInteger)ID;

//删除个人信息
-(BOOL)deleInformationWithID:(NSInteger)ID;


//缓存支付
-(BOOL)insertPayFromTable:(payModel*)model;

//跟新支付
-(BOOL)updatePayFromTable:(payModel*)model;

-(NSMutableArray*)findAllPay;


//删除支付
-(BOOL)deleAllPay;


-(void)updateInformationWithId:(NSInteger)ID Attribute:(NSString*)attribute Content:(NSString*)content;



@end
