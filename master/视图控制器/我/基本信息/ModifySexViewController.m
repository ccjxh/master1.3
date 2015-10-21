//
//  ModifySexViewController.m
//  master
//
//  Created by xuting on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "ModifySexViewController.h"

@interface ModifySexViewController ()

@end

@implementation ModifySexViewController

- (IBAction)sexChooseButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1)
    {
        self.gendarValueBlock(0,0);
    }
    else
    {
        self.gendarValueBlock(1,1);
    }
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"性别";
    
    
}

@end
