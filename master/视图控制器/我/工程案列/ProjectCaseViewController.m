//
//  ProjectCaseViewController.m
//  master
//
//  Created by xuting on 15/6/1.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "ProjectCaseViewController.h"

@interface ProjectCaseViewController ()

@end

@implementation ProjectCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 200, 100)];
    [self requestProjectCase];
    
    
    
}
#pragma mark - 请求工程案例
-(void) requestProjectCase
{
    NSString *urlString = [self interfaceFromString:interface_projectCase];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary *objDic = (NSDictionary *)responseObject;
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}

@end
