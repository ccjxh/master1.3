//
//  opinionViewController.m
//  master
//
//  Created by jin on 15/7/31.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "opinionViewController.h"

@interface opinionViewController ()<UITextViewDelegate>

@end

@implementation opinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self initUI];
    self.tx.layer.borderColor=[UIColor blackColor].CGColor;
    self.tx.layer.borderWidth=1;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initUI{

    self.label.text=[NSString stringWithFormat:@"还有%u字可以填写",self.limitCount-_origin.length];
    self.tx.delegate=self;
    if (self.origin) {
        self.tx.text=self.origin;
    }
    if (self.type==2) {
        self.tx.keyboardType=UIKeyboardTypeNumberPad;
    }
    self.tx.layer.cornerRadius=2;
    [self customNavationBar];
    [self CreateFlow];
}

-(void)viewDidAppear:(BOOL)animated{
    
        [self.tx becomeFirstResponder];

}


-(void)customNavationBar{

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:0 target:self action:@selector(confirm)];

}


-(void)confirm{
    
    [self.tx resignFirstResponder];
    if (self.tx.text.length==0) {
        [self.view makeToast:@"内容不能为空" duration:1 position:@"center"];
        return;
    }else{
        if (self.type==1) {
            
            if (self.contentBlock) {
                self.contentBlock(_tx.text);
                [self popWithnimation:self.navigationController];
                return;
            }
        }
        
        if (self.type==2) {
            
            if ([self isPureNumandCharacters:_tx.text]==NO) {
                [self.view makeToast:@"人数只能为纯数字" duration:1 position:@"center"];
                return;
            }
            
            
            if (self.contentBlock) {
                self.contentBlock(_tx.text);
                [self popWithnimation:self.navigationController];
                return;
            }
        }

        
        NSString*urlString;
        NSDictionary*dict;
        if (self.type==0) {
            urlString=[self interfaceFromString:interface_updateServiceDescribe];
            dict=@{@"describe":self.tx.text};
        }
        if (self.type==1) {
            urlString=@"interface_reportInfo";
            dict=@{@"problem":self.tx.text,@"checkUser.id":[NSString stringWithFormat:@"%lu",self.id]};
        }
        
        [self flowShow];
        
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                 [self flowHide];
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center" Finish:^{
                    if (self.block) {
                        self.block(YES);
                    }
                    [self.navigationController popWithnimation:self.navigationController];
                    
                }];
            }else{
            
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                [self flowHide];
            }
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
            [self flowHide];
        }];
    
    }
    
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (temp.length>self.limitCount+1) {
        
        return NO;
        
    }
    
    self.height.constant=[self accountStringHeightFromString:self.tx.text Width:SCREEN_WIDTH-60]+40-17;
    self.label.text=[NSString stringWithFormat:@"还有%u字可以填写",self.limitCount-[textView.text length]];
    return YES;
   
}


- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string =[string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

@end
