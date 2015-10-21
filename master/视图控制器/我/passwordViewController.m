//
//  passwordViewController.m
//  卓宝CRM
//
//  Created by xuting on 14-12-1.
//  Copyright (c) 2014年 xuting. All rights reserved.
//

#import "passwordViewController.h"
#import "Toast+UIView.h"

@interface passwordViewController ()
{
    UITextField *_passwordText;
    UITextField *_passwordText2;
    UITextField *_oldpasswordText;
    
    UIAlertView *_passwordAlert;
    
}
@end

@implementation passwordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR(237, 237, 237, 1);
    [self initNav];
    [self initView];
    
}
-(void) initNav
{
    self.navigationItem.title = @"修改密码";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishClick)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)initView
{
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH, 40)];
    passwordLabel.text = @"请输入新密码";
    passwordLabel.textColor = [UIColor grayColor];
    passwordLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:passwordLabel];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 100)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, 40)];
    passwordLabel.textAlignment = NSTextAlignmentCenter;
    passwordLabel.text = @"密码";
    passwordLabel.textColor = [UIColor grayColor];
    passwordLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:passwordLabel];
    
    _passwordText = [[UITextField alloc] initWithFrame:CGRectMake(70, 0, SCREEN_WIDTH-70, 40)];
    //将密码设为隐藏状态
    _passwordText.secureTextEntry = YES;
    _passwordText.backgroundColor = [UIColor whiteColor];
    [view addSubview:_passwordText];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    _passwordText.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    
    passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, 70, 40)];
    passwordLabel.text = @"确认密码";
    passwordLabel.textColor = [UIColor grayColor];
    passwordLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:passwordLabel];
    
    _passwordText2 = [[UITextField alloc] initWithFrame:CGRectMake(70, 55, SCREEN_WIDTH-70, 40)];
    //将密码设为隐藏状态
    _passwordText2.secureTextEntry = YES;
    _passwordText2.backgroundColor = [UIColor whiteColor];
    [view addSubview:_passwordText2];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    _passwordText2.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    
    UILabel *cutLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, SCREEN_WIDTH, 2)];
    cutLabel.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [view addSubview:cutLabel];

}

#pragma mark - 判断是否为空
-(BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return YES;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

-(void)cancelClick
{
//    HomeViewController *ctl = [[HomeViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctl];
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)finishClick
{
    [self.view endEditing:YES];
    
    BOOL isRequest = [self isEmpty:_passwordText.text];
    BOOL isRequest2 = [self isEmpty:_passwordText2.text];
    
    //判断密码是否包含特殊字符
    NSString *phoneRegex = @"^[A-Za-z0-9\u4E00-\u9FA5_-]+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];

    NSUserDefaults *defaults;
    
    if ( isRequest )
    {
        [self.view makeToast:@"请输入密码" duration:2.0f position:@"center"];
    }
    else if (isRequest2)
    {
        [self.view makeToast:@"请输入确认密码" duration:2.0f position:@"center"];
    }
    else
    {
        if (![phoneTest evaluateWithObject: _passwordText.text] || ![phoneTest evaluateWithObject:_passwordText2.text])
        {
            [self.view makeToast:@"密码中不能包含特殊字符" duration:2.0f position:@"center"];
        }
        else if ( ![_passwordText.text isEqualToString:_passwordText2.text])
        {
            [self.view makeToast:@"两次密码输入不一致" duration:2.0 position:@"center"];
            
        }
        else if (_passwordText.text.length < 6 || _passwordText.text.length > 16)
        {
            [self.view makeToast:@"请输入6-16位的密码" duration:2.0f position:@"center"];
        }
        else
        {
            defaults = [NSUserDefaults standardUserDefaults];
            NSString *password = [defaults objectForKey:@"password"];
           
            
            NSString*urlString=[self interfaceFromString:interface_adminpassword];
            
            NSDictionary *dict = @{@"password":_passwordText.text,@"password2":_passwordText2.text,@"oldPassword":password};
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                //            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                //            [defaults setObject:_passwordText.text forKey:@"password"];
                //            [defaults synchronize];
                //            NSLog(@"--->%@",);
                NSError *error = nil;
                NSDictionary *objDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                
                int rspCode = [[objDic objectForKey:@"rspCode"] intValue];
                if (rspCode == 200)
                {
                   

                    [self.view makeToast:@"密码修改成功" duration:1 position:@"center" Finish:^{
                        
                        NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
                       
                        [user setObject:_passwordText.text forKey:[user objectForKey:@"username"]];
                        [user synchronize];
                        [self popWithnimation:self.navigationController];
                        
                    }];
                    
                    
                }
                else
                {
                    [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               
            }];
        }
    }
}
-(void)tapClick
{
    [self.view endEditing:YES];
}

@end
