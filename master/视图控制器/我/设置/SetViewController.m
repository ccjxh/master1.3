//
//  SetViewController.m
//  master
//
//  Created by xuting on 15/5/27.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "SetViewController.h"
#import "HelpAndFeedbackViewController.h" //帮助与反馈界面
#import "AboutViewController.h" //关于界面
#import "XGPush.h"
#import "passwordViewController.h"
@interface SetViewController ()<UIAlertViewDelegate>
{
    NSArray *setArr;
}
@end

@implementation SetViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置";
    self.setTableView.delegate = self;
    self.setTableView.dataSource = self;
    self.setTableView.scrollEnabled = NO; //设置tableview不被滑动
    setArr = @[@"帮助",@"密码修改",@"关于"];
    
    [self CreateFlow];
}

- (IBAction)logoutButton:(id)sender
{
    [self flowShow];
    
    NSString *urlString = [self interfaceFromString:interface_loginout];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        
        [self flowHide];
        
        NSDictionary *dict = (NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200)
        {
            [self.view makeToast:@"恭喜!退出成功。" duration:2.0f position:@"center"];
            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            NSUserDefaults*users=[NSUserDefaults standardUserDefaults];
            NSString*userName=[users objectForKey:@"username"];
            NSString*passWord=[users objectForKey:userName];
            [users removeObjectForKey:userName];
            [users synchronize];
            [XGPush unRegisterDevice];
            [delegate setLogout];
        }
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        
    }];
}

#pragma mark - UITableViewDelegate
-(NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return setArr.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"111"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"111"];
    }
    cell.textLabel.text = setArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    //设置右边箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark - UITableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
       
        case 0:
        {
            HelpAndFeedbackViewController *ctl = [[HelpAndFeedbackViewController alloc] init];
            [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
        }
            break;
        case 1:{
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证原密码" message:@"为保障数据安全，修改前请输入原密码." delegate:nil cancelButtonTitle:@"验证" otherButtonTitles:@"取消", nil];
            alert.tag = 2;
            [alert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
            alert.delegate = self;
            [alert show];
        
        
        }
            
            break;
        case 2:
        {
            AboutViewController *ctl = [[AboutViewController alloc] init];
            [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
        }
            break;
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex==0) {
        NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
        NSString*password=[user objectForKey:@"password"];
        if ([[alertView textFieldAtIndex:0].text isEqualToString:password] ) {
            
            passwordViewController *ctl = [[passwordViewController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
            
        }
        else
        {
            [self.view makeToast:@"与原密码不一致" duration:2.0 position:@"center"];
        }

    }

}

@end
