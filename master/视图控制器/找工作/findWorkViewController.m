//
//  findWorkViewController.m
//  master
//
//  Created by jin on 15/8/21.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "findWorkViewController.h"
#import "worksList.h"
#import "cityViewController.h"
#import "findAddNewWorkViewController.h"
#import "findWorkDetailViewController.h"


@interface findWorkViewController ()

@end

@implementation findWorkViewController
{
    
    worksList*view;
    NSMutableArray*_dataArray;
    NSMutableArray*_townArray;//地区信息数组
    NSMutableArray*secondArray;//筛选菜单第二个数组
    NSMutableArray*thirdArray;//筛选菜单第三个数组
    NSString*_currentCity;//当前选择城市
    NSString*_currentCityName;
    NSInteger _currentPage;
    NSString*keyWord;
    NSInteger filterCertification;//信誉度
    NSInteger firstLocation;//一级区域id
    NSInteger secordLocation;//二级区域id
    NSInteger payType;//待遇
    NSMutableArray * keyArray;
    NSMutableArray * objectArray;
    NSInteger _totalPage;//总共有多少条数据
    NSMutableDictionary*subDict;//提交请求的字典
    
}


-(instancetype)init{

    
    
    
    return self;

}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"public" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"placeChange" object:nil];

}


-(void)viewWillAppear:(BOOL)animated{


    [super viewWillAppear:animated];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage=1;
    _currentCityName=@"深圳市";
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self initData];
    [self initUI];
    [self noData];
    [self net];
    [self customLeftNavigation];
    [self customRightavigation];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUI:) name:@"public" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData:) name:@"placeChange" object:nil];
    // Do any additional setup after loading the view.
}

-(void)updateUI:(NSNotification*)nc{

    self.isRefersh=YES;
    [self requestListInformation];

}


-(void)reloadData:(NSNotification*)nc{
    
    NSDictionary*dict=nc.userInfo;
    AreaModel*model=[dict objectForKey:@"model"];
    _currentCityName=model.name;
    [self customLeftNavigation];
    self.isRefersh=YES;
    [self requestListInformation];

}

-(void)customLeftNavigation{
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, self.navigationController.navigationBar.frame.size.height)];
    button.tag=10;
    [button addTarget:self action:@selector(changecity) forControlEvents:UIControlEventTouchUpInside];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 9, 60, 30)];
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:16];
    label.text=_currentCityName;
    if (_currentCityName.length*16<=60) {
        label.frame=CGRectMake(0, 9, _currentCityName.length*16, 30);
    }
    UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+5, 21, 13, 8)];
    imageview.image=ImageNamed(@"ARROW");
    imageview.tag=11;
    [button addSubview:imageview];
    [button addSubview:label];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}



-(void)changecity
{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    cityViewController*cvc=[[cityViewController alloc]init];
    cvc.hidesBottomBarWhenPushed=YES;
    if (delegate.city) {
        
        cvc.city=delegate.city;
        
    }
  
    [self pushWinthAnimation:self.navigationController Viewcontroller:cvc];
    
}


-(void)customRightavigation{
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 71, 28)];
    [button setTitle:@"发布招工" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    button.layer.borderColor=COLOR(99, 206, 243, 1).CGColor;
    button.layer.borderWidth=1;
    button.layer.cornerRadius=5;
    [button addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}


//发布工作
-(void)add{
    
    findAddNewWorkViewController*fvc=[[findAddNewWorkViewController alloc]init];
    fvc.hidesBottomBarWhenPushed=YES;
    [self pushWinthAnimation:self.navigationController Viewcontroller:fvc];
    
}


-(void)initUI{
    
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    __weak typeof(self)WeSelf=self;
    __weak typeof(NSMutableArray*)tempArray=_dataArray;
    
    view=[[[NSBundle mainBundle]loadNibNamed:@"worksList" owner:nil options:nil]lastObject];
    view.tableDidSelected=^(UITableView*tableview,NSIndexPath*indexPath){
        findWorkListModel*model=tempArray[indexPath.section];
        findWorkDetailViewController*fvc=[[findWorkDetailViewController alloc]init];
        fvc.id=model.id;
        fvc.hidesBottomBarWhenPushed=YES;
        [WeSelf pushWinthAnimation:WeSelf.navigationController Viewcontroller:fvc];
        
    };
    view.menueDidSelect=^(DOPIndexPath*indexpath){
        
        [WeSelf menueDidSelect:indexpath];
    };
    
   
    view.secondArray=secondArray;
    view.thirdArray=thirdArray;
    __weak typeof(NSMutableDictionary*)WeDict=subDict;
    view.personBlock=^(BOOL isShow){
        if (isShow==YES) {
            [WeDict setObject:@"1" forKey:@"filterCertification"];
        }else{
            
            [WeDict setObject:@"0" forKey:@"filterCertification"];
        }
        WeSelf.isRefersh=YES;
        [WeSelf requestListInformation];
    };
    view.RefershBlock=^{
        
        _currentPage=1;
        WeSelf.isRefersh=YES;
        [WeSelf requestListInformation];
        
    };
    view.pullUpBlock=^{
        
        [WeSelf pullUp];
        
    };
    self.view=view;
    [self CreateFlow];
    NSMutableArray*temp=[self request];
    view.firstArray=temp;
    
}

-(void)pullUp{
    
    if (_currentPage+1<=_totalPage) {
        _currentPage++;
        [self requestListInformation];
    }else{
        
        [view.refreshFooter endRefreshing];
        [self.view makeToast:@"没有更多数据了" duration:1 position:@"center"];
    }
}



//筛选菜单被点击响应
-(void)menueDidSelect:(DOPIndexPath*)indexpath{
    
    switch (indexpath.column) {
        case 0:
        {
            if (indexpath.row==0) {
                [subDict removeObjectForKey:@"secordLocation"];
            }else{
                
                AreaModel*model=_townArray[indexpath.row];
                [subDict setObject:[NSString stringWithFormat:@"%lu",model.id] forKey:@"secordLocation"];
            }
            self.isRefersh=YES;
            [self requestListInformation];
            
        }
            break;
        case 1:{
            
            [secondArray removeAllObjects];
            NSMutableArray*temp=[[dataBase share]findAllPay];
            for (NSInteger i=0; i<temp.count; i++) {
                payModel*model=temp[i];
                [secondArray addObject:model];
            }
            
            if (indexpath.row==0) {
                [subDict removeObjectForKey:@"payType"];
            }else{
                payModel*model=secondArray[indexpath.row-1];
                [subDict setObject:[NSString stringWithFormat:@"%lu",model.id] forKey:@"payType"];
            }
            
            self.isRefersh=YES;
            [self requestListInformation];
        };
            break;
            
        default:
            break;
    }
    
}


-(void)initData{
    
    if (!secondArray) {
        secondArray=[[NSMutableArray alloc]init];
    }
    
    
    if (!thirdArray) {
        thirdArray=[[NSMutableArray alloc]initWithObjects:@"信誉", nil];
    }
    
    if (!keyArray) {
        keyArray=[[NSMutableArray alloc]init];
    }
    
    if (!subDict) {
        subDict = [[NSMutableDictionary alloc]init];
    }
    
    AreaModel*model= [[dataBase share]findWithCity:_currentCityName];
    [subDict setObject:[NSString stringWithFormat:@"%lu",_currentPage] forKey:@"pageNo"];
    [subDict setObject:@"10" forKey:@"pageSize"];
    [subDict setObject:[NSString stringWithFormat:@"%lu",model.id] forKey:@"firstLocation"];
    
}


//城市数据请求
-(NSMutableArray*)request
{
    
    if (!_townArray) {
        _townArray=[[NSMutableArray alloc]init];
    }
    [_townArray removeAllObjects];
    AreaModel*initModel=[[AreaModel alloc]init];
    initModel.id=400000;
    initModel.name=@"全市区";
    [_townArray addObject:initModel];
    AreaModel*model=[[dataBase share]findWithCity:_currentCityName];
    if (model) {
    NSMutableArray*array=[[dataBase share]findWithPid:model.id];
    if (array.count==0) {
        NSString*urlString=[self interfaceFromString:interface_resigionList];
        NSDictionary*dict=@{@"cityId":[NSString stringWithFormat:@"%ld",(long)model.id]};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary*dict=(id)responseObject;
            NSArray*Arrar=[dict objectForKey:@"entities"];
            [self flowHide];
            [[dataBase share]addCityToDataBase:Arrar Pid:model.id];
            NSArray*newArray=[[dataBase share]findWithPid:model.id];
            for (NSInteger i=0; i<newArray.count; i++) {
                AreaModel*tempModel=[[AreaModel alloc]init];
                tempModel=newArray[i];
                [_townArray addObject:tempModel];
            }
            view.firstArray=_townArray;
            [view.menue.leftTableView reloadData];
            self.isRefersh=YES;
            [self requestListInformation];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           
        }];
    }
    else
    {
        NSArray*newArray=[[dataBase share]findWithPid:model.id];
        for (NSInteger i=0; i<newArray.count; i++) {
            AreaModel*tempModel=[[AreaModel alloc]init];
            tempModel=newArray[i];
            [_townArray addObject:tempModel];
        }
        view.firstArray=_townArray;
        [view.menue.leftTableView reloadData];
        self.isRefersh=YES;
        [self requestListInformation];
        }
    }
    return _townArray;
    
}


//列表网络数据请求
-(void)requestListInformation{
    
    self.noDataView.hidden=YES;
    self.netIll.hidden=YES;
    [self flowShow];
    if (self.isRefersh==YES) {
        
        [_dataArray removeAllObjects];
       
    }
    self.isRefersh=NO;
    AreaModel*cityModel=[[dataBase share]findWithCity:_currentCityName];
    if (cityModel) {
    [subDict setObject:[NSString stringWithFormat:@"%lu",cityModel.id] forKey:@"firstLocation"];
    }
    [subDict setObject:[NSString stringWithFormat:@"%lu",_currentPage] forKey:@"pageNo"];
    NSString*urlString=[self interfaceFromString:interface_findWorkList];
    [[httpManager share]POST:urlString parameters:subDict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            _totalPage=[[dict objectForKey:@"totalPage"] integerValue];
            NSArray*array=[dict objectForKey:@"entities"] ;
            for (NSInteger i=0; i<array.count; i++) {
                findWorkListModel*model=[[findWorkListModel alloc]init];
                NSDictionary*inforDict=array[i];
                [model setValuesForKeysWithDictionary:[inforDict objectForKey:@"project"]];
                [_dataArray addObject:model];
            }
            
            view.dataArray=_dataArray;
            [view.tableview reloadData];
            if (_dataArray.count==0) {
                self.noDataView.hidden=NO;
                view.tableview.separatorStyle=0;
            }else{
                view.tableview.separatorStyle=1;
                self.noDataView.hidden=YES;
            }
            
        }else{
            
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
        }
        
        [view.weakRefreshHeader endRefreshing];
        [view.refreshFooter endRefreshing];
        [self flowHide];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [view.weakRefreshHeader endRefreshing];
        [view.refreshFooter endRefreshing];
        [self flowHide];
        [self.view makeToast:@"网络异常" duration:1 position:@"center"];
        self.netIll.hidden=NO;
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
