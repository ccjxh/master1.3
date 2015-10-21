//
//  HelpAndFeedbackViewController.m
//  master
//
//  Created by xuting on 15/5/27.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "HelpAndFeedbackViewController.h"

@interface HelpAndFeedbackViewController ()<UIWebViewDelegate>

@end

@implementation HelpAndFeedbackViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,@"/admin/help/queryAllHelpList"];
  
       NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSLog(@"%@",urlString);
    
    UIWebView*web=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    web.delegate=self;
    [self.view addSubview:web];
    [web loadRequest:request];

    
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.title = @"帮助与反馈";
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
//    [self CreateFlow];
}
//#pragma mark - 确定按钮
//-(void) sureClick
//{
//    [self.view endEditing:YES];
//    [self flowShow];
//    [self commitProblemRequest];
//}
//
//#pragma mark - 提交问题请求
//-(void) commitProblemRequest
//{
//    NSString *urlString = [self interfaceFromString:interface_commitProblem];
//    NSDictionary *dict = @{@"problem":self.commitTextView.text};
//    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
//        
//        NSDictionary *objDic=(NSDictionary *)responseObject;
//        if ([[objDic objectForKey:@"rspCode"] integerValue]==200)
//        {
//            [self flowHide];
//            [self.view makeToast:@"问题提交成功!" duration:2.0f position:@"center"];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        else if ([[objDic objectForKey:@"rspCode"] integerValue]==500)
//        {
//            [self.view makeToast:@"提交出现异常!" duration:2.0f position:@"center"];
//            [self flowHide];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
////        NSLog(@"error = %@",error);
//        [self flowHide];
//    }];
//}


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
