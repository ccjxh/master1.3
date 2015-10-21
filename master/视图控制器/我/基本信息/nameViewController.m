//
//  nameViewController.m
//  master
//
//  Created by jin on 15/7/31.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "nameViewController.h"

@interface nameViewController ()<UITextFieldDelegate>

@end

@implementation nameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    if (self.origin) {
    self.name.text=self.origin;
        
        
        
    }
    
     self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:0 target:self action:@selector(confirm)];
    [self CreateFlow];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    // Dispose of any resources that can be recreated.
}


-(void)confirm{
    
    
     [self.name resignFirstResponder];
    
    if (self.type==1) {
        if (self.contentChange) {
            self.contentChange(self.name.text);
            [self popWithnimation:self.navigationController];
            return;
        }
        
    }
//    0755-36800118
    
    if (self.type==2) {
        
        if ([self isMobileNumber:self.name.text]==NO) {
            [self.view makeToast:@"联系电话格式不对，正确手机格式：1392463XXXX；固话格式：07553680XXXX" duration:2.5 position:@"center"];
            return;
        }
        
        if (self.contentChange) {
            self.contentChange(self.name.text);
            [self popWithnimation:self.navigationController];
            return;
        }
    }
    
    [self flowShow];
    for(int i=0; i< [self.name.text length];i++){
        int a = [self.name.text characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            
        }else{
        [self flowHide];
        [self.view makeToast:@"请输入汉字" duration:1 position:@"center"];
        return ;
            
        }
    }
    NSString*urlString=[self interfaceFromString:interface_updateRealName];
    NSDictionary*dict=@{@"realName":self.name.text};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        if ([[dict objectForKey:@"rspCode"] intValue]==200) {
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center" Finish:^{
                AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
                model.realName=self.name.text;
                [[dataBase share]addInformationWithModel:model];
                if (self.contentChange) {
                    self.contentChange(self.name.text);
                }
               
                if ([[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] ) {
                    delegate.integrity=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] integerValue];
                    
                }
                if ([[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"]) {
                    if (delegate.integral-[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] integerValue]>0) {
                        delegate.integral= [[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] integerValue];
                        NSDictionary*parent=@{@"value":[NSString stringWithFormat:@"%lu",delegate.integral]};
                        NSNotification*noction=[[NSNotification alloc]initWithName:@"showIncreaImage" object:nil userInfo:parent];
                        [[NSNotificationCenter defaultCenter]postNotification:noction];

                    }
                }                
                
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
              
            }];
        }else{
        
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
        }
                
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
       
        [self flowHide];
        
    }];

}


-(void)delayMethod{

  [self popWithnimation:self.navigationController];

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *temp = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (temp.length>16) {
        return NO;
    }
    return YES;
}



- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
     NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate*regextestphs=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestphs evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
