//
//  myorderBillViewController.m
//  master
//
//  Created by jin on 15/6/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "myorderBillViewController.h"
#import "MNextOrderDetailViewController.h"
#import "allViewController.h"
#import "waitCaseViewController.h"
#import "waitrecommendViewController.h"
@interface myorderBillViewController ()
@end

@implementation myorderBillViewController



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
    allViewController*avc=[[allViewController alloc]initWithNibName:@"orderListRootViewController" bundle:nil];
    avc.title=@"全部";
    avc.nc=self.navigationController;
    waitCaseViewController*wvc=[[waitCaseViewController alloc]initWithNibName:@"orderListRootViewController" bundle:nil];
    wvc.title=@"待确认";
    wvc.nc=self.navigationController;
    waitrecommendViewController*wrvc=[[waitrecommendViewController alloc]initWithNibName:@"orderListRootViewController" bundle:nil];
    wrvc.title=@"待评价";
    wrvc.nc=self.navigationController;
    self.pagesContainer.viewControllers=@[avc,wvc,wrvc];
}

@end
