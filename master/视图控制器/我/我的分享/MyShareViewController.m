//
//  MyShareViewController.m
//  master
//
//  Created by jin on 15/9/28.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "MyShareViewController.h"
#import "myShareView.h"

@interface MyShareViewController ()

@end

@implementation MyShareViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"我的分享";
    myShareView*view=[[myShareView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:view];
//    self.view=;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
