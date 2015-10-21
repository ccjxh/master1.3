//
//  MyserviceViewController.m
//  master
//
//  Created by jin on 15/5/21.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "MyserviceViewController.h"
#import "introlduceChangeViewController.h"
#import "workStatusViewController.h"
#import "recommendViewController.h"
#import "TableViewCell.h"
#import "projectCaseAddViewController.h"
#import "PayViewController.h"
#import "projectCastDetailViewController.h"
#import "myServiceSelectedViewController.h"
#import "ChangeDateViewController.h"
#import "certainViewController.h"
#import "cityViewController.h"
#import "provinceViewController.h"
#import "proviceSelectedViewController.h"
#import "timetableviewCell.h"
#import "customOrderTableViewCell.h"
#import "nameViewController.h"
#import "ModifySexViewController.h"
#import "requestModel.h"
@interface MyserviceViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)NSMutableArray*noRecomandDataSource;//未认证的数据源
@property(nonatomic)NSMutableArray*managerDataSource;//项目经理的数据源
@property(nonatomic)NSMutableArray*headDataSource;//工头的数据源
@property(nonatomic)NSMutableArray*currentDataArray;
@property(nonatomic)NSMutableArray*skillArray;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)NSString*startTime; //从业时间
@property(nonatomic)NSString*serviceArea;
@property(nonatomic)NSString* cityString;//城市名字
@property(nonatomic)NSString*townString;//地区名字
@property(nonatomic)NSMutableArray*serviceArray;//服务区域数组
@property(nonatomic)CGFloat YPonit;//上次的高度
@property(nonatomic)CGFloat totleHeight;//服务的label总高度
@property(nonatomic)NSMutableArray*pictureArray;
@property(nonatomic)NSString*introduce;//服务介绍
@property(nonatomic)NSString*workStstus;//工作状态
@property(nonatomic)NSString*expect;//期望薪资
@property(nonatomic)NSMutableArray*recommends;//推荐人数组
@property(nonatomic)NSMutableArray*starProject;//明星工程数组
@property(nonatomic)NSIndexPath*currentIndexPath;//当前选择indexPath
@property(nonatomic)NSString*buttonStatus;//申请按钮状态
@property(nonatomic)NSInteger currentDate;//当前选择的日期
@property(nonatomic)UITextView*tx;
//@property(nonatomic)UIView*backVew;
@end

@implementation MyserviceViewController
{
    UIView *_tagView;   //
    UIDatePicker *_DatePickerView;  //
    UIView *_titleView;
    NSString*date;
    UITableView*_payTableview;//支付tableview
    NSMutableArray*_payArray;//支付数据
    NSMutableArray*_recommendSkillArray;//已认证的技能数组
    UILabel*_reasonLabel;//被拒绝理由展示
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
    [self initData];
    [self request];   //网络请求
  
}

#pragma mark-接收到通知后刷新UI
-(void)receiveNotice{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:@"updateUI" object:nil];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityInfprmatin:) name:@"city" object:nil];  //省市选择通知
    
}


-(void)reloadData{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([[delegate.userInforDic objectForKey:@"certification"] objectForKey:@"skillOpinion"]) {
        _reasonLabel.text=[NSString stringWithFormat:@"被拒绝的原因是:%@",[[delegate.userInforDic objectForKey:@"certification"] objectForKey:@"skillOpinion"]];
    }
    if (_reasonLabel.text==nil) {
        _reasonLabel.hidden=YES;
        self.topHeight.constant=64;
    }else{
        _reasonLabel.hidden=NO;
        self.topHeight.constant=84;
    
    }
    

}

-(void)update{
    
    [self request];   //网络请求
    
    [self initUI];    //UI搭建

}



-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"update" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"city" object:nil];
    
}



- (void)viewDidLoad {
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self customNaigationLeftButton];
    
    [super viewDidLoad];
    
    [self initData];   //设置数据源
    
    [self setupType];  //设置数据源类型
    
    [self initUI];    //UI搭建
    
    [self disPalyReason];//展示被拒绝的原因
    
    [self CreateFlow];   //菊花
    
    [self receiveNotice];

}


-(void)disPalyReason{

    _reasonLabel=[[UILabel alloc]initWithFrame:CGRectMake(13, 64, SCREEN_WIDTH-13, 20)];
    _reasonLabel.textColor=[UIColor blackColor];
    _reasonLabel.font=[UIFont systemFontOfSize:16];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refuse)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [_reasonLabel addGestureRecognizer:tap];
    [self reloadData];
    _reasonLabel.userInteractionEnabled=YES;
    [self.view addSubview:_reasonLabel];

}


-(void)refuse{

    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"拒绝理由" message:_reasonLabel.text delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alert show];
}


-(void)customNaigationLeftButton{

    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(10,10, 40, 25)];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:18];
    [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];

}

-(void)pop{
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];

}



#pragma mark-通知传值
//通知传值
-(void)cityInfprmatin:(NSNotification*)nc{
    [_serviceArray removeAllObjects];
    NSDictionary*dict=nc.userInfo;
    NSMutableArray*Array=[dict objectForKey:@"cityInformation"];
    for (NSInteger i=0; i<Array.count; i++) {
        NSMutableArray*temp=Array[i];
        [_serviceArray addObject:temp];
    }
    NSString*valueString;
    for (NSInteger i=0; i<_serviceArray.count; i++) {
        NSArray*temp=_serviceArray[i];
        for (NSInteger j=1; j<temp.count; j++) {
            AreaModel*model=temp[j];
            if (i==0&&j==1) {
                valueString=[NSString stringWithFormat:@"%lu",model.id];
            }else{
            
                valueString=[NSString stringWithFormat:@"%@,%lu",valueString,model.id];
            }
        }
    }
    
    [self flowShow];
    NSDictionary*inforDict;
    if (!valueString) {
        inforDict=@{@"regions":@"0"};
    }else{
    inforDict=@{@"regions":valueString};
    }
    
     NSString*urlString=[self interfaceFromString:interface_updateServicerRegion];
    [[httpManager share]POST:urlString parameters:inforDict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dcit=(NSDictionary*)responseObject;
        
        
         [self flowHide];
        if ([[dcit objectForKey:@"rspCode"] integerValue]==200) {
            [self.view makeToast:@"服务区域更新成功" duration:1 position:@"center" Finish:^{
                [self request];
            }];
        }else{
        
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
        }
       
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
        [self.view makeToast:@"当前网络不好，请稍后重试" duration:1 position:@"center"];
    }];
    
}


#pragma mark-构建基本UI
-(void)initUI{
    
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableview.backgroundColor=COLOR(228, 228, 228, 1);
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    if (delegate.userPost==2||delegate.userPost==3) {
        self.tableview.tableFooterView=nil;
        return;
    }
      if (model.skill==0&&model.skillState==0) {
         _buttonStatus=@"成为宝师傅";
    }else if (model.skill==0&&model.skillState==1){
        _buttonStatus=@"申请中";
    }
    
    UIView*view=(id)[self.view viewWithTag:600];
    if (view) {
        [view removeFromSuperview];
    }
    if (delegate.userPost==1) {
        view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        view.tag=600;
        if (model.skill==0&&_currentDataArray!=_noRecomandDataSource) {
            UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 40)];
            button.backgroundColor=[UIColor orangeColor];
            [button setTitle:_buttonStatus forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont systemFontOfSize:16];
            button.layer.cornerRadius=3;
            [button addTarget:self action:@selector(appication) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            view.userInteractionEnabled=YES;
            self.tableview.tableFooterView=view;
        }
    }
}


#pragma mark-提交按钮点击
-(void)appication{
    
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];

    if (model.realName==nil) {
        [self.view makeToast:@"请填写完姓名在提交" duration:1.5f position:@"center"];
        return;
    }
    
    if ([[delegate.userInforDic objectForKey:@"age"] integerValue]==0) {
        [self.view makeToast:@"请选择年龄后在提交" duration:1.5f position:@"center"];
        return;

    }
    if (model.gendar==nil) {
        [self.view makeToast:@"请选择性别后在提交" duration:1.5f position:@"center"];
        return;
    }
    
    if (_startTime==nil) {
        [self.view makeToast:@"从业时间不能为空" duration:1 position:@"center"];
        return;
    }
    if (_skillArray.count==0) {
        [self.view makeToast:@"请选择技能后在提交认证" duration:1 position:@"center"];
        return;
    }
    
    if (_skillArray.count==0) {
        [self.view makeToast:@"请选择服务区域后在提交认证" duration:1 position:@"center"];
        return;
    }
    
    if (_expect==nil) {
        [self.view makeToast:@"薪资期望不能为空" duration:1 position:@"center"];
        return;
    }
    
       NSString*urlString;
    NSDictionary*dict;
    if (_currentDataArray==_managerDataSource) {
        urlString=[self interfaceFromString:interface_attestation];
        dict=@{@"skillType":@"1"};
//        if (_starProject.count<3) {
//            [self.view makeToast:@"请先上传至少三张明星工程照片后在提交认证" duration:1 position:@"center"];
//            return;
//        }else{
//        
            [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                NSDictionary*dict=(NSDictionary*)responseObject;
                if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                    [delegate requestInformation];
                    [self.view makeToast:@"已经提交审核" duration:1 position:@"center" Finish:^{
                        [[delegate.userInforDic objectForKey:@"skillState"] setObject:@"1" forKey:@"skillState"];
                        [self setupType];
                        [self initUI];
                        [self request];
                    }];
                }else{
                    [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                }
            } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                 [self.view makeToast:@"当前网络繁忙，请稍后重试" duration:1 position:@"center"];
            }];
//        }
    }else if (_currentDataArray==_headDataSource){
        serviceModel*model=_currentDataArray[0];
//        if (_recommends.count==0) {
//            [self.view makeToast:@"请至少有寻求到一个人的推荐" duration:1 position:@"center"];
//            return;
//        }else{
            urlString=[self interfaceFromString:interface_attestation];
            dict=@{@"skillType":@"2"};
            [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                NSDictionary*dict=(NSDictionary*)responseObject;
                if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                    [[dataBase share]deleInformationWithID:delegate.id];
                    [delegate requestInformation];
                   [self.view makeToast:@"提交成功" duration:1 position:@"center" Finish:^{
                       if (delegate.userPost==2) {
                           _currentDataArray=_managerDataSource;
                       }
                       if (delegate.userPost==3) {
                           _currentDataArray=_headDataSource;
                       }
                   }];
        
                }else{
                    [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                }
                
            } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                [self.view makeToast:@"当前网络繁忙，请稍后重试" duration:1 position:@"center"];
        }];
    }
}

//构建列表数据
-(void)initData{

    if (!_noRecomandDataSource) {
        NSArray*Array=@[@"师傅",@"工长"];
        _noRecomandDataSource=[[NSMutableArray alloc]initWithObjects:Array, nil];
    }
    if (!_managerDataSource) {
        NSArray*array1=@[@""];
        NSArray*Array2=@[@"专业技能"];
        NSArray*array3=@[@"服务区域"];
        NSArray*array4=@[@"证书",@"服务介绍",@"薪资期望"];
        NSArray*array5=@[@"工作状态"];
//        NSArray*array6=@[@""];
        _managerDataSource=[[NSMutableArray alloc]initWithObjects:array1,Array2,array3,array4,array5, nil];
        
    }
    if (!_headDataSource) {
        NSArray*array1=@[@""];
        NSArray*Array2=@[@"专业技能"];
        NSArray*array3=@[@"服务区域"];
        NSArray*array4=@[@"证书",@"服务介绍",@"薪资期望"];
        NSArray*array5=@[@"工作状态"];
//        NSArray*array6=@[@""];
        _headDataSource=[[NSMutableArray alloc]initWithObjects:array1,Array2,array3,array4,array5, nil];
    }
}

//设置刚进来的数据源类型
-(void)setupType{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (delegate.userPost==1) {
//        _currentDataArray=_noRecomandDataSource;
        
        if (self.type==0) {
            _currentDataArray=_managerDataSource;
        }else if (self.type==1){
        
            _currentDataArray=_headDataSource;
        }
        
    }else if (delegate.userPost==2){
    
        _currentDataArray=_managerDataSource;
    }else if (delegate.userPost==3){
    
        _currentDataArray=_headDataSource;
    }
    
}

//请求个人详情
-(void)request{
    
    [self flowShow];
    if (!_recommendSkillArray) {
        _recommendSkillArray=[[NSMutableArray alloc]init];
    }
    [_recommendSkillArray removeAllObjects];
    if (!_payArray) {
        _payArray=[[NSMutableArray alloc]init];
    }
    [_payArray removeAllObjects];
    if (!_serviceArray) {
        _serviceArray=[[NSMutableArray alloc]init];
    }
    [_serviceArray removeAllObjects];
    if (!_skillArray) {
            _skillArray=[[NSMutableArray alloc]init];
        }
    [_skillArray removeAllObjects];
    [_skillArray removeAllObjects];
    if (!_pictureArray) {
            _pictureArray=[[NSMutableArray alloc]init];
        }
    [_pictureArray removeAllObjects];
    [_pictureArray addObject:@""];
    if (!_starProject) {
        _starProject=[[NSMutableArray alloc]init];
    }
    [_starProject removeAllObjects];
    
    if (!_recommends) {
        _recommends=[[NSMutableArray alloc]init];
    }
    [_recommends removeAllObjects];
    
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    [_dataArray removeAllObjects];
    if (!_serviceArray) {
        _serviceArray=[[NSMutableArray alloc]init];
    }
    [_serviceArray removeAllObjects];
    NSString*urlString=[self interfaceFromString:interface_myServicerDetail];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        NSArray*StartTemp=[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"starProjectCase"];
        //明星工程解析
        for (NSInteger i=0; i<StartTemp.count; i++) {
            starCaseModel*starModel=[[starCaseModel alloc]init];
            NSDictionary*inforDict=StartTemp[i];
            [starModel setValuesForKeysWithDictionary:inforDict];
            [_starProject addObject:starModel];
        }
        serviceModel*model=[[serviceModel alloc]init];
        [model setValuesForKeysWithDictionary:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"service"]];
         [_dataArray addObject:model];
        NSArray*recommendArray=[[[dict objectForKey:@"entity"] objectForKey:@"user"]objectForKey:@"recommendInfo"];
        
        for (NSInteger i=0; i<recommendArray.count; i++) {
            NSDictionary*inforDic=recommendArray[i];
            NSArray*tempArray=[inforDic objectForKey:@"skills"];
            for (NSInteger j=0; j<tempArray.count; j++) {
                NSDictionary*skillDict=tempArray[j];
                skillModel*model=[[skillModel alloc]init];
                [model setValuesForKeysWithDictionary:skillDict];
                [_recommendSkillArray addObject:model];
            }
            
        }
        //开始从业时间
        _startTime=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"service"]  objectForKey:@"startWork"];
        NSArray*tempArray=[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"recommendInfo"];
            //推荐人数组
        for (NSInteger j=0; j<tempArray.count; j++) {
            NSDictionary*recommendInforDict=[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"recommendInfo"][j];
            recommendInforModel*recommendModel=[[recommendInforModel alloc]init];
            [recommendModel setValuesForKeysWithDictionary:recommendInforDict];
            [_recommends addObject:recommendModel];
        }
            //工作状态
        _workStstus=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"service"]  objectForKey:@"workStatus"];
            
            //公司区域解析
        _introduce=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"service"]objectForKey:@"serviceDescribe"];
            
            //技能解析
        for (NSInteger i=0; i<model.servicerSkills.count; i++) {
                skillModel*skillmodel=[[skillModel alloc]init];
                [skillmodel setValuesForKeysWithDictionary:model.servicerSkills[i]];
            for (NSInteger j=0; j<_recommendSkillArray.count; j++) {
                if (skillmodel.isSelect==YES) {
                    break;
                }
                skillModel*compareModel=_recommendSkillArray[j];
                if (skillmodel.id==compareModel.id) {
                    skillmodel.isSelect=YES;
                }
            }
                skillmodel.isOwer=YES;
                [_skillArray addObject:skillmodel];
            }
        //期望薪资解析
        payModel*pModel=[[payModel alloc]init];
        [pModel setValuesForKeysWithDictionary:[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"service"] objectForKey:@"payType"]];
        if (!pModel) {
            _expect=@"";
        }else{
            
            if (pModel.name) {
            
        if ([pModel.name isEqualToString:@"面议"]==YES) {
            _expect=pModel.name;
        }else{
        _expect=[NSString stringWithFormat:@"%.2f%@",[[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"service"] objectForKey:@"expectPay"] floatValue],pModel.name];
            }
        }
    }
        
            //服务区域解析
        for (NSInteger i=0; i<model.allServiceRegions.count; i++) {
                NSDictionary*dict1=model.allServiceRegions[i];
               NSString*tempString=dict1.allKeys[0];
                NSArray*array=[tempString componentsSeparatedByString:@"id\":"];
                AreaModel*model=[[AreaModel alloc]init];
                model.id=[[array[1] componentsSeparatedByString:@","][0] integerValue];
                NSArray* cityArray=[tempString componentsSeparatedByString:@"name\":\""];
                model.name=[cityArray[1] componentsSeparatedByString:@"\""][0];
                NSMutableArray*secondArray=[[NSMutableArray alloc]init];
                [secondArray addObject:model];
                NSArray*detailArray=[dict1 objectForKey:tempString];
                for (NSInteger j=0; j<detailArray.count; j++) {
                    AreaModel*citymodel=[[AreaModel alloc]init];
                    citymodel.isselect=YES;
                    [citymodel setValuesForKeysWithDictionary:detailArray[j]];
                    [secondArray addObject:citymodel];
                                                            }
                [_serviceArray addObject:secondArray];
            
            }
        
            NSArray*pictureArray=[[[dict objectForKey:@"entity"] objectForKey:@"user"]objectForKey:@"certificate" ];
                //证书解析
            for (NSInteger i=0; i<pictureArray.count; i++) {
                NSDictionary*tempDict=pictureArray[i];
                certificateModel*tempModel=[[certificateModel alloc]init];
                [tempModel setValuesForKeysWithDictionary:tempDict];
                [_pictureArray addObject:tempModel];
            }
        
         [_tableview reloadData];
        [self flowHide];
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];

   }];
}

#pragma mark-tableview代理相关
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  
    
//    return _currentDataArray.count;
    return 2;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section==0) {
        return 3;
    }
    
    if (section==1) {
        return 8;
    }
    
    
    if (_currentDataArray==_headDataSource) {
        if (section==5) {
            
//            return <#expression#>
//            return _recommends.count;
//            return 3;
        }
    }
    if (_currentDataArray==_managerDataSource) {
//        return _managerDataSource.count;
//        
//        if (section==4) {
//            return _starProject.count;
//        }
    }
    return [_currentDataArray[section] count];

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //包工头进入服务界面
//    if (_currentDataArray==_headDataSource) {
    
     AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if (indexPath.section==0) {
        
        customOrderTableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if (!Cell) {
            Cell=[[[NSBundle mainBundle]loadNibNamed:@"customOrderTableViewCell" owner:nil options:nil]lastObject];
        }
        
       PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
        switch (indexPath.row) {
            case 0:
            {
                Cell.function.text=@"姓名";
                if (model.realName) {
                    Cell.content.text=model.realName;
                }else{
                
                Cell.content.text=@"待完善";
                }
                return Cell;

            }
                break;
            case 2:
            {
            Cell.function.text=@"年龄";
                if ([[delegate.userInforDic objectForKey:@"age"] integerValue]==0) {
                    Cell.content.text=@"待完善";
                }else{
                
                    Cell.content.text=[NSString stringWithFormat:@"%@",[delegate.userInforDic objectForKey:@"age"]];
                }
                
                return Cell;
                
                
            }
                break;
                case 1:
            {
            
                Cell.function.text=@"性别";
                Cell.content.text=model.gendar;
                return Cell;
            }
                break;
            default:
                break;
        }
        
        
    }else{
    
        switch (indexPath.row) {
            case 0:
            {
                customOrderTableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (!Cell) {
                    Cell=[[[NSBundle mainBundle]loadNibNamed:@"customOrderTableViewCell" owner:nil options:nil]lastObject];
                }
                Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                Cell.function.text=@"岗位";
                if ([self.title isEqualToString:@"成为宝师傅"]==YES) {
                    if (self.type==0) {
                        Cell.content.text=@"师傅";
                    }else if (self.type==1){
                    
                    Cell.content.text=@"工长";
                    }
                }else{
                if (delegate.userPost==1) {
                    Cell.content.text=@"雇主";
                }else if (delegate.userPost==2){
                
                Cell.content.text=@"师傅";
                }else if (delegate.userPost==3){
                
                    Cell.content.text=@"工长";
                    }
                }
                return Cell;
                
            }
                break;
                case 1:
            {
            
                return [self getSkillCellWithTableview:tableView SkillArray:_skillArray];
                
            }
                break;
                case 2:
            {
                return [self getStartTimeWithTableview:tableView];
                
            }
                break;
                case 3:
            {
                return [self getServiceCellWithTableview:tableView];
                
            }
                break;
                case 4:
            {
                return [self getexpectWithTableview:tableView];
                
                
            }
                break;
                case 5:
            {
               return  [self getserviceIntrolduceCellWithTableview:tableView];
                
                
            }
                break;
                case 6:
            {
                return [self getWorkStstusWithTableView:tableView];
                
                
            }
                break;
                case 7:
            {
                return [self getCertainCellWithTableview:tableView];
                
                
            }
                break;
                
            default:
                break;
        }
    
    }
    
     return nil;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor=COLOR(228, 228, 228, 1);
    UILabel*label=[[UILabel alloc]initWithFrame:view.bounds];
    NSString*tempString;
//    if (_currentDataArray==_noRecomandDataSource) {
//        tempString=@"选择您的服务类型";
//    }
//    else if (_currentDataArray==_headDataSource){
        NSArray*array=@[@"    基本资料",@"    服务信息",@"  服务区域",@"  证书",@"",@""];
       tempString=array[section];
       label.text=tempString;
    label.font=[UIFont boldSystemFontOfSize:16];
        [view addSubview:label];
    
//        if (section==5) {
//            UIView*view=(id)[self.view viewWithTag:70];
//            if (view) {
//                [view removeFromSuperview];
//            }
//            view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//            view.tag=70;
//            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 210, 30)];
//            label.textColor=[UIColor blackColor];
//            label.font=[UIFont systemFontOfSize:14];
//            if (_recommends.count==3) {
//                label.text=@"推荐人";
//            }else{
//                
//                label.text=[NSString stringWithFormat:@"您还可以找%lu个师傅进行推荐",3-_recommends.count];
//            }
    
//            if (_recommends.count<3) {
//            UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, 15, 60, 25)];
//            [button setTitle:@"寻求推荐" forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            button.titleLabel.font=[UIFont systemFontOfSize:15];
//            button.layer.cornerRadius=7;
//            button.backgroundColor=[UIColor lightGrayColor];
//            [button addTarget:self action:@selector(recommend) forControlEvents:UIControlEventTouchUpInside];
//            [view addSubview:button];
//            }
            
    
            return view;
        
        
//    }
//    else if (_currentDataArray==_managerDataSource){
//        NSArray*array=@[@"",@"服务区域",@"证书",@"",@"明星工程"];
//        tempString=array[section];
//    }
//    if (section==4) {
//        
//        UIView*view=(id)[self.view viewWithTag:70];
//        if (view) {
//            [view removeFromSuperview];
//        }
//        view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//        view.tag=70;
//        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 210, 30)];
//        label.textColor=[UIColor blackColor];
//        label.font=[UIFont systemFontOfSize:14];
//        if (_starProject.count==3) {
//            label.text=@"明星工程";
//        }else{
//            
//            label.text=[NSString stringWithFormat:@"您还可以上传%lu个明星工程",3-_starProject.count];
//        }
//        [view addSubview:label];
//        if (_starProject.count<3) {
//            UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, 15, 60, 25)];
//            [button setTitle:@"上传" forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            button.titleLabel.font=[UIFont systemFontOfSize:15];
//            button.layer.cornerRadius=7;
//            button.backgroundColor=[UIColor lightGrayColor];
//            
//            [button addTarget:self action:@selector(uploadStars) forControlEvents:UIControlEventTouchUpInside];
//            [view addSubview:button];
//        }
//        return view;
//        
//    }
//    label.font=[UIFont systemFontOfSize:13];
//    label.textColor=COLOR(189, 189, 189, 1);
//    [view addSubview:label];
//    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 44;
    }else{
    
        switch (indexPath.row) {
            case 0:
            {
                return 44;
            }
                break;
                case 1:
            {
            
                return  [self accountSkillWithAllSkill:_skillArray];
            }
                break;
                case 2:
            {
            
                return 44;
            }
                break;
                case 3:
            {
            
                return 44;
            }
                break;
                case 4:
            {
                return 44;
            }
                break;
                case 5:
            {
            
                return [self accountIntrolduce];
            }
                break;
                case 6:
            {
            
                return 44;
            }
                break;
                case 7:
            {
                return [self accountPicture];
            }
                break;
            default:
                break;
        }
    
    }
    
    
//    if (_currentDataArray==_headDataSource) {
        if (indexPath.section==1) {
            
            return [self accountSkillWithAllSkill:_skillArray];
            
        }
        if (indexPath.section==2) {
            
            return [self accountservice];
            
        }
        else if (indexPath.section==3){
            if (indexPath.row==0) {
                
                return [self accountPicture];
                
            }else if (indexPath.row==1){
                
                return [self accountIntrolduce];
                
            }
        }
        else if (indexPath.section==5){
            NSString*skillString;
            recommendInforModel*model=_recommends[indexPath.row];
            for (NSInteger i=0; i<model.skills.count; i++) {
                if (i==0) {
                    skillString=[NSString stringWithFormat:@"认可技能:%@",[model.skills[i]  objectForKey:@"name"]];
                }else{
                    
                    skillString=[NSString stringWithFormat:@"%@%@",skillString,[model.skills[i] objectForKey:@"name"]];
                }
            }
            if ([self accountStringHeightFromString:skillString Width:(SCREEN_WIDTH-10-70)]!=0) {
                return [self accountStringHeightFromString:model.content Width:(SCREEN_WIDTH-10-10)]+[self accountStringHeightFromString:skillString Width:(SCREEN_WIDTH-10-70)]+60;
                
            }
            
            return [self accountStringHeightFromString:model.content Width:(SCREEN_WIDTH-10-10)]+[self accountStringHeightFromString:skillString Width:(SCREEN_WIDTH-10-70)]+80;
            
        }
    
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section==0||section==4||section==5) {
//        return 0;
//    }
//    if (_currentDataArray==_managerDataSource) {
//        if (section==4) {
//            return 50;
//        }
//    }
//    if (_currentDataArray==_headDataSource) {
//        if (section==5) {
//            return 50;
//        }
//    }
    
    
    return 30;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    _currentIndexPath=indexPath;
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {
                if (model.personal==1||model.personalState==1) {
                    [self.view makeToast:@"已认证的用户不能修改此项信息" duration:1 position:@"center"];
                    return;
                }
                nameViewController*nvc=[[nameViewController alloc]initWithNibName:@"nameViewController" bundle:nil];
                if (model.realName) {
                    nvc.origin=model.realName;
                }
                nvc.contentChange=^(NSString*name){
                    model.realName=name;
                    [[dataBase share] deleAllCityInformation];
                    [[dataBase share]addInformationWithModel:model];
                    [_tableview reloadData];
                };
                [self pushWinthAnimation:self.navigationController Viewcontroller:nvc];
            
            }
                break;
                case 2:
            {
                if (model.personal==1||model.personalState==1) {
                    [self.view makeToast:@"已认证的用户不能修改此项信息" duration:1 position:@"center"];
                    return;
                }
                ChangeDateViewController*cvc=[[ChangeDateViewController alloc]init];
                cvc.isfuture=YES;
                cvc.isPass=YES;
                if (model.birthday) {
                    cvc.oldDate=model.birthday;
                }
                cvc.blockDateValue=^(NSString*date){
                    [self flowShow];
                    NSString*urlString=[self interfaceFromString:interface_updateBirthday];
                    NSArray*temp=[date componentsSeparatedByString:@"-"];
                    NSString*birthday=[NSString stringWithFormat:@"%@/%@/%@",temp[0],temp[1],temp[2]];
                    NSDictionary*dict=@{@"birthday":birthday};
                    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                        NSDictionary*dict=(NSDictionary*)responseObject;
                        [self flowHide];
                        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                            
                            if ([[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] ) {
                                delegate.integrity=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] integerValue];
                                if ([[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"]) {
                                    delegate.integral= [[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] integerValue];
                                    NSDictionary*parent=@{@"value":[NSString stringWithFormat:@"%lu",delegate.integral]};
                                    NSNotification*noction=[[NSNotification alloc]initWithName:@"showIncreaImage" object:nil userInfo:parent];
                                    [[NSNotificationCenter defaultCenter]postNotification:noction];
                                }
                            }
              NSArray*birthdayArray=[date componentsSeparatedByString:@"-"];
              NSString*second=birthdayArray[1];
              NSString*first=birthdayArray[0];
              NSString*third=birthdayArray[2];
              NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
              [formatter setDateFormat:@"yyyy-mm-dd"];
              NSString*Date=[formatter stringFromDate:[NSDate date]];
              NSArray*currentTimeArray=[Date componentsSeparatedByString:@"-"];
              NSString*currentFirst=currentTimeArray[0];
              NSString*currentSecond=currentTimeArray[1];
              NSDate *date = [NSDate date];
              NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
              NSDateComponents *comps = [[NSDateComponents alloc] init] ;
              NSInteger unitFlags = NSYearCalendarUnit |
              NSMonthCalendarUnit |
              NSDayCalendarUnit |
              NSWeekdayCalendarUnit |
              NSHourCalendarUnit |
              NSMinuteCalendarUnit |
              NSSecondCalendarUnit;
              comps = [calendar components:unitFlags fromDate:date];
              int week = [comps weekday];
              int year=[comps year];
              int month = [comps month];
              int day = [comps day];
              NSString*age;
              if (day>[third intValue]) {
                  age=[NSString stringWithFormat:@"%lu岁",year-[first integerValue]];
                  if (year==[first intValue]) {
                      age=@"0岁";
                  }
              }
                            
              else  if ([currentSecond integerValue]>[second integerValue]){
                  age=[NSString stringWithFormat:@"%lu岁",year-[first integerValue]];
                  if (year==[first intValue]) {
                      age=@"0岁";
                  }
              }else{
                  age=[NSString stringWithFormat:@"%lu岁",year-[first integerValue]+1];
                  if (year==[first intValue]) {
                      age=@"0岁";
                      
                  }
              }
                        [delegate.userInforDic setObject:age forKey:@"age"];
                        [_tableview reloadData];
              [self.view makeToast:@"更新成功" duration:1 position:@"center" Finish:^{
                            }];
                        }else{
                            
                            [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                        }
                        
                    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                        [self flowHide];
                        [self.view makeToast:@"当前网络不好，请稍后重试" duration:1 position:@"center"];
                    }];
                };
                
            [self pushWinthAnimation:self.navigationController Viewcontroller:cvc];
            }
                break;
                case 1:
            {
                if (model.personal==1||model.personalState==1) {
                    [self.view makeToast:@"已认证的用户不能修改此项信息" duration:1 position:@"center"];
                    return;
                }
                if ([[delegate.userInforDic objectForKey:@"personal"] integerValue]==1) {
                    [self.view makeToast:@"已认证的用户不能修改此项信息" duration:1 position:@"center"];
                    return;
                }
                ModifySexViewController *ctl = [[ModifySexViewController alloc] init];
                ctl.gendarValueBlock = ^(long gendarId,long tag){
                    NSString *urlString = [self interfaceFromString:interface_updateGendar];
                    NSDictionary *dict = @{@"gendar":[NSString stringWithFormat:@"%lu",gendarId]};
                    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                        NSDictionary*dict=(NSDictionary*)responseObject;
                        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                            NSString*content;
                            if (gendarId == 0)
                            {
                                content = @"男";
                            }
                            else
                            {
                                content = @"女";
                            }
                            [[dataBase share]updateInformationWithId:delegate.id Attribute:@"gendar" Content:content];
                            [_tableview reloadData];
                        }
                        
                    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                        
                    }];
                   
                };
                
                [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
            }
                break;
                
            default:
                break;
        }
    }else{
    
        switch (indexPath.row) {
            case 1:
            {
                skillSelectViewController*svc=[[skillSelectViewController alloc]init];
                                svc.Array=_skillArray;
                                svc.skillArray=^(NSMutableArray*array){
                                    NSString*valuerString;
                                    for (NSInteger i=0; i<array.count; i++) {
                                        skillModel*model=array[i];
                                        if (i==0) {
                                            valuerString=[NSString stringWithFormat:@"%lu",model.id];
                                        }else{
                                            valuerString=[NSString stringWithFormat:@"%@,%lu",valuerString,model.id];
                                        }
                                    }
                                    [self flowShow];
                                    NSDictionary*dict;
                                    if (valuerString==nil) {
                                        dict=@{@"skill":@"0"};
                                    }else{
                                       dict=@{@"skill":valuerString};
                                    }
                                    NSString*urlString=[self interfaceFromString:interface_updateServicerSkill];
                                    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                                        NSDictionary*dict=(NSDictionary*)responseObject;
                                        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                                            [self flowHide];
                                            [self.view makeToast:@"技能更新成功" duration:1 position:@"center" Finish:^{
                                                [self request];
                                                
                                            }];
                                        }
                                    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                                        [self flowHide];
                                    }];
                                };
                                [self pushWinthAnimation:self.navigationController Viewcontroller:svc];

            }
                break;
               case 2:
            {
            
//                _currentDataArray=_managerDataSource;
                _currentIndexPath=indexPath;
                [self selectedDate];
            }
                break;
                case 3:
            {
//
                proviceSelectedViewController*pvc=[[proviceSelectedViewController alloc]initWithNibName:@"proviceSelectedViewController" bundle:nil];
                pvc.selectArray=_serviceArray;
                [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
                
            }
                break;
                case 4:
            {
             [self setPayType];
                
            }
                break;
                case 5:
            {
                opinionViewController*ovc=[[opinionViewController alloc]initWithNibName:@"opinionViewController" bundle:nil];
                                    ovc.type=0;
                                    ovc.limitCount=800;
                                    ovc.origin=_introduce;
                                    ovc.block=^(BOOL isRefersh){
                                        if (isRefersh) {
                
                
                                        }
                                    };
                                    [self pushWinthAnimation:self.navigationController Viewcontroller:ovc];
                
            }
                break;
                case 6:
            {
            
                _currentIndexPath=indexPath;
                [self setupWorkStatus];
 
            }
                break;
                case 7:
            {
                _currentIndexPath=indexPath;
                   certainViewController*pvc=[[certainViewController alloc]init];
                   NSMutableArray*temp=[[NSMutableArray alloc]init];
                   for (NSInteger i=0; i<_pictureArray.count; i++) {
                       if (i==0) {
                           continue;
                       }
                       certificateModel*model=_pictureArray[i];
                       [temp addObject:model];
                   }
                   pvc.dataArray=temp;
                   [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
                
            }
                break;
            default:
                break;
        }
    
    }
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (_currentDataArray==_noRecomandDataSource) {
//        if (indexPath.row==0) {
//            _currentDataArray=_managerDataSource;
//            [self selectedDate];
//            
//        }
//        else if (indexPath.row==1){
//            _currentDataArray=_headDataSource;
//            [self initUI];
//            [_tableview reloadData];
//        }
//    }
//    else if (_currentDataArray==_headDataSource||_currentDataArray==_managerDataSource){
//        
//        switch (indexPath.section) {
//            case 0:
//            [self selectedDate];
//                break;
//            case 1:{
//                skillSelectViewController*svc=[[skillSelectViewController alloc]init];
//                svc.Array=_skillArray;
//                svc.skillArray=^(NSMutableArray*array){
//                    NSString*valuerString;
//                    for (NSInteger i=0; i<array.count; i++) {
//                        skillModel*model=array[i];
//                        if (i==0) {
//                            valuerString=[NSString stringWithFormat:@"%lu",model.id];
//                        }else{
//                            valuerString=[NSString stringWithFormat:@"%@,%lu",valuerString,model.id];
//                        }
//                    }
//                    [self flowShow];
//                    NSDictionary*dict;
//                    if (valuerString==nil) {
//                        dict=@{@"skill":@"0"};
//                    }else{
//                       dict=@{@"skill":valuerString};
//                    }
//                    NSString*urlString=[self interfaceFromString:interface_updateServicerSkill];
//                    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
//                        NSDictionary*dict=(NSDictionary*)responseObject;
//                        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
//                            [self flowHide];
//                            [self.view makeToast:@"技能更新成功" duration:1 position:@"center" Finish:^{
//                                [self request];
//                                
//                            }];
//                        }
//                    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
//                        [self flowHide];
//                    }];
//                };
//                [self pushWinthAnimation:self.navigationController Viewcontroller:svc];
//            }
//                break;
//            case 2:{
//                
////                cityViewController*cvc=[[cityViewController alloc]initWithNibName:@"cityViewController" bundle:nil];
////                cvc.type=1;
////                cvc.selectedArray=_serviceArray;
////                [self pushWinthAnimation:self.navigationController Viewcontroller:cvc];
////                provinceViewController*pvc=[[provinceViewController alloc]init];
////                pvc.array=_serviceArray;
////                [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
//                proviceSelectedViewController*pvc=[[proviceSelectedViewController alloc]initWithNibName:@"proviceSelectedViewController" bundle:nil];
//                pvc.selectArray=_serviceArray;
//                [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
//                
//            }
//                break;
//            case 3:{
//                
//                if (indexPath.row==0) {
////                    _currentIndexPath=indexPath;
//                    certainViewController*pvc=[[certainViewController alloc]init];
//                    NSMutableArray*temp=[[NSMutableArray alloc]init];
//                    for (NSInteger i=0; i<_pictureArray.count; i++) {
//                        if (i==0) {
//                            continue;
//                        }
//                        certificateModel*model=_pictureArray[i];
//                        [temp addObject:model];
//                    }
//                    pvc.dataArray=temp;
//                    [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
//                    
//                    
//                    //                    [self setUserHeaderIamge];
//                }
//                if (indexPath.row==1) {
//                    opinionViewController*ovc=[[opinionViewController alloc]initWithNibName:@"opinionViewController" bundle:nil];
//                    ovc.type=0;
//                    ovc.limitCount=800;
//                    ovc.origin=_introduce;
//                    ovc.block=^(BOOL isRefersh){
//                        if (isRefersh) {
//                            
//                        
//                        }
//                    };
//                    [self pushWinthAnimation:self.navigationController Viewcontroller:ovc];
//
//                }else if (indexPath.row==2){
//                    
//                    [self setPayType];
//                }
//            }
//                break;
//            case 4:{
//                _currentIndexPath=indexPath;
//                [self setupWorkStatus];
//            }
//                break;
//            
//            default:
//                break;
//        }
//    }
}



-(void)uploadStars{
    projectCaseAddViewController*pvc=[[projectCaseAddViewController alloc]init];
    pvc.caseType=1;
    pvc.refershBlocl=^{
        [self request];
    };
    [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
}


//日期选择
-(void)selectedDate{

    _currentDataArray=_managerDataSource;
    ChangeDateViewController*cvc=[[ChangeDateViewController alloc]init];
    if (_startTime) {
        cvc.oldDate=_startTime;
    }
    if (_currentIndexPath.section==1) {
        if (_currentIndexPath.row==2) {
            
        cvc.isPass=YES;
        cvc.isfuture=YES;
        cvc.isShowMessage=NO;
            
        }else{
        
            cvc.isShowMessage=YES;
        }
    }
    cvc.blockDateValue=^(NSString*date){
       
        NSString*urlString=[self interfaceFromString:interface_updateStartWork];
        [self flowShow];
        NSArray*sepArray=[date componentsSeparatedByString:@"-"];
        NSString*temp=[NSString stringWithFormat:@"%@/%@/%@",sepArray[0],sepArray[1],sepArray[2]];
          NSDictionary*dict=@{@"startWork":temp};
        if (_currentIndexPath.row==6) {
            urlString=[self interfaceFromString:interface_updateStatus];
            dict=@{@"status":@"1",@"freeDate":temp};
        }
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [self flowHide];
                [self.view makeToast:@"更新成功" duration:1 position:@"center" Finish:^{
                    
                    [self request];
                    
                }];
                
            }else{
            
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
            }
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            [self.view makeToast:@"当前网络状况不好，请稍后重试" duration:1   position:@"center"];
            [self flowHide];
            
        }];
        
    };
    [self pushWinthAnimation:self.navigationController Viewcontroller:cvc];

}



//薪资期望点击事件
-(void)setPayType{
    PayViewController*pvc=[[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
    pvc.expectBlock=^{
        
            };
    [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];

}



//改变服务介绍
-(void)setupPop
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
    contentView.tag=112;
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 20;
    welcomeLabelRect.size.height = 20;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"请填写服务介绍(还剩800个字)";
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
    _tx=[[UITextView alloc]initWithFrame:infoLabelRect];
    _tx.font=[UIFont systemFontOfSize:16];
    _tx.layer.borderColor=[[UIColor whiteColor]CGColor];
    _tx.layer.cornerRadius=7;
    _tx.layer.borderWidth=1;
    _tx.delegate=self;
    [_tx setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _tx.backgroundColor=contentView.backgroundColor;
    _tx.textColor=[UIColor whiteColor];
    [contentView addSubview:_tx];
    CGRect txBounce = CGRectInset(contentView.bounds, 5, 5);
    txBounce.origin.y=CGRectGetMaxY(infoLabelRect)+5;
    txBounce.size.height=40;
    UIButton*button=[[UIButton alloc]initWithFrame:txBounce];
    button.backgroundColor=contentView.backgroundColor;
    button.layer.borderColor=[[UIColor whiteColor]CGColor];
    button.layer.borderWidth=1;
    button.layer.cornerRadius=5;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(changeDEsscribe) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];

}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if (textView.text.length>=800) {
        return NO;
    }
    if (textView.text.length < 800){
        
//        UILabel*label=(id)[view viewWithTag:111];
//        label.text=[NSString stringWithFormat:@"请填写服务介绍(还剩%u个字可填写)" ,800-textView.text.length];
        return YES;
    }
    
    return NO;

}


-(void)changeDEsscribe
{
    //改变说明
    
    if (_tx.text.length==0) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"错误提示" message:@"内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    _introduce=_tx.text;
    NSDictionary*dict=@{@"describe":_tx.text};
    [self flowShow];
    NSString*urlString=[self interfaceFromString:interface_updateServiceDescribe];
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [[KGModal sharedInstance]hideAnimated:YES withCompletionBlock:^{
                [self request];
                [self flowHide];
            }];
        }
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
        
    }];

}

//设置工作状态
-(void)setupWorkStatus{

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 70)];
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 20;
    welcomeLabelRect.size.height = 20;
    NSArray*Array=@[@"空闲",@"繁忙"];
    for (NSInteger i=0; i<2; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(25+i*SCREEN_WIDTH/2, 25, 60, 30)];
        button.backgroundColor=contentView.backgroundColor;
        [button setTitle:Array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(setStatus:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=700+i;
        [contentView addSubview:button];
    }
    
    contentView.backgroundColor=[UIColor blackColor];
    [KGModal sharedInstance].modalBackgroundColor=[UIColor blackColor];
    [KGModal sharedInstance].showCloseButton=YES;
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}



-(void)setStatus:(UIButton*)button{
    [[KGModal sharedInstance]hideAnimated:YES];

    if (button.tag==700) {
        NSDictionary*dict;
        dict=@{@"status":@"0"};
        [self flowShow];
        NSString*urlString=[self interfaceFromString:interface_updateStatus];
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
                    NSDictionary*dict=(NSDictionary*)responseObject;
            [[KGModal sharedInstance]hideAnimated:YES];
            [self flowHide];
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center" Finish:^{
                   
                    [self request];
                    [self flowHide];
                }];
               
            }else{
            
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
            }
            
           
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
                       [self flowHide];

        }];
        
    }else if (button.tag==701){
        _currentDate=1;
        [[KGModal sharedInstance] hide];
        [self selectedDate];
    }
}

#pragma mark-cell设置
//技能
    //技能
-(UITableViewCell*)getSkillCellWithTableview:(UITableView*)tableView  SkillArray:(NSMutableArray*)skillArray{
        UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CEll"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"CEll"];
        }
        cell.textLabel.text=@"技能";
        if (skillArray.count==0) {
            cell.detailTextLabel.text=@"点击选择技能";
            cell.detailTextLabel.textColor=[UIColor lightGrayColor];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
            return cell;
        }
    
        UIView*view=(id)[cell.contentView viewWithTag:31];
        if (view) {
            [view removeFromSuperview];
        }
        
        view=[[UIView alloc]initWithFrame:cell.bounds];
        view.tag=31;
        cell.detailTextLabel.text=@"";
        cell.textLabel.textColor=[UIColor blackColor];
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        NSInteger orginX = 0;
        for (NSInteger i=0; i<_skillArray.count; i++) {
            skillModel*model=_skillArray[i];
            NSInteger width=(SCREEN_WIDTH-110-30)/3;
            if (i!=0&&i%3==0) {
                orginX=0;
            }
            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-orginX-30-model.name.length*12-5, 10+i/3*30,model.name.length*12+5, 25)];
            if (i/3!=0) {
                label.frame=CGRectMake(SCREEN_WIDTH-orginX-30-model.name.length*12-5, 10+i/3*30,model.name.length*12+5, 25);
            }
            
            if (label.frame.origin.x<100) {
                CGFloat tempWidth=SCREEN_WIDTH-orginX-30-5;
                label.frame=CGRectMake(100, label.frame.origin.y,tempWidth-100-5, label.frame.size.height);
            }
            orginX+=model.name.length*12+10;
            width=label.frame.origin.x+label.frame.size.width+5;
            label.text=model.name;
            label.tag=12;
            label.font=[UIFont systemFontOfSize:12];
            label.layer.borderWidth=1;
            label.numberOfLines=0;
            label.layer.cornerRadius=4;
            label.textAlignment=NSTextAlignmentCenter;
            label.textColor=[UIColor lightGrayColor];
            label.layer.borderColor=[UIColor lightGrayColor].CGColor;
            label.layer.borderWidth=1;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            label.enabled=YES;
            label.userInteractionEnabled=NO;
            [view addSubview:label];
            [cell.contentView addSubview:view];
        }
    return cell;
}
//服务区域
-(UITableViewCell*)getServiceCellWithTableview:(UITableView*)tableView{
    customOrderTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"customOrderTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.function.text=@"服务区域";
    NSString*Str;
    for (NSInteger i=0; i<_serviceArray.count; i++) {
            NSMutableArray*array=_serviceArray[i];
            for (NSInteger j=1; j<array.count; j++) {
                AreaModel*model=array[j];
                if (i==0||j==1) {
                    Str=model.name;
            
                }else{
                
                    Str=[NSString stringWithFormat:@"%@、%@",Str,model.name];
                   
                }
            }
            
            if (!Str) {
                Str=@"点击选择服务区域";
            }
        }
    cell.content.text=Str;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;

}



/**期望薪资*/
-(UITableViewCell*)getexpectWithTableview:(UITableView*)tableview{
    
    UITableViewCell*cell=[tableview dequeueReusableCellWithIdentifier:@"Cell14"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"Cell14"];
    }
    UIView*view=(id)[self.view viewWithTag:60];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.tag=60;
    UILabel*name=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 30)];
    name.text=@"期望薪资";
    name.textColor=[UIColor blackColor];
    name.font=[UIFont systemFontOfSize:16];
    [view addSubview:name];
    UILabel*content=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-150, 10, 120, 30)];
    content.textColor=[UIColor blackColor];
    content.font=[UIFont systemFontOfSize:16];
    content.text=_expect;
    if ([_expect isEqualToString:@"0.00(null)"]==YES) {
        content.text=@"";
    }
    content.textAlignment=NSTextAlignmentRight;
    [view addSubview:content];
    [cell.contentView addSubview:view];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


-(void)recommend{
    //推荐
    recommendViewController*rvc=[[recommendViewController alloc]init];
    rvc.type=4;
    rvc.block=^(BOOL isnet){
        
        [self request];
    };
    
    [self pushWinthAnimation:self.navigationController Viewcontroller:rvc];
    
}



//服务介绍
-(UITableViewCell*)getserviceIntrolduceCellWithTableview:(UITableView*)tableView{
    
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell2"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"Cell2"];
    }
    UIView*view=(id)[self.view viewWithTag:17];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.tag=17;
    UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 90, 20)];
    nameLabel.text=@"服务介绍";
    nameLabel.font=[UIFont systemFontOfSize:16];
    nameLabel.textColor=[UIColor blackColor];
    [view addSubview:nameLabel];
    [cell.contentView addSubview:view];
    CGFloat height= [self accountStringHeightFromString:_introduce Width:SCREEN_WIDTH-150];
    UILabel*content=[[UILabel alloc]initWithFrame:CGRectMake(120, 10, SCREEN_WIDTH-150, height)];
    content.text=_introduce;
    content.textAlignment=NSTextAlignmentRight;
    content.numberOfLines=0;
    content.textColor=[UIColor blackColor];
    content.font=[UIFont systemFontOfSize:16];
    [view addSubview:content];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



//从业时间
-(UITableViewCell*)getStartTimeWithTableview:(UITableView*)tableView{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"CELL"];
    }
    
    cell.textLabel.text=@"从业时间";
    UILabel*label=(id)[self.view viewWithTag:16];
    if (label) {
        [label removeFromSuperview];
    }
    label=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-150, cell.frame.size.height/2-10, 120, 20)];
    label.font=[UIFont systemFontOfSize:16];
    label.textColor=[UIColor blackColor];
    label.tag=16;
    label.textAlignment=NSTextAlignmentRight;
    label.text=_startTime;
    [cell addSubview:label];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;

}


//证书
-(UITableViewCell*)getCertainCellWithTableview:(UITableView*)tableView{
    
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"Cell1"];
    }
    UIView*view=(id)[self.view viewWithTag:45];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.tag=45;
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(15, cell.frame.size.height/2-10, 100, 20)];
    label.text=@"证书";
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:16];
    [view addSubview:label];
    NSInteger width=(SCREEN_WIDTH-40-100)/4;
    for (NSInteger i=0; i<_pictureArray.count; i++) {
        CGFloat height;
              if (i==0) {
            UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-13 -i%4*(width+5)-width, 10+i/4*(width+5), width, width)];
            [button setImage:[UIImage imageNamed:@"增加图片"] forState:UIControlStateNormal];
            [button addTarget: self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            continue;
        }
        
        certificateModel*model=_pictureArray[i];
        NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,model.resource];
        if (_pictureArray.count%4==0) {
            height=_pictureArray.count/4*40;
        }
        else{
            height=(_pictureArray.count/4+1)*40;
            
        }
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-13 -i%4*(width+5)-width, 10+i/4*(width+5), width, width)];
        imageview.tag=20+i;
        [imageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageview.contentMode =  UIViewContentModeScaleAspectFill;
        imageview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageview.clipsToBounds=YES;
        [imageview sd_setImageWithURL:[NSURL URLWithString:urlString]];
        [view addSubview:imageview];
    }
    view.userInteractionEnabled=YES;
    cell.userInteractionEnabled=YES;
    cell.selectionStyle=0;
    [cell.contentView addSubview:view];
    return cell;
}

-(void)add{
    
    certainViewController*pvc=[[certainViewController alloc]init];
    NSMutableArray*temp=[[NSMutableArray alloc]init];
    for (NSInteger i=0; i<_pictureArray.count; i++) {
        if (i==0) {
            continue;
        }
        certificateModel*model=_pictureArray[i];
        [temp addObject:model];
    }
    pvc.dataArray=temp;
    [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
    

}



- (void)setUserHeaderIamge
{
    UIActionSheet *sheet;
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }else  {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    [sheet showInView:[[UIApplication sharedApplication].delegate window]];
    
}
#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 255) {
        
        UIImagePickerControllerSourceType sourceType;
        // 判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
            
            switch (buttonIndex) {
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                    
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                    
                case 2:
                    // 取消
                    return;
                    break;
            }
            
        }else {
            
            if (buttonIndex == 0) {
                
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                
            }else {
                
                return;
            }
        }
        
        // 跳转到相机或相册
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        //设置拍照后的图片可被编辑
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
//        NSLog(@"image info : %@",info);
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        if ([type isEqualToString:@"public.image"]) {
            UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            CGSize imagesize = image.size;
            UIImage *imageNew = [self imageWithImage:image scaledToSize:imagesize];
             NSData *imageData = UIImageJPEGRepresentation(imageNew, 0.5);
            if (_currentDataArray==_managerDataSource&&_currentIndexPath.section==4) {
                
                [self.tableview reloadData];
            }else{
            //将图片转换成二进制
            NSString*urlString=[self interfaceFromString:interface_certainUpload];
             AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        NSDictionary*dict=@{@"file":@"image",@"moduleType":@"com.bsf.common.domain.user.User",@"category":@"certificate",@"workId":[NSString stringWithFormat:@"%lu",delegate.id]};
                
                [self flowShow];
            [[httpManager share]POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:imageData name:@"file" fileName:[@"imagess" stringByAppendingString:@".jpg"] mimeType:@"image/jpg"];
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary*dict=(NSDictionary*)responseObject;
                
                if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                    [self flowHide];
                    [self.view makeToast:@"上传成功" duration:1 position:@"center" Finish:^{
                       
                        [self request];
                    }];
                }else{
                [self flowHide];
                    [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [self flowHide];
                
                }];
            }
        }
    }];
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


//工作状态
-(UITableViewCell*)getWorkStstusWithTableView:(UITableView*)tableview{
    UITableViewCell*cell=[tableview dequeueReusableCellWithIdentifier:@"Cell3"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"Cell3"];
    }
    UIView*view=(id)[self.view viewWithTag:18];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.tag=18;
    UILabel*name=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 100, 20)];
    name.text=@"日程";
    name.textColor=[UIColor blackColor];
    name.font=[UIFont systemFontOfSize:16];
    [view addSubview:name];
    UILabel*content=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-150, 15, 120, 20)];
    content.text=_workStstus;
    content.textColor=[UIColor blackColor];
    content.textAlignment=NSTextAlignmentRight;
    content.font=[UIFont systemFontOfSize:16];
    [view addSubview:content];
    [cell.contentView addSubview:view];
    return cell;
    
}




#pragma mark-计算cell高度
/**计算证书高度*/
-(CGFloat)accountPicture{
    
    CGFloat height;
     NSInteger width=(SCREEN_WIDTH-140)/4;
    if (_pictureArray.count==0) {
        return 44;
    }
    if (_pictureArray.count%4==0) {
        height=_pictureArray.count/4*width+20;
    }
    else{
        height=(_pictureArray.count/4+1)*width+20;
    }
    return height+10;
    
}
/**计算服务区域高度*/
-(CGFloat)accountservice{

    if (_serviceArray.count==0) {
        return 44;
    }
    _totleHeight=0;
    for (NSInteger i=0; i<_serviceArray.count; i++) {
        NSMutableArray*array=_serviceArray[i];
        for (NSInteger j=0; j<array.count; j++) {
            AreaModel*model=array[j];
            if (j==0) {
                _cityString=[NSString stringWithFormat:@"%@:",model.name];
            }
            else if (j==1) {
                
                _townString=model.name;
                
            }
            else if (j==array.count-1){
                if (i==_serviceArray.count-1) {
                    _townString=[NSString stringWithFormat:@"%@,%@",_townString,model.name];
                }
                else{
                    _townString=[NSString stringWithFormat:@"%@,%@",_townString,model.name];
                }
                
            }
            else{
                _townString=[NSString stringWithFormat:@"%@,%@",_townString,model.name];
            }
            
        }
        
        CGFloat height=[self accountStringHeightFromString:_townString Width:SCREEN_WIDTH-140];
        _totleHeight+=height;
        
    }
    return _totleHeight+20;

}

/**计算服务介绍高度*/
-(CGFloat)accountIntrolduce{

    if (_introduce.length==0) {
        return 50;
    }
    return [self accountStringHeightFromString:_introduce Width:SCREEN_WIDTH-150]+20;
}


@end
