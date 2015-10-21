//
//  checkManager.m
//  master
//
//  Created by jin on 15/9/16.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "checkManager.h"
#define updateAppkey @"1031874136"
@implementation checkManager
{

    NSString*trackViewUrl;
    NSInteger _currentType;//升级类型
}
+(checkManager*)share{
    static dispatch_once_t once;
    static checkManager*manager;
    dispatch_once(&once, ^{
       
        if (!manager) {
            manager=[[checkManager alloc]init];
        }
        
    });

    return manager;
}


-(void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (_currentType==0) {
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1031874136"];
        [[UIApplication sharedApplication]openURL:url];
        return;
    }else{
    if (buttonIndex==1) {
        NSURL *url = [NSURL URLWithString:trackViewUrl];
        [[UIApplication sharedApplication]openURL:url];
        }
    }
}


-(void)checkVersion{

    NSString*urlString=[self interfaceFromString:interface_version];
    NSDictionary*dict=@{@"appKey":@"com.baoself.master"};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            //新版本更新机制
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
            if ([version isEqualToString:[[[dict objectForKey:@"entity"] objectForKey:@"licence"] objectForKey:@"edition"]]!=YES) {
                
                if ([[[[dict objectForKey:@"entity"] objectForKey:@"licence"]
                  objectForKey:@"forceUpgrade"] integerValue]==1) {
                //强制版本更新
                _currentType=0;
//                [self foureUpdate];
                    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"发现新版本啦" icon:nil message:[[[dict objectForKey:@"entity"] objectForKey:@"licence"]objectForKey:@"intro"] delegate:self buttonTitles:@"马上更新", nil];
                [alert setButtonTitleColor:[UIColor blackColor] fontSize:14 atIndex:0];
                [alert show];

            }else{
            //不强制版本更新
                _currentType=1;
                FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"发现新版本啦" icon:nil message:[[[dict objectForKey:@"entity"] objectForKey:@"licence"]objectForKey:@"intro"] delegate:self buttonTitles:@"稍后提示我",@"马上更新", nil];
                [alert setButtonTitleColor:[UIColor blackColor] fontSize:14 atIndex:0];
                [alert show];
            
                }
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}





@end
