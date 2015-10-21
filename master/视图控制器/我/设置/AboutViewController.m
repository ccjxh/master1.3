//
//  AboutViewController.m
//  master
//
//  Created by xuting on 15/5/27.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"关于";
    //将网址设为链接
    self.iconLogo.layer.masksToBounds=YES;
    self.iconLogo.layer.cornerRadius=self.iconLogo.frame.size.width/2;
    self.siteTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.siteTextView.font = [UIFont systemFontOfSize:14];
    self.siteTextView.editable = NO;
    self.siteTextView.text = @"www.baoself.com\r\n//\r版本说明：此为测试版本";
    
}


@end
