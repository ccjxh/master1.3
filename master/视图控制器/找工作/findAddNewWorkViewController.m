//
//  findAddNewWorkViewController.m
//  master
//
//  Created by jin on 15/8/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "findAddNewWorkViewController.h"
#import "findAddNewWork.h"
#import "opinionViewController.h"
#import "PayViewController.h"
#import "nameViewController.h"
#import "cityViewController.h"
@interface findAddNewWorkViewController ()

@end

@implementation findAddNewWorkViewController
{
    findAddNewWork*_view;
     NSMutableDictionary*subDict;//提交单据字典
    NSMutableArray*_serviceArray;
    NSMutableArray*colorArray;//字体颜色数组
    NSInteger sendtype;//0为发布  1为保存  2为更新招工
}


-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"workPlace" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestToken];
    [self initData];
    [self initUI];
    [self CreateFlow];
//     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityInfprmatin:) name:@"city" object:nil];  //省市选择通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityInfprmatin:) name:@"workPlace" object:nil];
    // Do any additional setup after loading the view.
}


#pragma mark-通知传值
//通知传值
-(void)cityInfprmatin:(NSNotification*)nc{
    [_serviceArray removeAllObjects];
    NSDictionary*dict=nc.userInfo;
    AreaModel*model=[dict objectForKey:@"model"];
    [subDict setObject:[NSString stringWithFormat:@"%lu",model.id] forKey:@"workSite.id"];
    [_view.firstArrayPlacea replaceObjectAtIndex:3 withObject:model.name];
    [_view.colorArray replaceObjectAtIndex:3 withObject:@"1"];
    [_view.tableview reloadData];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)save{
    
    if ([subDict objectForKey:@"title"]==nil) {
        [self.view makeToast:@"标题不能为空" duration:1 position:@"center"];
        return;
    }
    else if ([subDict objectForKey:@"peopleNumber"]==nil){
        [self.view makeToast:@"人数不能为空" duration:1 position:@"center"];
        return;
    }else if ([subDict objectForKey:@"payType.id"]==nil){
        [self.view makeToast:@"待遇不能为空" duration:1 position:@"center"];
        return;
    }else if ([subDict objectForKey:@"workSite.id"]==nil){
        
        [self.view makeToast:@"工作地点不能为空" duration:1 position:@"center"];
        return;
    }else if ([subDict objectForKey:@"workRequire"]==nil){
        
        [self.view makeToast:@"职位要求不能为空" duration:1 position:@"center"];
        return;
    }else if ([subDict objectForKey:@"contacts"]==nil){
        
        [self.view makeToast:@"联系人不能为空" duration:1 position:@"center"];
        return;
    }

    [self sendSave];
}


-(void)sendSave{

    [self flowShow];
    NSString*urlString=[self interfaceFromString:interface_projectSave];
    [subDict setObject:self.token forKey:@"token"];
    [[httpManager share]POST:urlString parameters:subDict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        if ([[dict objectForKey:@"rspCode"] intValue]==200) {
            [self.view makeToast:@"保存成功" duration:1 position:@"center" Finish:^{

                
            }];
        }else{
        
            NSString*Str=[[dict objectForKey:@"msg"] componentsSeparatedByString:@" "][0];
            [self.view makeToast:Str duration:1 position:@"center"];
        
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        [self flowHide];
        [self.view makeToast:@"网络异常" duration:1 position:@"center"];
    }];


}

-(void)initData{

    if (!subDict) {
        subDict=[[NSMutableDictionary alloc]init];

    }
    
    if (!colorArray) {
        colorArray=[[NSMutableArray alloc]initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0", nil];
    }
}

-(void)initUI{

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title=@"招工信息";
    _view=[[findAddNewWork alloc]initWithFrame:self.view.bounds];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*tempModel=[[dataBase share]findPersonInformation:delegate.id];
    if (tempModel.realName) {
        [subDict setObject:tempModel.realName forKey:@"contacts"];
        [_view.secondArrayPlace replaceObjectAtIndex:0 withObject:tempModel.realName];
    }
    [subDict setObject:tempModel.mobile forKey:@"phone"];
    [_view.secondArrayPlace replaceObjectAtIndex:1 withObject:tempModel.mobile];
   __block  __weak typeof(NSMutableDictionary*)weDict=subDict;
   __block  __weak typeof(self)Weself=self;
   __block __weak typeof(findAddNewWork*)WeView=_view;
   __weak typeof(NSMutableArray*)WeColorArray=colorArray;
    _view.colorArray=colorArray;
    _view.didSelect=^(NSIndexPath*indexPath){
       
        if (indexPath.section==0) {
            switch (indexPath.row) {
                case 0:
                {
                    opinionViewController*ovc=[[opinionViewController alloc]init];
                    ovc.title=@"标题";
                    if ([weDict objectForKey:@"title"]) {
                        ovc.origin=[weDict objectForKey:@"title"];
                    }
                    ovc.limitCount=16;
                    ovc.type=1;
                    
                    ovc.contentBlock=^(NSString*content){
                        
                        [weDict setObject:content forKey:@"title"];
                        [WeView.firstArrayPlacea replaceObjectAtIndex:0 withObject:content];
                        [WeColorArray replaceObjectAtIndex:0 withObject:@"1"];
                        WeView.colorArray=WeColorArray;
                        [WeView.tableview reloadData];
                        
                        
                    };
                    
                    [Weself pushWinthAnimation:Weself.navigationController Viewcontroller:ovc];
                
                }
                    break;
                    case 1:
                {
                
                    opinionViewController*ovc=[[opinionViewController alloc]init];
                    ovc.title=@"人数";
                    if ([weDict objectForKey:@"peopleNumber"]) {
                        ovc.origin=[weDict objectForKey:@"peopleNumber"];
                    }
                    ovc.limitCount=3;
                    ovc.type=2;
                    ovc.contentBlock=^(NSString*content){
                        
                        [weDict setObject:content forKey:@"peopleNumber"];
                        [WeView.firstArrayPlacea replaceObjectAtIndex:1 withObject:content];
                        [WeColorArray replaceObjectAtIndex:1 withObject:@"1"];
                          WeView.colorArray=WeColorArray;
                        [WeView.tableview reloadData];
                        
                    };
                    
                    [Weself pushWinthAnimation:Weself.navigationController Viewcontroller:ovc];
                    
                }
                    break;
                case 2:{
                
                    PayViewController*pvc=[[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
                    pvc.type=1;
                    pvc.valuechange=^(NSString*price,payModel*model){
                        
                        if ([model.name isEqualToString:@"面议"]==YES) {
                            [weDict setObject:@"0" forKey:@"pay"];
                            [weDict setObject:[NSString stringWithFormat:@"%lu",model.id] forKey:@"payType.id"];
                            [WeView.firstArrayPlacea replaceObjectAtIndex:2 withObject:@"面议"];
                             [WeColorArray replaceObjectAtIndex:2 withObject:@"1"];
                              WeView.colorArray=WeColorArray;
                            [WeView.tableview reloadData];
                        }else{
                        
                            [weDict setObject:[NSString stringWithFormat:@"%lu",model.id] forKey:@"payType.id"];
                            [weDict setObject:price forKey:@"pay"];
                            [WeView.firstArrayPlacea replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@%@",price,model.name]];
                            [WeColorArray replaceObjectAtIndex:2 withObject:@"1"];
                              WeView.colorArray=WeColorArray;
                            [WeView.tableview reloadData];
                        }
                        
                    };
                    [Weself pushWinthAnimation:Weself.navigationController Viewcontroller:pvc];
                
                }
                    break;
                case 3:{
//                    provinceViewController*pvc=[[provinceViewController alloc]init];
////                    pvc.array=self.serviceArray;
//                    [WeColorArray replaceObjectAtIndex:3 withObject:@"1"];
//                      WeView.colorArray=WeColorArray;
//                    [Weself pushWinthAnimation:Weself.navigationController Viewcontroller:pvc];
                    
                    cityViewController*cvc=[[cityViewController alloc]initWithNibName:@"cityViewController" bundle:nil];
                    cvc.count=3;
                    if ([weDict objectForKey:@"workSite.id"]) {
                        AreaModel*model=[[dataBase share]findWithCity:WeView.firstArrayPlacea[3]];
                        NSMutableArray*array=[[NSMutableArray alloc]initWithObjects:model, nil];
                        cvc.selectedArray=array;
                    }
                    cvc.TBlock=^(AreaModel*model){
                    
                       [WeColorArray replaceObjectAtIndex:3 withObject:@"1"];
                        [WeView.firstArrayPlacea replaceObjectAtIndex:3 withObject:model.name];
                        [weDict setObject:[NSString stringWithFormat:@"%lu",model.id] forKey:@"workSite.id"];
                        [WeView.tableview reloadData];
                    
                    };
                        [Weself pushWinthAnimation:Weself.navigationController Viewcontroller:cvc];

                
                };
                    break;
                case 4:{
                
                    opinionViewController*ovc=[[opinionViewController alloc]init];
                    ovc.title=@"详细地址";
                    if ([weDict objectForKey:@"address"]) {
                        ovc.origin=[weDict objectForKey:@"address"];
                    }
                    ovc.limitCount=200;
                    ovc.type=1;
                    ovc.contentBlock=^(NSString*content){
                        
                        [weDict setObject:content forKey:@"address"];
                        [WeView.firstArrayPlacea replaceObjectAtIndex:4 withObject:content];
                        [WeView.tableview reloadData];
                    };
                    [WeColorArray replaceObjectAtIndex:4 withObject:@"1"];
                      WeView.colorArray=WeColorArray;
                    [Weself pushWinthAnimation:Weself.navigationController Viewcontroller:ovc];
                    
                };
                    break;
                case 5:{
                    
                    opinionViewController*ovc=[[opinionViewController alloc]init];
                    ovc.title=@"职位要求";
                    if ([weDict objectForKey:@"workRequire"]) {
                        ovc.origin=[weDict objectForKey:@"workRequire"];
                    }
                    ovc.limitCount=800;
                    ovc.type=1;
                    ovc.contentBlock=^(NSString*content){
                        
                        [weDict setObject:content forKey:@"workRequire"];
                        [WeView.firstArrayPlacea replaceObjectAtIndex:5 withObject:content];
                        [WeView.tableview reloadData];
                    };
                    
                    [WeColorArray replaceObjectAtIndex:5 withObject:@"1"];
                      WeView.colorArray=WeColorArray;
                    [Weself pushWinthAnimation:Weself.navigationController Viewcontroller:ovc];
                    
                };
                    break;
                default:
                    break;
            }
        }else if (indexPath.section==1)
        {
        
            if (indexPath.row==0) {
                nameViewController*nvc=[[nameViewController alloc]initWithNibName:@"nameViewController" bundle:nil];
                nvc.type=1;
                AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
              PersonalDetailModel*tempModel=[[dataBase share]findPersonInformation:delegate.id];
                if (tempModel.realName) {
                    [weDict setObject:tempModel.realName forKey:@"contacts"];
                    [WeView.secondArrayPlace replaceObjectAtIndex:0 withObject:tempModel.realName];
                    nvc.origin=tempModel.realName;
                }
                nvc.contentChange=^(NSString*content){
                
                    [weDict setObject:content forKey:@"contacts"];
                    [WeView.secondArrayPlace replaceObjectAtIndex:0 withObject:content];
                    
                    
                    
                    [WeView.tableview reloadData];
                    
                };
                [Weself  pushWinthAnimation:Weself.navigationController Viewcontroller:nvc];
                
            }
            
            if (indexPath.row==1) {
                
                nameViewController*nvc=[[nameViewController alloc]initWithNibName:@"nameViewController" bundle:nil];
                nvc.type=2;
                AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                PersonalDetailModel*tempModel=[[dataBase share]findPersonInformation:delegate.id];
                if (tempModel.realName) {
                    [weDict setObject:tempModel.mobile forKey:@"phone"];
                    [WeView.secondArrayPlace replaceObjectAtIndex:1 withObject:tempModel.mobile];
                    nvc.origin=tempModel.mobile;
                }
                nvc.contentChange=^(NSString*content){
                    
                    [weDict setObject:content forKey:@"phone"];
                    [WeView.secondArrayPlace replaceObjectAtIndex:1 withObject:content];
                    [WeView.tableview reloadData];
                    
                };
                [Weself  pushWinthAnimation:Weself.navigationController Viewcontroller:nvc];
                
            }
        
        }
        
    };
    
    _view.issiueBlok=^{
    
        [Weself issure];
        
    };
    
    [self.view addSubview:_view];
    

}

-(void)issure{
    
    
    if ([subDict objectForKey:@"title"]==nil) {
        [self.view makeToast:@"标题不能为空" duration:1 position:@"center"];
        return;
    }
    else if ([subDict objectForKey:@"peopleNumber"]==nil){
    [self.view makeToast:@"人数不能为空" duration:1 position:@"center"];
        return;
    }else if ([subDict objectForKey:@"payType.id"]==nil){
        [self.view makeToast:@"待遇不能为空" duration:1 position:@"center"];
        return;
    }else if ([subDict objectForKey:@"workSite.id"]==nil){
    
        [self.view makeToast:@"工作地点不能为空" duration:1 position:@"center"];
        return;
    }else if ([subDict objectForKey:@"workRequire"]==nil){
        
        [self.view makeToast:@"职位要求不能为空" duration:1 position:@"center"];
        return;
    }else if ([subDict objectForKey:@"contacts"]==nil){
        
        [self.view makeToast:@"联系人不能为空" duration:1 position:@"center"];
        return;
    }
   
    [self publish];
    
}


-(void)publish{

    [self flowShow];
    NSString*urlString=[self interfaceFromString:interface_isureWork];
    if (self.token) {
        [subDict setObject:self.token forKey:@"token"];
    }
  
    [[httpManager share]POST:urlString parameters:subDict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [self.view makeToast:@"已提交审核" duration:1 position:@"center" Finish:^{
                
                [self popWithnimation:self.navigationController];
            }];
        }else{
            
            
            NSString*str=[[dict objectForKey:@"msg"] componentsSeparatedByString:@""][0];
            
            [self.view makeToast:str duration:1 position:@"center"];
            
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        [self flowHide];
        [self.view makeToast:@"网络异常" duration:1 position:@"center"];
        
    }];


}


-(void)requestToken{
    
    __weak typeof(findAddNewWorkViewController*)WeSelf=self;
    NSString*urlString=[self interfaceFromString:interface_token];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        self.token= [[dict objectForKey:@"properties"] objectForKey:@"token"];
           } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}


@end
