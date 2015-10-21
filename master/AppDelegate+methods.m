//
//  AppDelegate+methods.m
//  master
//
//  Created by jin on 15/9/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "AppDelegate+methods.h"
#include <sys/signal.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "sys/sysctl.h"
#import <sys/utsname.h>

@implementation AppDelegate (methods)
/*评分相关设置**/
-(void)setupRecommend{
    
    //评分
    [Appirater setAppId:@"1031874136"];
    [Appirater setDaysUntilPrompt:0];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    
}



//推送
-(void)setupPushWithDictory{
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self resignNoticeation];
            }
            else{
                
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self resignNoticeation];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //清除所有通知(包含本地通知)
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}


-(void)resignNoticeation{
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
}


- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}



-(NSString*)getPhoneType{


    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    else if ([platform isEqualToString:@"iPhone1,2"]) platform= @"iPhone 3G ";
    else if ([platform isEqualToString:@"iPhone3,1"]) platform= @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,2"]) platform= @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,3"]) platform= @"iPhone 4";
    else  if ([platform isEqualToString:@"iPhone4,1"]) platform= @"iPhone 4S";
    else if ([platform isEqualToString:@"iPhone5,1"]) platform= @"iPhone 5";
    else  if ([platform isEqualToString:@"iPhone5,2"]) platform= @"iPhone 5";
    else if ([platform isEqualToString:@"iPhone5,3"]) platform= @"iPhone 5c";
    else if ([platform isEqualToString:@"iPhone5,4"]) platform= @"iPhone 5c";
    else  if ([platform isEqualToString:@"iPhone6,1"]) platform= @"iPhone 5s";
    else if ([platform isEqualToString:@"iPhone6,2"]) platform= @"iPhone 5s";
    else  if ([platform isEqualToString:@"iPhone7,1"]) platform= @"iPhone 6 Plus ";
    else  if ([platform isEqualToString:@"iPhone7,2"]) platform= @"iPhone 6";
    else if ([platform isEqualToString:@"iPad2,5"])   platform= @"iPad Mini 1G (A1432)";
    else if ([platform isEqualToString:@"iPad2,6"])   platform= @"iPad Mini 1G (A1454)";
    else if ([platform isEqualToString:@"iPad2,7"])   platform= @"iPad Mini 1G (A1455)";
    else if ([platform isEqualToString:@"iPad3,1"])   platform= @"iPad 3 (A1416)";
    else if ([platform isEqualToString:@"iPad3,2"])   platform= @"iPad 3 (A1403)";
    else  if ([platform isEqualToString:@"iPad3,3"])   platform= @"iPad 3 (A1430)";
    else  if ([platform isEqualToString:@"iPad3,4"])   platform= @"iPad 4 (A1458)";
    else  if ([platform isEqualToString:@"iPad3,5"])   platform= @"iPad 4 (A1459)";
    else   if ([platform isEqualToString:@"iPad3,6"])   platform= @"iPad 4 (A1460)";
    else  if ([platform isEqualToString:@"iPad4,1"])   platform= @"iPad Air (A1474)";
    else  if ([platform isEqualToString:@"iPad4,2"])   platform= @"iPad Air (A1475)";
    else  if ([platform isEqualToString:@"iPad4,3"])   platform= @"iPad Air (A1476)";
    else  if ([platform isEqualToString:@"iPad4,4"])   platform= @"iPad Mini 2G (A1489)";
    else if ([platform isEqualToString:@"iPad4,5"])   platform= @"iPad Mini 2G (A1490)";
    else if ([platform isEqualToString:@"iPad4,6"])   platform= @"iPad Mini 2G (A1491)";
    
    else  if ([platform isEqualToString:@"i386"])      platform= @"iPhone Simulator";
    else if ([platform isEqualToString:@"x86_64"])    platform= @"iPhone Simulator";
    
    else{
        
        return [NSString stringWithFormat:@"%@的%@",userPhoneName,@"iphone6s/iphone6s+"];
    }
    return [NSString stringWithFormat:@"%@的%@",userPhoneName,platform];

}

@end
