//
//  InfoViewController.m
//  master
//
//  Created by xuting on 15/6/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "InfoViewController.h"
#import "requestModel.h"
#import "peopleDetailTableViewCell.h"
#import "peopleDetail2TableViewCell.h"
#import "peopleDetaileeTableViewCell.h"
#import "peopleDetail4TableViewCell.h"
#import "ReferrerCommentsCell.h"
#import "MasterDetailModel.h" //师傅详情model
#import "recommendInforTableViewCell.h"
#import "recommendInforModel.h"
#import "ReportTableViewCell.h"
#import "recommendViewController.h"
#import "informationDetail.h"



@interface InfoViewController ()
{
    MasterDetailModel *masterDetailModel;
    UIButton *collectBtn;
    UIButton *shareBtn;
    BOOL isCollect; //判断收藏状态
    CGFloat skillHeight; //自适应技能 cell 高度
    CGFloat height; //自适应服务区域和服务介绍 cell 的高度
    CGFloat commentsHeight;  //推荐人评语自适应高度
    UITableView *infoTableVC;
    NSMutableArray *_dataArray;
    CGFloat _YPonit;
    CGFloat _totleHeight;
    informationDetail*inforView;//视图
    personDetailViewModel*vm;
    UITextField*_tx;
    UIView *contentView;
    
}
@end

@implementation InfoViewController


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self  initUI];
    [self requestMasterDetail];
    [self CreateFlow];
}



-(void)initUI{
    
    if (!self.dataType) {
        self.dataType=[[NSMutableArray alloc]init];
    }
    inforView=[[informationDetail alloc]initWithFrame:CGRectMake(0, 64, SCREEN_HEIGHT, SCREEN_HEIGHT)];
    inforView.dataArray=self.dataType;
    __weak typeof(self)weSelf=self;
     __weak typeof(personDetailViewModel*)weVM=vm;
    
    //举报按钮点击事件
    inforView.checkBlock=^{
        [weSelf report];
    };
    
    //点击照片预览
    inforView.imageDisplay=^(NSInteger index,UIImageView*tempImageview,personDetailViewModel*tempModel){
        NSMutableArray*temp=[[NSMutableArray alloc]init];
            for (NSInteger i=0; i<tempModel.certificate.count; i++) {
                certificateModel*model=[[certificateModel alloc]init];
                [model setValuesForKeysWithDictionary:tempModel.certificate[i]];
                NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,model.resource];
                
                [temp addObject:urlString];
            }
        
        [weSelf displayPhotosWithIndex:index Tilte:@"证书" describe:nil ShowViewcontroller:weSelf UrlSarray:temp ImageView:tempImageview];
    
    };
    inforView.headImageBlock=^(NSString*urlString,peopleDetailTableViewCell*cell){
        NSMutableArray*tempArray=[[NSMutableArray alloc]initWithObjects:urlString, nil];
        [weSelf displayPhotosWithIndex:0 Tilte:nil describe:nil ShowViewcontroller:weSelf UrlSarray:tempArray ImageView:cell.master_headImage];
    };
    
    //拨打电话
    inforView.tableDisSelected=^(NSIndexPath*index,personDetailViewModel*tempModel){
        
        __weak typeof(MasterDetailModel*)weakModel=masterDetailModel;
        if (self.dataType.count==3) {
            if (index.section==1&&index.row==1) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tempModel.mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                NSString*urlString=[weSelf interfaceFromString:interface_phonerecommend];
                NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
                [dict setObject: [NSString stringWithFormat:@"%u",delegate.id] forKey:@"fromId"];
                [dict setObject:[NSString stringWithFormat:@"%u",weSelf.id] forKey:@"targetId"];
                [dict setObject:tempModel.mobile forKey:@"targetMobile"];
                if (weakModel.realName) {
                    [dict setObject:masterDetailModel.realName forKey:@"targetRealName"];
                }
                [dict setObject:@"user" forKey:@"callType"];
                [dict setObject:[NSString stringWithFormat:@"%u",delegate.id] forKey:@"workId"];
                NSDate*Date=[NSDate date];
                NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                NSString*tiem=[formatter stringFromDate:Date];
                [dict setObject:tiem forKey:@"created"];
                
                [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                    NSDictionary*dict=(NSDictionary*)responseObject;
                    
                } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                    
                }];
            }
            
        }else if (self.dataType.count==4){
            if (index.section==2&&index.row==1) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tempModel.mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
            
        }
        
    };
    
    self.view=inforView;

}

//举报
-(void)report{

    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 140)];
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 20;
    welcomeLabelRect.size.height = 20;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"举报!";
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



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    UIButton*button=(id)[contentView viewWithTag:40];
    
    if (textField.text.length==0) {
        
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.userInteractionEnabled=NO;
    }else{
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.userInteractionEnabled=YES;
    }
    return YES;

}



-(void)changeDEsscribe:(UIButton*)button{
    
    [[KGModal sharedInstance]hideAnimated:YES];
    if (button.tag==40) {
    //改变说明
    if (_tx.text.length==0) {
        [self.view makeToast:@"内容不能为空" duration:1 position:@"center"];
        return;
    }
    [self flowShow];
    NSDictionary*dict=@{@"problem":_tx.text,@"checkUser.id":[NSNumber numberWithInteger:self.id]};
    
    NSString*urlString=[self interfaceFromString:interface_reportInfo];
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [[KGModal sharedInstance]hideAnimated:YES withCompletionBlock:^{
                
                [self.view makeToast:@"举报成功!" duration:2.0f position:@"center"];
                
            }];
        }else{
        
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        [self flowHide];
        [self.view makeToast:@"网络繁忙,请稍后重试" duration:1 position:@"center"];
        }];
    }else{
    
    
    }


}


#pragma mark - 请求师傅详情
-(void) requestMasterDetail
{
    MBProgressHUD*hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"正在加载";
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    if (!_recommends) {
        _recommends = [[NSMutableArray alloc] init];
    }
    NSString *urlString = [self interfaceFromString:interface_masterDetail];
    NSDictionary *dict = @{@"userId":[NSNumber numberWithInteger:self.id],@"firstLocation":[NSNumber numberWithInteger:self.cityId]};
    
    [[httpManager share] POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        
        [self flowHide];
        NSDictionary *objDic=(NSDictionary *)responseObject;
        NSDictionary *entityDic = objDic[@"entity"];
        NSDictionary *userDic = entityDic[@"user"];
        NSArray *recommendInfoArr = userDic[@"recommendInfo"];
      
        vm=[[personDetailViewModel alloc]init];
        [vm setValuesForKeysWithDictionary:userDic];
        self.dataType=[[NSMutableArray alloc]initWithObjects:@"基本信息",@"证书",@"基本资料", nil];
        if (vm.certificate.count!=0) {
            [self.dataType addObject:@""];
        }
        inforView.model=vm;
        inforView.dataArray=self.dataType;
        [inforView.tableview reloadData];
        [infoTableVC reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.view makeToast:@"当前网络不好，请稍候重试" duration:1 position:@"center"];
        
    }];
    

}







@end
