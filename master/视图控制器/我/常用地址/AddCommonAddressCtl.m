//
//  AddCommonAddressCtl.m
//  master
//
//  Created by xuting on 15/6/4.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "AddCommonAddressCtl.h"
#import "ProvinceTableViewController.h"
#import "requestModel.h" 

@interface AddCommonAddressCtl ()
{
    NSDictionary *notiDict; // 保存通知中心传过来的字典
}
@end

@implementation AddCommonAddressCtl



- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestToken];
    // Do any additional setup after loading the view from its nib.
    //注册通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateRegion:) name:@"address" object:nil];
    notiDict = [NSDictionary dictionary];
    self.detailAddress.borderStyle = UITextBorderStyleNone;
    self.detailAddress.clearButtonMode = UITextFieldViewModeAlways;
    //label添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressTap)];
    self.regionLabel.userInteractionEnabled = YES;
    [self.regionLabel addGestureRecognizer:tap];
    if (self.type==1) {
        self.regionLabel.text=[NSString stringWithFormat:@"%@-%@-%@",[self.model.province objectForKey:@"name"],[self.model.city objectForKey:@"name"],[self.model.region objectForKey:@"name"]];
        self.detailAddress.text=self.model.street;
       
        
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addCommonAddress)];
    
}
#pragma 添加常用地址
-(void) addCommonAddress
{
    
    if (self.regionLabel.text.length==0) {
        [self.view makeToast:@"请选择城市信息" duration:1 position:@"center"];
        return;
    }
    if (self.detailAddress.text.length==0) {
        [self.view makeToast:@"详细地址不能为空" duration:1 position:@"center"];
        return;
    }
    
    NSString *urlString = [self interfaceFromString:interface_addCommonAddress];
    NSDictionary *dict;
    if ([notiDict objectForKey:@"regionId"]) {
        dict = @{@"region.id":[notiDict objectForKey:@"regionId"],@"street":self.detailAddress.text};
        if (self.token) {
            dict=@{@"region.id":[notiDict objectForKey:@"regionId"],@"street":self.detailAddress.text,@"token":self.token};;
        }
    }
    
    if (self.type==1) {
        urlString=[self interfaceFromString:interface_updateAddress];
        dict=@{@"region.id":[self.model.region objectForKey:@"id"],@"street":self.detailAddress.text,@"id":[NSString stringWithFormat:@"%u",self.model.id]};
        if ([notiDict objectForKey:@"regionId"]) {
            dict = @{@"region.id":[notiDict objectForKey:@"regionId"],@"street":self.detailAddress.text,@"id":[NSString stringWithFormat:@"%u",self.model.id]};
        }
    }
    
    [[httpManager share] POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([[dic objectForKey:@"rspCode"]integerValue] == 200)
            {
                self.addCommonAddressBlock(@"yes");
            }
            [self.navigationController popViewControllerAnimated:YES];
        
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}



-(NSString*)requestToken{
    
    __block NSString*token;
    NSString*urlString=[self interfaceFromString:interface_token];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        self.token= [[dict objectForKey:@"properties"] objectForKey:@"token"];
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
    return token;
}


#pragma mark - 通知中心方法
-(void) upDateRegion:(NSNotification *)nof
{
    notiDict =  nof.object;
    self.regionLabel.text = [notiDict objectForKey:@"region"];
    [requestModel requestRegionInfo:[notiDict objectForKey:@"regionId"]];
    
}
#pragma mark - label点击事件
-(void) addressTap
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"3" forKey:@"type"];
    [defaults synchronize];
    ProvinceTableViewController *pVC = [[ProvinceTableViewController alloc] init];
    [self pushWinthAnimation:self.navigationController Viewcontroller:pVC];
    
}

@end
