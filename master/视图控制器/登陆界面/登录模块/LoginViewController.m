//
//  LoginViewController.m
//  BaoMaster
//
//  Created by xuting on 15/5/21.
//  Copyright (c) 2015年 xuting. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisteredViewController.h"
#import "XGSetting.h"
#import "XGPush.h"
#import "OpenUDID.h"
//#import "ForgetPasswordViewController.h"

@interface LoginViewController ()<UIActionSheetDelegate>

@end

@implementation LoginViewController
{
    UITextField*_account;
    UITextField*_passWord;
    UIButton*forgetButton;
    UIButton*resignButton;

}
-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self.view endEditing:YES];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"登陆";
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    NSUserDefaults*users=[NSUserDefaults standardUserDefaults];
    NSString*userName=[users objectForKey:@"username"];
    if (userName) {
        _account.text=userName;
        NSString*password=[users objectForKey:userName];
        if (password) {
            _passWord.text=password;
        }
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    [self CreateFlow];
}


-(void)login{
    NSUserDefaults*users=[NSUserDefaults standardUserDefaults];
    NSString*userName=[users objectForKey:@"username"];
    NSString*passWord=[users objectForKey:userName];
    [self startRequestWithUsername:userName Password:passWord];
}



-(void)startRequestWithUsername:(NSString*)username Password:(NSString*)password{

    __weak typeof(self)weSelf=self;
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登陆";
    NSString*urlString=[self interfaceFromString:interface_login];
    NSString* openUDID = [OpenUDID value];
    NSDictionary*dict=@{@"mobile":username,@"password":password,@"machineCode":openUDID,@"machineType":[delegate getPhoneType]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [delegate.userInforDic setObject:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"inviteCode"] forKey:@"inviteCode"];
            [delegate.userInforDic setObject:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] forKey:@"integrity"];
            NSMutableDictionary*parentDic=[[NSMutableDictionary alloc]initWithDictionary:[[[dict objectForKey:@"entity"] objectForKey:@"user"]objectForKey:@"certification"]];
            [delegate.userInforDic setObject:parentDic forKey:@"certification"];
             [self HXLoginWithUsername:username Password:password];
            [delegate requestInformation];
            NSUserDefaults*users=[NSUserDefaults standardUserDefaults];
            [users setObject:username forKey:@"username"];
            [users setObject:password forKey:username];
            [users synchronize];
            delegate.integral=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] integerValue];
             delegate.signInfo=[[NSMutableDictionary alloc]initWithDictionary:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"signInfo"]];
            delegate.userPost=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"userPost"] integerValue];
            delegate.id=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"id"] integerValue];
            [delegate setupPushWithDictory];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //延迟跳转
             [self.view makeToast:@"恭喜!登录成功。" duration:2.0f position:@"center"];
             [XGPush setAccount:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"pullTag"]];                
            [MBProgressHUD hideHUDForView:weSelf.view animated:YES];
            [delegate setHomeView];
                
            });
            
            
        } else if ([[dict objectForKey:@"rspCode"] integerValue]==500) {
            [self.view makeToast:@"用户名或密码错误!" duration:2.0f position:@"center"];
        }
        [MBProgressHUD hideHUDForView:weSelf.view animated:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:weSelf.view animated:YES];
        [self.view makeToast:@"当前网络不给力，请检查网络设置" duration:1.0f position:@"center"];
    }];
}

-(void)initUI{
    self.backView.layer.cornerRadius=5;
    self.icon.layer.masksToBounds=YES;
    self.icon.layer.cornerRadius=15;
    _account=[[UITextField alloc]initWithFrame:CGRectMake(25, 0,self.view.bounds.size.width , 40)];
    _account.font=[UIFont systemFontOfSize:15];
    _account.backgroundColor=[UIColor clearColor];
    _account.keyboardType=UIKeyboardTypeNumberPad;
    _account.placeholder=@"账号";
    _account.keyboardType=UIKeyboardTypeNumberPad;
    _account.layer.cornerRadius=5;
    [self.backView addSubview:_account];
    _passWord=[[UITextField alloc]initWithFrame:CGRectMake(25, 40,self.view.bounds.size.width , 40)];
    _passWord.font=[UIFont systemFontOfSize:15];
    _passWord.secureTextEntry=YES;
    self.name.text=@"baoself";
    self.name.textColor=[UIColor whiteColor];
    _passWord.backgroundColor=[UIColor clearColor];
    _passWord.placeholder=@"密码";
    _passWord.keyboardType=UIKeyboardTypeASCIICapable;
    self.lineView.backgroundColor=COLOR(242, 242, 242, 1);
    _passWord.layer.cornerRadius=5;
    self.name.font=[UIFont fontWithName:@"zapfino" size:30];
    self.loginButton.layer.cornerRadius=3;
    self.loginButton.backgroundColor=COLOR(22, 168, 234, 1);
    UIImageView*accountImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 13, 13, 16)];
    accountImage.image=[UIImage imageNamed:@"Shape 32@2x"];
    [self.backView addSubview:accountImage];
    UIImageView*passWordImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 51, 13, 17)];
    passWordImage.image=[UIImage imageNamed:@"LOCK@2x"];
    [self.backView addSubview:passWordImage];
    [self.backView addSubview:_passWord];
}


-(void) tapClick
{
    [self.view endEditing:YES];
}



//忘记密码
- (IBAction)forget:(id)sender {
    
    RegisteredViewController *ctl = [[RegisteredViewController alloc] init];
    ctl.states = 1;
    [self.navigationController pushViewController:ctl animated:YES];
}


- (IBAction)sendLogin:(UIButton *)sender {
    //登陆
    [self flowShow];
    if ([_account.text isEqualToString:@""]||[_passWord.text isEqualToString:@""]) {
        [self.view makeToast:@"账户名或者密码不能为空" duration:1.0f position:@"center"];
        [self flowHide];
        return;
    }
    else
    {
        NSString*urlString=[self interfaceFromString:interface_login];
        NSString* openUDID = [OpenUDID value];
        NSString*name=[[UIDevice currentDevice] model];
        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        NSString*phoneType;
        if ([delegate getPhoneType]) {
            phoneType=[delegate getPhoneType];
        }else{
        
            phoneType=@"unKnowIPhone";
        }
    
        __weak typeof(self)weakSelf=self;
   NSDictionary*dict=@{@"mobile":_account.text,@"password":_passWord.text,@"machineCode":openUDID,@"machineType":phoneType};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            [self flowHide];
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [delegate.userInforDic setObject:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"inviteCode"] forKey:@"inviteCode"];
                [delegate.userInforDic setObject:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] forKey:@"integrity"];
                NSMutableDictionary*parentDic=[[NSMutableDictionary alloc]initWithDictionary:[[[dict objectForKey:@"entity"] objectForKey:@"user"]objectForKey:@"certification"]];
                [delegate.userInforDic setObject:parentDic forKey:@"certification"];
                [self HXLoginWithUsername:_account.text Password:_passWord.text];
                [delegate requestInformation];
                NSUserDefaults*users=[NSUserDefaults standardUserDefaults];
                [users setObject:_account.text forKey:@"username"];
                [users setObject:_passWord.text forKey:_account.text];
                [users synchronize];
                delegate.integral=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] integerValue];
                delegate.signInfo=[[NSMutableDictionary alloc]initWithDictionary:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"signInfo"]];
                delegate.userPost=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"userPost"] integerValue];
                delegate.id=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"id"] integerValue];
                [delegate setupPushWithDictory];
                [self.view makeToast:@"恭喜!登录成功。" duration:2.0f position:@"center"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //延迟跳转
                    [XGPush setAccount:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"pullTag"]];
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    [delegate setHomeView];
                    [delegate setupPushWithDictory];
                    
                });
            } else  {
                [self.view makeToast:[dict objectForKey:@"msg"] duration:2.0f position:@"center"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view makeToast:@"当前网络不给力，请检查网络设置" duration:1.0f position:@"center"];
            [self flowHide];
        }];
        
    }
}


- (IBAction)resign:(UIButton *)sender {
    //注册
    RegisteredViewController *ctl = [[RegisteredViewController alloc] init];
    [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
//    [self presentViewController:self.navigationController animated:YES completion:nil];
   
}


- (IBAction)help:(id)sender {
    //需求帮助
    UIActionSheet*action=[[UIActionSheet alloc]initWithTitle:@"帮助类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"忘记密码" otherButtonTitles:@"帮助中心", nil];
    [action showInView:[[UIApplication sharedApplication].delegate window]];

}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex==0) {
        //忘记密码
        
        RegisteredViewController *ctl = [[RegisteredViewController alloc] init];
        ctl.states = 1;
        [self.navigationController pushViewController:ctl animated:YES];
        
    }else if (buttonIndex==1){
    
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.zhuobao.com"]];
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//qq登陆
- (IBAction)qqLogin:(id)sender {
    

    
    
}






//微信登陆
- (IBAction)weChatLogin:(id)sender {
    
    
    
}

@end
