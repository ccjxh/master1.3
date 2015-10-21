//
//  AppDelegate+request.h
//  master
//
//  Created by jin on 15/9/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (request)
#pragma mark-获取已开通城市的列表
-(void)getAllOpenCity;


//缓存技能
-(void)requestSkills;




//缓存个人信息
-(void)requestPersonalInformation;
@end
