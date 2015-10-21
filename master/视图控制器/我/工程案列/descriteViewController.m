//
//  descriteViewController.m
//  master
//
//  Created by jin on 15/6/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "descriteViewController.h"

@interface descriteViewController ()<UITextViewDelegate>

@end

@implementation descriteViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self CreateLabel];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    if (self.model.caseName) {
        _tx.text=self.model.caseName;
    }
   
    
}


-(void)confirm{
    
    
    if (_name.text.length==0) {
        [self.view makeToast:@"案例名称不能为空" duration:1 position:@"center"];
        return;
    }

    if (_tx.text.length==0) {
        [self.view makeToast:@"内容不能为空" duration:1 position:@"center"];
        return;
    }
    

    

}


-(void)textViewDidChange:(UITextView *)textView{
    UILabel*label=(id)[self.view viewWithTag:10];
    if (textView.text.length==0) {
        if (!label) {
            [self CreateLabel];
        }
    }else{
        
        [label removeFromSuperview];
    }
    
    

}

-(void)CreateLabel{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 120, 20)];
    label.textColor=COLOR(228, 228, 228, 1);
    label.font=[UIFont systemFontOfSize:15];
    label.text=@"请输入内容";
    label.tag=10;
    [_tx addSubview:label];
    
}

@end


