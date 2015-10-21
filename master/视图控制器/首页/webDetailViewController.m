//
//  webDetailViewController.m
//  master
//
//  Created by jin on 15/7/16.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "webDetailViewController.h"

@interface webDetailViewController ()<UIWebViewDelegate>

@end

@implementation webDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.urlString]]];
    UIWebView*web=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    web.delegate=self;
//    if ([[UIDevice currentDevice].systemVersion floatValue]>8) {
//         web.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
//    }
    [self.view addSubview:web];
    [web loadRequest:request];
    [self net];
   
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    self.netIll.hidden=YES;
   MBProgressHUD*hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"正在加载.....";

}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.netIll.hidden=NO;

}
@end
