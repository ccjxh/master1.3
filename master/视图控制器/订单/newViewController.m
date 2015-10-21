//
//  newViewController.m
//  master
//
//  Created by jin on 15/6/27.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "newViewController.h"

@interface newViewController ()
@property(nonatomic)DAPagesContainer*pagesContainer;
@end

@implementation newViewController



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = self.view.bounds;
    self.pagesContainer.topBarBackgroundColor=COLOR(221, 221, 221, 1);
//    self.pagesContainer.pageItemsTitleColor=COLOR(221, 221, 221, 1);
    CGFloat height;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8) {
        height=64;
    }else if ([[UIDevice currentDevice].systemVersion floatValue]<8){
        height=44;

    }
    self.pagesContainer.view.frame=CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT-height);
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    
    allViewController *beaverViewController = [[allViewController alloc] init];
    beaverViewController.view.backgroundColor=[UIColor orangeColor];
    beaverViewController.title = @"全部";
    
    waitConfirmViewController *buckDeerViewController = [[waitConfirmViewController alloc] init];
    buckDeerViewController.title = @"待确认";
    waitRecommendViewController *catViewController = [[waitRecommendViewController alloc] init];
    catViewController.title = @"待评价";
    self.pagesContainer.viewControllers = @[beaverViewController, buckDeerViewController, catViewController];
}

- (void)viewWillUnload
{
    self.pagesContainer = nil;
    [super viewWillUnload];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.pagesContainer updateLayoutForNewOrientation:toInterfaceOrientation];
}

@end
