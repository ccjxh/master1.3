//
//  AppDelegate+request.m
//  master
//
//  Created by jin on 15/9/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "AppDelegate+request.h"

@implementation AppDelegate (request)
#pragma mark-获取已开通城市的列表
-(void)getAllOpenCity{
    
    NSString*urlString=[self interfaceFromString: interface_provinceList];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [[dataBase share]deleAllCityInformation];
            NSArray*array=[dict objectForKey:@"entities"];
            [[dataBase share]addCityToDataBase:array Pid:30000];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}


//技能筛选项请求
-(void)requestSkills
{
    NSString*urlString=[self interfaceFromString:interface_skill];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSMutableArray*array =[self arrayFromJosn:responseObject Type:@"servicerSkills" Model:@"skillModel"];
        [[dataBase share]deleAllSkillInformation];
        for (NSInteger i=0; i<array.count; i++) {
            skillModel*model=array[i];
            [[dataBase share]addSkillModel:model];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}


-(void)requestPersonalInformation{

    NSString *urlString = [self interfaceFromString:interface_personalDetail];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        
        NSDictionary *dict = (NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        delegate.integrity=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] integerValue];
        [delegate.userInforDic setObject:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"age"] forKey:@"age"];
        NSDictionary *entityDic = [dict objectForKey:@"entity"];
        NSDictionary *userDic = [entityDic objectForKey:@"user"];
        PersonalDetailModel*model=[[PersonalDetailModel alloc]init];
        [model setValuesForKeysWithDictionary:userDic];
        [[dataBase share]addInformationWithModel:model];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUI" object:nil userInfo:nil];
        }
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}


@end
