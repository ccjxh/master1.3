//
//  guideViewController.m
//  master
//
//  Created by jin on 15/8/14.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "guideViewController.h"
#import "AppDelegate.h"
#define kScreenBounds [UIScreen mainScreen].bounds

@interface guideViewController ()

@end

@implementation guideViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setGuide];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setGuide{
    UIScrollView*scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollview.showsHorizontalScrollIndicator=NO;
    scrollview.showsVerticalScrollIndicator=NO;
    scrollview.bounces=NO;
    scrollview.contentSize=CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT);
    NSArray*picArray=@[@"guide1",@"guide2",@"guide3"];
    for (NSInteger i=0; i<picArray.count; i++) {
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageview.image=[UIImage imageNamed:picArray[i]];
        imageview.userInteractionEnabled=YES;
        if (i==2) {
            UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(imageview.frame.size.width/2-50, SCREEN_HEIGHT-100, 100, 45)];
            [button setTitle:@"开启寻找" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.borderColor=[UIColor whiteColor].CGColor;
            button.layer.borderWidth=2;
            button.layer.cornerRadius=4;
            button.titleLabel.font=[UIFont systemFontOfSize:18];
            [button addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
            [imageview addSubview:button];
        }
        scrollview.userInteractionEnabled=YES;
        [scrollview addSubview:imageview];
    }
    scrollview.pagingEnabled=YES;
    [self.view addSubview:scrollview];
   
}


-(void)open{


    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate setupLoginView];

}


@end
