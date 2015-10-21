//
//  MNextOrderDetailViewController.m
//  master
//
//  Created by jin on 15/6/2.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "MNextOrderDetailViewController.h"
#import "WechatPayViewController.h"
@interface MNextOrderDetailViewController ()
@property(nonatomic)UITextField*tx;//拒绝理由
@end

@implementation MNextOrderDetailViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.backgroundColor=COLOR(221, 221, 221, 1);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)finish{
    
    UIView*view=(id)[self.view viewWithTag:101];
    if (view) {
        [view removeFromSuperview];
    }
    if (self.recommentStatus!=1) {
        self.tableview.tableFooterView=[self createButton];
    }
}

-(void)send{
    NSString*urlString=[self interfaceFromString: interface_myOrderDetail];
    [self requestWithUrl:urlString];
}

-(UIView*)createButton{
    
    switch (self.billStatus) {
        case 0:
            self.orderStatus=@"待付款";
            break;
            case 1:
            self.orderStatus=@"等待对方接单";
            break;
            case 2:
            self.orderStatus=@"确认完工";
            break;
            case 3:
            self.orderStatus=@"已拒绝";
            break;
            case 4:
            if (self.recommentStatus==1) {
                self.orderStatus=@"单据完结";
            }else{
                
                self.orderStatus=@"待评价";
            }
            break;
            case 5:
            self.orderStatus=@"已终结";
            break;
        default:
            break;
    }
    if (self.billStatus==3||self.billStatus==5) {
        return nil;
    }
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.tag=101;
    view.backgroundColor=COLOR(221, 221, 221, 1);
    self.statusButton=[[UIButton alloc]initWithFrame:CGRectMake(30, 5, SCREEN_WIDTH-60, 30)];
    if (self.billStatus==2) {
        self.statusButton.frame=CGRectMake(120, 5, SCREEN_WIDTH-150, 30);
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(30, 5, 80, 30)];
        [button setTitle:@"拒绝" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        button.layer.cornerRadius=5;
        button.layer.borderColor=[UIColor orangeColor].CGColor;
        button.layer.borderWidth=1;
        [button addTarget:self action:@selector(refuse) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    self.statusButton.backgroundColor=[UIColor orangeColor];
    self.statusButton.layer.cornerRadius=5;
    [self.statusButton setTitle:self.orderStatus forState:UIControlStateNormal];
    [self.statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.statusButton.titleLabel.font=[UIFont systemFontOfSize:17];
    [self.statusButton addTarget:self action:@selector(order:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.statusButton];
    return view;
}

-(void)refuse{
    [self scanfInforDic];
}


-(void)scanfInforDic{

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 20;
    welcomeLabelRect.size.height = 20;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"请填写拒绝的理由!";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = CGRectGetMaxY(welcomeLabelRect)+5;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect);
    infoLabelRect.size.height-=40;
    _tx=[[UITextField alloc]initWithFrame:infoLabelRect];
    _tx.font=[UIFont systemFontOfSize:16];
    _tx.layer.borderColor=[[UIColor whiteColor]CGColor];
    _tx.layer.cornerRadius=7;
    _tx.layer.borderWidth=1;
    _tx.placeholder=@"在这里输入内容";
    [_tx setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _tx.backgroundColor=contentView.backgroundColor;
    _tx.textColor=[UIColor whiteColor];
    [contentView addSubview:_tx];
    CGRect txBounce = CGRectInset(contentView.bounds, 5, 5);
    txBounce.origin.y=CGRectGetMaxY(infoLabelRect)+5;
    txBounce.size.height=30;
    UIButton*button=[[UIButton alloc]initWithFrame:txBounce];
    button.backgroundColor=contentView.backgroundColor;
    button.layer.borderColor=[[UIColor whiteColor]CGColor];
    button.layer.borderWidth=1;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(changeDEsscribe) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}


-(void)changeDEsscribe{
    if (_tx.text.length==0) {
       
            self.isNetWorkRefer=YES;
            if (self.block) {
                self.block(self.isNetWorkRefer);
            }
        UIAlertView*alertive=[[UIAlertView alloc]initWithTitle:@"信息提示" message:@"拒绝理由未填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertive show];
    }
    [self flowShow];
    NSString*urlString=[self interfaceFromString:interface_stopWork];
    NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%lu",self.id],@"opinion":_tx.text};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [[KGModal sharedInstance]hideAnimated:YES withCompletionBlock:^{
                [self.view makeToast:@"已终止" duration:1 position:@"center" Finish:^{
                    [self send];
                }];
            }];
            
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];

    }];

}

-(void)order:(UIButton*)button{
    self.isNetWorkRefer=YES;
    if (self.block) {
        self.block(self.isNetWorkRefer);
    }
    if ([button.titleLabel.text isEqualToString:@"确认完工"]==YES) {
        UIAlertView*alertive=[[UIAlertView alloc]initWithTitle:@"操作提示" message:@"是否确定已完工" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertive.tag=80;
        [alertive show];
    }else if ([button.titleLabel.text isEqualToString:@"待评价"]==YES){
        //评价界面操作。。。。。
        recommendStarsViewController*vcv=[[recommendStarsViewController alloc]initWithNibName:@"recommendStarsViewController" bundle:nil];
        vcv.model=self.dataArray[0];
        vcv.skillArray=self.skillArray;
        
        vcv.id=self.id;
        [self pushWinthAnimation:self.navigationController Viewcontroller:vcv];
    }else if ([button.titleLabel.text isEqualToString:@"待付款"]==YES){
        WechatPayViewController*wvc=[[WechatPayViewController alloc]init];
        wvc.orderId=self.id;
        [self pushWinthAnimation:self.navigationController Viewcontroller:wvc];
    }
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self flowShow];
        NSString*urlString=[self interfaceFromString: interface_finish];
        NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%lu",self.id]};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                self.isNetWorkRefer=YES;
                if (self.block) {
                    self.block(self.isNetWorkRefer);
                }
                [self.view makeToast:@"提交成功" duration:1 position:@"center" Finish:^{
                    [self send];
                }];
            }else
            {
                [self.view makeToast:@"当前网络不好，请稍后重试" duration:1 position:@"center"];
            }
            [self flowHide];
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            [self flowHide];
        }];
    }
}


@end
