//
//  WechatPayViewController.m
//  master
//
//  Created by xuting on 15/6/5.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "WechatPayViewController.h"

@interface WechatPayViewController ()

@end

@implementation WechatPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self CreateFlow ];
}
- (IBAction)wechatPay:(id)sender
{
    [self requestWechatPay];
}

-(void) requestWechatPay
{
    [self flowShow];
    NSString *urlString = [self interfaceFromString:interface_updateWechatPay];
    NSDictionary *dict = @{@"orderId" : [NSNumber numberWithInteger:self.orderId] , @"deposit" : [NSNumber numberWithInt:1]};
    [[httpManager share] POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        
        [self flowHide];
//        NSLog(@"%lu",self.orderId);
        
        
        NSDictionary *objDic = (NSDictionary *)responseObject;
        if ([[objDic objectForKey:@"rspCode"] integerValue] == 200)
        {
//            NSLog(@"支付完成!");
            
            
            [self.view makeToast:@"支付完成!" duration:2.0f position:@"center"];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
        NSLog(@"error = %@",error);
    }];
    
}

@end
