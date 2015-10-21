//
//  mynextBillViewController.m
//  master
//
//  Created by jin on 15/6/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "mynextBillViewController.h"
#import "myorderDetailViewController.h"
#import "myorderListConfirmViewController.h"
#import "mynextBillAllViewController.h"
#import "mynextOrderlistrecommendViewController.h"
@interface mynextBillViewController ()

@end

@implementation mynextBillViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createUI{
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = self.view.bounds;
    self.pagesContainer.topBarBackgroundColor=COLOR(67, 172, 219, 0.85);
    CGFloat height ;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8) {
        height=64;
    }else if ([[UIDevice currentDevice].systemVersion floatValue]<8){
        height=64;
    }
    self.pagesContainer.view.frame = CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT-height);
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    mynextBillAllViewController*avc=[[mynextBillAllViewController alloc]initWithNibName:@"orderListRootViewController" bundle:nil];
    avc.title=@"全部";
    avc.type=1;
    avc.nc=self.navigationController;
    myorderListConfirmViewController*wvc=[[myorderListConfirmViewController alloc]initWithNibName:@"orderListRootViewController" bundle:nil];
    wvc.title=@"待确认";
    wvc.type=1;
    wvc.nc=self.navigationController;
    mynextOrderlistrecommendViewController*wrvc=[[mynextOrderlistrecommendViewController alloc]initWithNibName:@"orderListRootViewController" bundle:nil];
    wrvc.title=@"待回复";
    wrvc.type=1;
    wrvc.nc=self.navigationController;
    self.pagesContainer.viewControllers=@[avc,wvc,wrvc];
    
}
@end
