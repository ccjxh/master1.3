//
//  myTabViewController.m
//  master
//
//  Created by jin on 15/9/1.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "myTabViewController.h"

@interface myTabViewController ()

@end

@implementation myTabViewController

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

    self.tabBar.hidden=YES;
    NSArray*images=@[@"找师傅-未选择",@"找工作-未选择",@"我的-未选择"];
    NSArray*selectImages=@[@"找师傅",@"找工作",@"我的"];
    NSArray*titles=@[@"找师傅",@"找活干",@"我的"];
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, self.tabBar.frame.origin.y, SCREEN_WIDTH,self.tabBar.frame.size.height)];
    view.userInteractionEnabled=YES;
    view.backgroundColor=COLOR(250, 250, 250, 1);
    for (NSInteger i=0; i<images.count; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(10+i*(SCREEN_WIDTH/3), 0, SCREEN_WIDTH/images.count, 49)];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:COLOR(22, 168, 234, 1) forState:UIControlStateSelected];
        [button setTitleColor:COLOR(135, 135, 135, 1) forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:10];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectImages[i]] forState:UIControlStateSelected];
        button.titleEdgeInsets=UIEdgeInsetsMake(35, -56, 0, 0);
        button.imageEdgeInsets=UIEdgeInsetsMake(-13, 0, 0, 0);
        if (i==2) {
            button.titleEdgeInsets=UIEdgeInsetsMake(35, -49, 0, 0);
        }
        button.tag=10+i;
        [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            button.selected=YES;
            button.userInteractionEnabled=NO;
            self.selectedIndex=1;
        }
        [view addSubview:button];
        
    }
    [self.view addSubview:view];
    
}


-(void)selected:(UIButton*)button{

    button.selected=YES;
    button.userInteractionEnabled=NO;
    self.selectedIndex=button.tag-10;
    for (NSInteger i=0; i<3; i++) {
        UIButton*tempButton=(id)[self.view viewWithTag:i+10];
        if (tempButton.tag==button.tag) {
            continue;
        }
        NSLog(@"%lu",tempButton.tag);
        
        tempButton.selected=NO;
        tempButton.userInteractionEnabled=YES;
    }

}

@end
