//
//  RegisteredViewController.m
//  BaoMaster
//
//  Created by xuting on 15/5/21.
//  Copyright (c) 2015年 xuting. All rights reserved.
//

#import "RegisteredViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDKCountryAndAreaCode.h>
#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/SMSSDK+ExtexdMethods.h>
#import "OpenUDID.h"
#import "XGPush.h"
@interface RegisteredViewController ()<WXApiDelegate,UITextFieldDelegate>
{
    BOOL value; //判断验证码是否验证成功
    int timeCountDown; //倒计时60s
    NSTimer *countDownTimer; //定义一个定时器
    __weak IBOutlet UIButton *helpButton;
}
@end

@implementation RegisteredViewController

-(void) viewWillAppear:(BOOL)animated
{
    //隐藏导航栏按钮
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
       // Do any additional setup after loading the view from its nib.
    value = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.states == 1) {
        [self.registerButton removeFromSuperview];
        UIButton *resetPasswordBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        resetPasswordBtn.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
        resetPasswordBtn.frame = CGRectMake(120, 300, 80, 40);
        resetPasswordBtn.backgroundColor=COLOR(39, 166, 233, 1);
        [resetPasswordBtn setTitle:@"重置密码" forState:UIControlStateNormal];
        [resetPasswordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        resetPasswordBtn.layer.cornerRadius=5;
        resetPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [resetPasswordBtn addTarget:self action:@selector(resetPasswordClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:resetPasswordBtn];
        self.navigationItem.title = @"修改密码";
    } else {
        self.navigationItem.title = @"快速注册";
    }
    _telephoneTextField.backgroundColor = [UIColor clearColor];
    _telephoneTextField.placeholder = @"请输入正确的手机号码";
    _telephoneTextField.clearButtonMode = UITextFieldViewModeAlways;
    _verificationCodeTextField.backgroundColor = [UIColor clearColor];
    _verificationCodeTextField.clearButtonMode = UITextFieldViewModeAlways;
    _passwordTextField.backgroundColor = [UIColor clearColor];
    
    //设置密码为隐藏状态
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    _secondPasswordTextField.backgroundColor = [UIColor clearColor];
    _secondPasswordTextField.secureTextEntry = YES;
    _secondPasswordTextField.clearButtonMode = UITextFieldViewModeAlways;
//    [_getVerificationCode setImage:[self imageWithColor:[UIColor orangeColor]] forState:UIControlStateHighlighted];
    [helpButton setImage:[UIImage imageNamed:@"问号"] forState:UIControlStateNormal];
    
    _getVerificationCode.layer.cornerRadius=2;
    _getVerificationCode.layer.masksToBounds=YES;
    _getVerificationCode.titleLabel.textAlignment=NSTextAlignmentCenter;
    _getVerificationCode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _getVerificationCode.backgroundColor=COLOR(39, 166, 233, 1);
    _registerButton.layer.cornerRadius=5;
    _registerButton.userInteractionEnabled=NO;
    [helpButton addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchUpInside];
    
    if (_states==1) {
        _recommButton.hidden=YES;
        _recommendTextfile.hidden=YES;
        helpButton.hidden=YES;
        
    }
       [self CreateFlow];
}

-(void)setLineColor{

}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    
    if (_telephoneTextField.text!=nil||_verificationCodeTextField.text!=nil||_passwordTextField.text==nil||_passwordTextField.text!=nil||value==YES) {
        _registerButton.backgroundColor=_getVerificationCode.backgroundColor;
        _registerButton.userInteractionEnabled=YES;
    }else{
        _registerButton.backgroundColor=[UIColor grayColor];
        _registerButton.userInteractionEnabled=NO;

    
    }

    if (textField ==_telephoneTextField) {
            _mobileButton.backgroundColor=COLOR(39, 166, 233, 1);
            _countButton.backgroundColor=COLOR(226, 228, 226, 0.5);
            _passwordButton.backgroundColor=_countButton.backgroundColor;
            _rePasswordButton.backgroundColor=_countButton.backgroundColor;
            _recommButton.backgroundColor=_countButton.backgroundColor;
        }

    if (textField==_verificationCodeTextField) {
            _countButton.backgroundColor=_getVerificationCode.backgroundColor;
            _mobileButton.backgroundColor=COLOR(226, 228, 226, 0.5);
            _passwordButton.backgroundColor=_mobileButton.backgroundColor;
            _rePasswordButton.backgroundColor=_mobileButton.backgroundColor;
            _recommButton.backgroundColor=_mobileButton.backgroundColor;
        }
    if (textField==_passwordTextField) {
       
            _passwordButton.backgroundColor=_getVerificationCode.backgroundColor;
            _mobileButton.backgroundColor=COLOR(226, 228, 226, 0.5);
            _countButton.backgroundColor=_mobileButton.backgroundColor;
            _rePasswordButton.backgroundColor=_mobileButton.backgroundColor;
            _recommButton.backgroundColor=_mobileButton.backgroundColor;
              }
    if (textField ==_secondPasswordTextField) {
      
            _rePasswordButton.backgroundColor=_getVerificationCode.backgroundColor;
            _mobileButton.backgroundColor=COLOR(226, 228, 226, 0.5);
            _countButton.backgroundColor=_mobileButton.backgroundColor;
            _passwordButton.backgroundColor=_mobileButton.backgroundColor;
            _recommButton.backgroundColor=_mobileButton.backgroundColor;
         }
        
    if (textField ==_recommendTextfile) {
            _recommButton.backgroundColor=_getVerificationCode.backgroundColor;
            _mobileButton.backgroundColor=COLOR(226, 228, 226, 0.5);
            _countButton.backgroundColor=_mobileButton.backgroundColor;
            _passwordButton.backgroundColor=_mobileButton.backgroundColor;
            _rePasswordButton.backgroundColor=_mobileButton.backgroundColor;
    }
    
    
}


-(void)help{

    [self.view makeToast:@"输入推荐码,注册可以获得积分" duration:1.5f position:@"center"];

}




- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - 获取验证码按钮点击事件
- (IBAction)getVerificationCodeClick:(id)sender {
    //判断手机号码验证是否正确，正确可执行获取验证码操作
    BOOL buttonClick = NO;
    //判断手机号码是否正确
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    if ( ![phoneTest evaluateWithObject: _telephoneTextField.text] ){
        [self.view endEditing:YES];
        [self.view makeToast:@"请输入正确的手机号码" duration:2.0 position:@"center"];
    } else {
        buttonClick = YES;
        timeCountDown = 60;
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
//        [self.getVerificationCode setTitle:[NSString stringWithFormat:@"获取验证码(%d)",timeCountDown--] forState:UIControlStateNormal];
        self.numberLabel.text = [NSString stringWithFormat:@"(%d)",timeCountDown--];
        self.numberLabel.textColor = [UIColor grayColor];
        [self.getVerificationCode setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.getVerificationCode.userInteractionEnabled = NO; //设置获取验证码不被点击
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_telephoneTextField.text
                                       zone:@"+86"
                           customIdentifier:nil
                                     result:^(NSError *error)
         {
             
             if (!error)
             {
                 NSLog(@"验证码发送成功");
                
             }
             else
             {
                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                                 message:[NSString stringWithFormat:@"错误描述：%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                                delegate:self
                                                       cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                       otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }];

    }
}
#pragma mark - 定时器实现的方法
-(void)timeFireMethod
{
    if (timeCountDown == 0) {
        [countDownTimer invalidate]; //取消定时器
        [self.getVerificationCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.numberLabel.text = @"";
        [self.getVerificationCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.getVerificationCode.userInteractionEnabled = YES;
    } else {
        self.numberLabel.text = [NSString stringWithFormat:@"(%d)",timeCountDown--];
        self.numberLabel.textColor = [UIColor grayColor];
        self.getVerificationCode.userInteractionEnabled = NO; //设置获取验证码按钮不被点击
    }
}
#pragma mark TextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField  
{
    [self.view endEditing:YES];
    if (textField == self.verificationCodeTextField) {
        if (self.verificationCodeTextField.text.length == 4)
        {
            [self.view endEditing:YES];
            [SMSSDK commitVerificationCode:self.verificationCodeTextField.text phoneNumber:_telephoneTextField.text zone:@"+86" result:^(NSError *error) {
                
                if (!error) {
                    [self.getVerificationCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                    self.registerButton.userInteractionEnabled = YES;
                    [countDownTimer invalidate]; //取消定时器
                    [self.view makeToast:@"验证成功" duration:1.0f position:@"center"];
                    value=YES;
                }
                else
                {
                    [self.view makeToast:@"验证码输入错误" duration:1.0f position:@"center"];
                    [self.getVerificationCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                    self.registerButton.userInteractionEnabled = YES;
                    [countDownTimer invalidate]; //取消定时器
                     [self.getVerificationCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                }
            }];
            self.registerButton.userInteractionEnabled = YES;
         }
    }
}
#pragma mark - 注册按钮点击事件
- (IBAction)registerdClick:(id)sender {
    [self flowShow];
    [self requestAFNet];
}
#pragma mark - 重置密码按钮点击事件
- (void) resetPasswordClick
{
    [self requestAFNet];
}
#pragma mark - 注册或重置密码的实现
-(void) requestAFNet
{
    value=YES;
    NSString* openUDID = [OpenUDID value];
    NSString*name=[[UIDevice currentDevice] model];
    if (self.telephoneTextField.text.length == 0) {
        [self flowHide];
        [self.view makeToast:@"请填写正确的手机号码" duration:2.0f position:@"center"];
        [self flowHide];
    } else if( !value) {
        [self flowHide];
        [self.view makeToast:@"请填写验证码" duration:1.5f position:@"center"];
        return;
        
    } else if(self.passwordTextField.text.length == 0 || self. secondPasswordTextField.text.length == 0) {
        [self flowHide];
        [self.view makeToast:@"请填写密码" duration:2.0f position:@"center"];
        [self flowHide];
    } else if (self.passwordTextField.text.length >=19 || self.secondPasswordTextField.text.length >= 19){
        [self.view makeToast:@"密码长度不能超过19位数" duration:2.0f position:@"center"];
        [self flowHide];
    } else if ( ![self.passwordTextField.text isEqualToString:self.secondPasswordTextField.text]) {
        [self.view makeToast:@"两次密码输入不一致" duration:2.0f position:@"center"];
        [self flowHide];
    }else if (value==NO){
    
        [self.view makeToast:@"请输入正确的验证码" duration:1.0f position:@"center"];
        return;
    
    }else{
        
        if (self.states == 1)
        {
            AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
           
            NSString*urlString=[self interfaceFromString:interface_resetPassword];
            NSDictionary*dict=@{@"mobile":_telephoneTextField.text,@"password":_passwordTextField.text,@"password2":_secondPasswordTextField.text,@"machineType":[delegate getPhoneType],@"machineCode":openUDID};
            [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary*dict=(NSDictionary*)responseObject;
                [self flowHide];
                if ([[dict objectForKey:@"rspCode"] integerValue]==200)
                {
                    [self.view makeToast:@"恭喜！密码重置成功。" duration:2.0f position:@"center"];
                    [delegate setupHome];
                }else{
                 [self.view makeToast:[dict objectForKey:@"msg"] duration:2.0f position:@"center"];
                
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self flowHide];
                [self.view makeToast:@"当前网络不给力，请检查网络设置" duration:1.0f position:@"center"];
            }];
            
        } else {
            NSString*urlString=[self interfaceFromString:interface_register];
            NSDictionary*dict;
            dict=@{@"mobile":_telephoneTextField.text,@"password":_passwordTextField.text,@"password2":_secondPasswordTextField.text,@"machineType":name,@"machineCode":openUDID};
            if (_recommendTextfile.text!=nil) {
                dict=@{@"mobile":_telephoneTextField.text,@"password":_passwordTextField.text,@"password2":_secondPasswordTextField.text,@"machineType":name,@"machineCode":openUDID,@"inviteCode":_recommendTextfile.text};
            }
            [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary*dict=(NSDictionary*)responseObject;
                [self flowHide];
                
                if ([[dict objectForKey:@"rspCode"] integerValue]==200)
                {
                   [self.view makeToast:@"恭喜！注册成功。" duration:1 position:@"center" Finish:^{
                   AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                       
                   [delegate.userInforDic setObject:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"inviteCode"] forKey:@"inviteCode"];
                   [delegate.userInforDic setObject:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] forKey:@"integrity"];
                    NSMutableDictionary*parentDic=[[NSMutableDictionary alloc]initWithDictionary:[[[dict objectForKey:@"entity"] objectForKey:@"user"]objectForKey:@"certification"]];
                    [delegate.userInforDic setObject:parentDic forKey:@"certification"];
                   NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
                   if ([user objectForKey:@"username"]) {
                       [user removeObjectForKey:@"username"];
                       if ([user objectForKey:@"password"]) {
                           [user removeObjectForKey:@"password"];
                       }
                            
                    }
                  [user setObject:_telephoneTextField.text forKey:@"username"];
                  [user setObject:_passwordTextField.text forKey:@"password"];
                  [user synchronize];
                  delegate.id=[[[[dict objectForKey:@"entity"] objectForKey:@"user"]objectForKey:@"id"] integerValue];
                  [XGPush setAccount:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"pullTag"]];
                  delegate.signInfo=[[NSMutableDictionary alloc]initWithDictionary:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"signInfo"]];
                 delegate.integral=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] integerValue] ;
                  [delegate setupPushWithDictory];
                  delegate.isLogin=YES;
                  delegate.userPost=1;
                  [delegate requestInformation];
//                  [delegate requestAdImage];
                  [delegate setHomeView];
                        
                    }];
                    
                        }
                else if([[dict objectForKey:@"rspCode"] integerValue]==500)
                {
                    [self flowHide];
                    [self.view makeToast:[dict objectForKey:@"msg"] duration:2.0f position:@"center"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self flowHide];
                [self.view makeToast:@"当前网络不给力，请检查网络设置" duration:1.0f position:@"center"];
            }];
        }
    }
    [self flowHide];
}

- (IBAction)weChat:(id)sender {
  
    
}


-(void) onReq:(BaseReq*)req{


    

}

- (IBAction)QQ:(id)sender {
    
    //QQ注册
    
}

@end
