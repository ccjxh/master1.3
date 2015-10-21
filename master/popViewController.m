//
//  popViewController.m
//  master
//
//  Created by jin on 15/6/1.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "popViewController.h"

@interface popViewController ()<UITextViewDelegate>
@property(nonatomic) UITextView*tx;
@end

@implementation popViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initUI];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{
   
    _tx=[[UITextView alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, SCREEN_WIDTH-50)];
    _tx.autoresizesSubviews=NO;
    _tx.delegate=self;
    _tx.backgroundColor=[UIColor orangeColor];
    _tx.font=[UIFont systemFontOfSize:15];
    _tx.textColor=[UIColor blackColor];
    [self.view addSubview:_tx];
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, SCREEN_HEIGHT-40, 60, 30)];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.backgroundColor=[UIColor orangeColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}

-(void)confirm{
    if (_tx.text.length==0) {
        [self.view makeToast:@"内容不能为空" duration:1 position:@"center"];
        return;
    }
    if (_introlduceBlock) {
        _introlduceBlock(_tx.text);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
