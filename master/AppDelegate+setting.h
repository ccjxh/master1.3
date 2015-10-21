//
//  AppDelegate+setting.h
//  master
//
//  Created by jin on 15/9/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "orderViewController.h"
#import "selectViewController.h"
#import "MyViewController.h"
#import "XGPush.h"
#import "XGSetting.h"
#import "JKNotifier.h"
#import "MNextOrderDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "myRecommendPeopleViewController.h"
#import "OpenUDID.h"
#import <sys/utsname.h>
#import "CustomDialogView.h"
#import "sys/sysctl.h"
#import "guideViewController.h"
#include <sys/signal.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "findWorkViewController.h"
#import "findMasterViewController.h"
#import "myPublicViewController.h"
#import "myTabViewController.h"
#import "Appirater.h"
#import "friendViewController.h"
@interface AppDelegate (setting)
-(void)setHomePage;
-(void)setHomePageWithMessage:(BOOL)isHaveMessage Dict:(NSDictionary*)dict;
-(void)setReceiveUserInfor:(NSDictionary*)dict;
@end
