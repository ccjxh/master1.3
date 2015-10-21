//
//  selectViewController.m
//  master
//
//  Created by jin on 15/5/18.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "selectViewController.h"
#import "headViewController.h"
#import "cityViewController.h"
#import "contractorViewController.h"
#import "webDetailViewController.h"
#import "findMaster.h"
@interface selectViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate,UIAlertViewDelegate>
@property(nonatomic)NSString*currentCityName;
@property(nonatomic)NSMutableArray*ADArray;
@end

@implementation selectViewController
{
    findMaster*masterView;
    UITextField*_tx;
    UIView*contentView;

}



-(void)receiveNotice{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:@"updateUI" object:nil];
    
}

-(void)update{
//    SDCycleScrollView*sdvc=(id)[self.view viewWithTag:100];
//    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
//    sdvc.imageURLStringsGroup=delegate.pictureArray;
}



-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"update" object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
     _currentCityName=@"深圳市";
    [self requestAdImage];
    [self requestPay];
    [self request];
    [self initUI];
    [self createUI];
    [self receiveNotice];
    [self customNavigation];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate setupMap];
    delegate.cityChangeBlock=^(NSString*name){
    
        if (delegate.id!=381) {
            
        if ([_currentCityName isEqualToString:delegate.city]==NO) {
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"" message:@"是否切换到定位城市" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
 
            }
        }
    
    };

    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104650241" andDelegate:self];
    _permissions =[NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
    [self CreateFlow];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    
}


#pragma mark-customNavigation
-(void)customNavigation{

    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    [button setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(feedback) forControlEvents:UIControlEventTouchUpInside];
      self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}



-(void)feedback{
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 140)];
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 25;
    welcomeLabelRect.size.height = 20;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:16];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"反馈!";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textAlignment=NSTextAlignmentRight;
    welcomeLabel.textColor = [UIColor blackColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = CGRectGetMaxY(welcomeLabelRect)+5;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect);
    infoLabelRect.size.height-=40;
    _tx=[[UITextField alloc]initWithFrame:infoLabelRect];
    _tx.font=[UIFont systemFontOfSize:16];
    _tx.layer.cornerRadius=7;
    _tx.placeholder=@"在这里输入内容";
    [_tx becomeFirstResponder];
    _tx.delegate=self;
    [_tx setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _tx.backgroundColor=contentView.backgroundColor;
    _tx.textColor=[UIColor blackColor];
    [contentView addSubview:_tx];
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(_tx.frame.origin.x, _tx.frame.origin.y+_tx.frame.size.height-5, _tx.frame.size.width, 1)];
    view.backgroundColor=COLOR(74, 166, 216, 1);
    [contentView addSubview:view];
    CGRect txBounce = CGRectInset(contentView.bounds, 5, 5);
    txBounce.origin.y=CGRectGetMaxY(infoLabelRect)+5;
    txBounce.size.width-=30;
    txBounce.size.height=30;
    NSArray*array=@[@"确定",@"取消"];
    for (NSInteger i=0; i<array.count; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:txBounce];
        button.frame=CGRectMake(150+i*60, button.frame.origin.y, 50, button.frame.size.height+10);
        button.backgroundColor=contentView.backgroundColor;
        button.layer.borderColor=[[UIColor whiteColor]CGColor];
        button.layer.borderWidth=1;
        button.layer.cornerRadius=3;
        button.tag=40+i;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i==0) {
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.userInteractionEnabled=NO;
        }
        button.titleLabel.font=[UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(changeDEsscribe:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
    }
    contentView.backgroundColor=[UIColor whiteColor];
    [KGModal sharedInstance].modalBackgroundColor=[UIColor whiteColor];
    [KGModal sharedInstance].showCloseButton=NO;
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];


}


-(void)initUI{
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, self.navigationController.navigationBar.frame.size.height)];
    button.tag=10;
    
    [button addTarget:self action:@selector(changecity) forControlEvents:UIControlEventTouchUpInside];
    UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 14, 14, 18)];
    imageview.image=ImageNamed(@"2.png");
    imageview.tag=11;
    [button addSubview:imageview];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(17, 9, 60, 30)];
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:13];
    label.text=_currentCityName;
    [button addSubview:label];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];


}



-(void)changecity
{
    cityViewController*cvc=[[cityViewController alloc]init];
    if (self.orginCity) {
        
        cvc.city=self.orginCity;
        
    }
    cvc.TBlock=^(AreaModel*CityModel){
        _currentCityName=CityModel.name;
        [self initUI];
    };
    [self pushWinthAnimation:self.navigationController Viewcontroller:cvc];
    
}


-(void)changeDEsscribe:(UIButton*)button{

    [[KGModal sharedInstance]hideAnimated:YES];
    
    if ([button.titleLabel.text isEqualToString:@"取消"]==YES) {
        return;
    }
    
    
    if (_tx.text.length==0) {
        [self.view makeToast:@"内容不能为空" duration:1 position:@"center"];
        return;
    }
    if ([button.titleLabel.text isEqualToString:@"确定"]==YES) {
        [self flowShow];
        NSString*urlString=[self interfaceFromString:interface_feedBack];
        NSDictionary*dict=@{@"problem":_tx.text};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            [self flowHide];
            NSDictionary*dict=(NSDictionary*)responseObject;
            if ([[dict objectForKey:@"rspCode"] intValue]==200) {
                [self.view makeToast:@"提交成功" duration:1 position:@"center"];
            }else{
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
            
            }
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
            [self flowHide];
            [self.view makeToast:@"网络异常" duration:1 position:@"center"];
        }];
    }

}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    UIButton*button=(id)[contentView viewWithTag:40];
    
    if (textField.text.length==0) {
        
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.userInteractionEnabled=NO;
    }else{
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.userInteractionEnabled=YES;
    }
    
    NSString *temp = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (temp.length>6) {
        
        
        return NO;
        
    }
    return YES;
    
}


#pragma mark-主界面UI
-(void)createUI{
    
    findMaster*findView=[[[NSBundle mainBundle]loadNibNamed:@"findMaster" owner:nil options:nil]lastObject];
    findView.workBlock=^{
        
        headViewController*hvc=[[headViewController alloc]init];
        hvc.cityName=_currentCityName;
        hvc.firstLocation=2;
        hvc.hidesBottomBarWhenPushed=YES;
        [self pushWinthAnimation:self.navigationController Viewcontroller:hvc];
        
    };
    
    findView.workHeadBlock=^{
        
        contractorViewController*cvc=[[contractorViewController alloc]init];
        cvc.cityName=_currentCityName;
        cvc.hidesBottomBarWhenPushed=YES;
        [self pushWinthAnimation:self.navigationController Viewcontroller:cvc];
        
    };
    
    [self.view addSubview:findView];
    
}



//缓存支付
-(void)requestPay{
    
    NSString*urlString=[self interfaceFromString:interface_moneyType];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] intValue]==200) {
            NSArray*Array=[dict objectForKey:@"entities"];
            for (NSInteger i=0; i<Array.count; i++) {
                NSDictionary*inforDict=Array[i];
                payModel*model=[[payModel alloc]init];
                [model setValuesForKeysWithDictionary:[inforDict objectForKey:@"dataItem"]];
                [[dataBase share]addPay:model];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
    
}





//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
//{
//    webDetailViewController*wvc=[[webDetailViewController alloc]initWithNibName:@"webDetailViewController" bundle:nil];
//    adModel*model=_ADArray[index];
//    wvc.urlString=model.url;
//    [self pushWinthAnimation:self.navigationController Viewcontroller:wvc];
//    
//}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        _currentCityName=delegate.city;
        [self initUI];
    }


}




#pragma mark-网络数据请求
-(void)request
{
    [self flowShow];
    AreaModel*model3=[[dataBase share]findWithCity:_currentCityName];
    NSArray*array=[[dataBase share]findWithPid:model3.id];
    if (array.count==0) {
        NSString*urlString=[self interfaceFromString:interface_resigionList];
        NSDictionary*dict=@{@"cityId":[NSString stringWithFormat:@"%lu",model3.id]};
        [[httpManager share]GET:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            NSArray*tempArray=[dict objectForKey:@"entities"];
            NSMutableArray*valueArray=[[NSMutableArray alloc]init];
            for (NSInteger i=0; i<tempArray.count; i++) {
                NSDictionary*inforDict=tempArray[i];
                AreaModel*model=[[AreaModel alloc]init];
                NSDictionary*tempDic=[inforDict objectForKey:@"dataCatalog"];
                [model setValuesForKeysWithDictionary:tempDic];
                [valueArray addObject:model];
            }
            
            [[dataBase  share]addCityToDataBase:tempArray Pid:model3.id];
            [self flowHide];
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
            [self flowHide];
            
        }];
    }
}



//地图相关设置



-(void)requestAdImage{
    if (!_ADArray) {
        _ADArray=[[NSMutableArray alloc]init];
    }
    [_ADArray removeAllObjects];
    NSString*urlString=[self interfaceFromString:interface_banners];
    [[httpManager manager]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            NSArray*Array=[dict objectForKey:@"entities"];
            for (NSInteger i=0; i<Array.count; i++) {
                NSDictionary*inforDic=Array[i];
                NSString*url=[[inforDic objectForKey:@"advertising"] objectForKey:@"resource"];
                NSString*temp=[NSString stringWithFormat:@"%@%@",changeURL,url];
                adModel*model=[[adModel alloc]init];
                [model setValuesForKeysWithDictionary:[inforDic objectForKey:@"advertising"]];
                [_ADArray addObject:model];
            }
            
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUI" object:nil userInfo:nil];
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
