//
//  expextationViewController.m
//  master
//
//  Created by jin on 15/6/1.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "expextationViewController.h"
#import "expextView.h"
@interface expextationViewController ()
@property(nonatomic) UITextField*tx;
@property(nonatomic)expextView*customView;
@end

@implementation expextationViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initUI{
   _customView=[[[NSBundle mainBundle]loadNibNamed:@"expextView" owner:nil options:nil]lastObject];
    if (_customView.button.selected==NO) {
        _customView.statusImage.image=[UIImage imageNamed:@"tab-下拉三角形-灰色-未点击"];
    }
    [_customView.button addTarget:self action:@selector(onclick) forControlEvents:UIControlEventTouchUpInside];

}

-(void)onclick{
  

}


-(void)setupSheet{
    UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"请选择支付类型" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"", nil];
    
    

}
@end
