//
//  dataBase+interface.m
//  master
//
//  Created by jin on 15/6/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "dataBase+interface.h"
@implementation dataBase (interface)



//创建表单
-(void)CreateAllTables{

    [self createTable];

}


//添加以及跟新城市信息
-(void)addCityToDataBase:(NSArray*)array Pid:(NSInteger)pid{
    
    [self inserCity:array Pid:pid];
    
}


//添加以及跟新个人信息
-(void)addInformationWithModel:(PersonalDetailModel *)model{
    BOOL isResult;
    isResult=[self inserInformationWithPeopleInfoematin:model];
    if (!isResult) {
       isResult= [self updateInformationWithWithPeopleInfoematin:model];
        if (isResult) {
            NSLog(@"个人信息更新%@",isResult?@"成功":@"失败");
        }
    }
}


//添加以及跟新技能信息
-(BOOL)addSkillModel:(skillModel *)model{
    
    BOOL isResult;
    isResult=[self inserSkillModel:model];
    if (!isResult) {
        isResult=[self updateWintSkillModel:model];
    }
    return isResult;
}


//删除所有缓存
-(BOOL)deleAllSave{
    BOOL cityStatus= [self deleAllCityInformation];
    BOOL skillStatus=[self deleAllSkillInformation];
    BOOL payStatus=[self delePay];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    BOOL peopleStatus=  [self deleInformationWithID:delegate.id];
    if (peopleStatus&&skillStatus&&cityStatus&&payStatus) {
        return YES;
    }
    return NO;
}


-(BOOL)addPay:(payModel*)model{
    BOOL isResult;
    isResult=[self insertPayFromTable:model];
    if (!isResult) {
        isResult=[self updatePayFromTable:model];
    }
    return isResult;
}


-(BOOL)delePay{
    BOOL isResult;
    isResult= [self deleAllPay];
    return isResult;
}
@end
