//
//  AppDelegate+methods.h
//  master
//
//  Created by jin on 15/9/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "AppDelegate.h"
#import "Appirater.h"
#import "XGPush.h"

@interface AppDelegate (methods)
/*评分相关设置**/
-(void)setupRecommend;

//云测相关设置
-(void)setupTestLin;

//推送
-(void)setupPushWithDictory;

-(NSString*)getPhoneType;
@end
