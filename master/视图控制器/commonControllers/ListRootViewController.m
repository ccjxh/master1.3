//
//  ListRootViewController.m
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "ListRootViewController.h"
#import "DOPDropDownMenu.h"
#import "listRootTableViewCell.h"
#import "customTableViewCell.h"

#define BUTTON_TAG 10
@interface ListRootViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,FeSpinnerTenDotDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)NSMutableArray*townArray;//筛选菜单第一个数组
@property(nonatomic)NSMutableArray*kindArray;//筛选菜单第二个数组
@property(nonatomic)NSMutableArray*skillArray;//筛选菜单第三个数组
@property(nonatomic)DOPDropDownMenu*menue;
@property(nonatomic)NSMutableArray*aptitudeArray;//只能排序数组
@property(nonatomic)NSString*currentCity;   //当前选择市名字
@property(nonatomic)UITableView*selectTableview;//第三组筛选菜单
@property(nonatomic)UITableView*inforTableview;
@property(nonatomic)NSInteger currentTownID;//当前选择城市
@property(nonatomic)NSInteger currentRank;//当前排序方式
@property(nonatomic)BOOL requestRefersh;//是否处于刷新状态
@property(nonatomic)BOOL informationRefersh;
@property(nonatomic)BOOL isOpne;//个人认证是状态
@end

@implementation ListRootViewController
{
    FeSpinnerTenDot *spinner;
    NSArray *arrTitile;
    NSTimer *timer;
    NSInteger index;
    NSInteger _currentPage;
    NSMutableDictionary*_parent;//筛选条件字典
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDict];
    _currentCity=self.cityName;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self seleceMenuDate];
    [self request];
    _currentPage=1;
    self.isRefersh=YES;
    [self initUI];
    [self createTableview];
    [self CreateFlow];
    [self customNavigation];
    [self requestInformation];
    __weak typeof(self) weSelf=self;
    self.RefershBlock=^{
        _currentPage=1;
        [weSelf requestInformation];
    };
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.tableview.separatorStyle=0;
    [self setupFooter:_inforTableview];
    [self setupHeaderWithTableview:_inforTableview];
    [self noData];
    [self net];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)initDict{

    if (!_parent) {
        _parent=[[NSMutableDictionary alloc]init];
    }
     AreaModel*citymodel=[[dataBase share]findWithCity:_currentCity];
    [_parent setObject:[NSString stringWithFormat:@"%ld",(long)citymodel.id] forKey:@"firstLocation"];
    [_parent setObject:[NSString stringWithFormat:@"%ld",(long)self.firstLocation] forKey:@"userPost"];
    [_parent setObject:[NSString stringWithFormat:@"%ld",(long)_currentPage] forKey:@"pageNo"];
    [_parent setObject:@"10" forKey:@"pageSize"];
    [_parent setObject:[NSString stringWithFormat:@"%ld",(long)_currentRank] forKey:@"orderType"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)seleceMenuDate{
    
    if (!_kindArray) {
        _kindArray=[[NSMutableArray alloc]initWithObjects:@"默认排序",@"呼叫最多", nil];
    }
}

-(void)initUI
{
    self.title=@"找师傅";
    _menue=[[DOPDropDownMenu alloc]initWithOrigin:CGPointMake(0,64) andHeight:44];
    _menue.dataSource=self;
    _menue.textColor=COLOR(67, 67, 67, 1);
    _menue.textSelectedColor=COLOR(67, 67, 67, 1);
    _menue.separatorColor=[UIColor blackColor];
    _menue.indicatorColor=[UIColor clearColor];
    _menue.delegate=self;
    __weak typeof(self)weSelf=self;
    __weak typeof(DOPDropDownMenu*)menu=_menue;
    __weak typeof(NSMutableDictionary*)weakDict=_parent;
    _menue.block=^(NSMutableDictionary*dict){
        if (dict.allKeys.count==0) {
            [weakDict removeAllObjects];
            AreaModel*citymodel=[[dataBase share]findWithCity:_currentCity];
            [_parent setObject:[NSString stringWithFormat:@"%ld",(long)citymodel.id] forKey:@"firstLocation"];
            [_parent setObject:[NSString stringWithFormat:@"%ld",(long)self.firstLocation] forKey:@"userPost"];
            [_parent setObject:[NSString stringWithFormat:@"%ld",(long)_currentPage] forKey:@"pageNo"];
            [_parent setObject:@"10" forKey:@"pageSize"];
            [_parent setObject:[NSString stringWithFormat:@"%ld",(long)_currentRank] forKey:@"orderType"];
            
        }else{
        for (NSString*key in dict.allKeys) {
            [weakDict setObject:[dict objectForKey:key] forKey:key];
            }
        }
//        [weSelf selectRefersh:dict];
     
        menu.selectDict=[[NSMutableDictionary alloc]initWithDictionary:dict];
        menu.isOpen=[[dict objectForKey:@"filterCertification"] integerValue];
        self.isRefersh=YES;
        [weSelf requestInformation];
        [menu.leftTableView reloadData];
    };
    
    _menue.areablock=^(NSInteger status){
        _currentTownID=status;
        weSelf.isRefersh=YES;
        self.isRefersh=YES;
        [weSelf requestInformation];
        [menu.leftTableView reloadData];

    };
    _menue.rankblock=^(NSInteger status){
        if (status==1) {
            _currentRank=status;
            _currentRank=2;
        }
        weSelf.isRefersh=YES;
        [weakDict setObject:[NSString stringWithFormat:@"%ld",(long)_currentRank] forKey:@"orderType"];
        [weSelf requestInformation];
        [menu.leftTableView reloadData];

    };
    
    [self.view addSubview:_menue];
    
}


-(void)customNavigation{
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchs) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    
}


-(void)return:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self popWithnimation:self.navigationController];
    
}



-(void)selectRefersh:(NSMutableDictionary*)dict
{
    [self flowShow];
    self.noDataView.hidden=YES;
    self.netIll.hidden=YES;
    NSString*urlString=[self interfaceFromString:interface_list];
    AreaModel*citymodel=[[dataBase share]findWithCity:_currentCity];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)citymodel.id] forKey:@"firstLocation"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)self.firstLocation] forKey:@"userPost"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)_currentPage] forKey:@"pageNo"];
    [dict setObject:@"10" forKey:@"pageSize"];
    
    if (_townArray.count==0) {
        [dict setObject:@"0" forKey:@"secordLocation"];
    }
    else
    {
        AreaModel*tempModel=_townArray[_currentTownID];
        if (tempModel.id==400000) {
            [dict setObject:@"0" forKey:@"secordLocation"];
        }
        else
        {
            
            [dict setObject:[NSString stringWithFormat:@"%ld",(long)tempModel.id] forKey:@"secordLocation"];
        }
    }
    
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)_currentRank] forKey:@"orderType"];
    
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        _totalResults=[dict objectForKey:@"totalResults"];
        NSDictionary*inforDict=[dict objectForKey:@"response"];
        [_dataArray removeAllObjects];
        NSArray*array=[dict objectForKey:@"entities"];
        for (NSInteger i=0; i<array.count; i++) {
            NSDictionary*tempDict=array[i];
            peoplr*model=[[peoplr alloc]init];
            [model setValuesForKeysWithDictionary:[tempDict objectForKey:@"user"]];
            [_dataArray addObject:model];
        }
        
        if (_dataArray.count==0) {
            self.noDataView.hidden=NO;
        }else{
            
            self.noDataView.hidden=YES;
        }
        [_inforTableview reloadData];
        [self referCount];
        [self flowHide];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self flowHide];
        self.netIll.hidden=NO;
    }];
    
}

-(void)searchs
{
    
    //搜索
    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchBar.placeholder=@"请输入要搜索的内容";
    _searchBar.delegate=self;
    _searchBar.returnKeyType=UIReturnKeyDone;
    [_searchBar becomeFirstResponder];
    self.navigationItem.titleView=_searchBar;
    [self closeSearch];
    
}


-(void)closeSearch{
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}


-(void)close{
    
    [_searchBar resignFirstResponder];
    self.navigationItem.titleView=nil;
    [self customNavigation];
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.navigationItem.titleView=nil;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length!=0) {
        [_parent setObject:searchText forKey:@"keyWord"];
  
    }
    _informationRefersh=YES;
    self.noDataView.hidden=YES;
    self.netIll.hidden=YES;
    self.isRefersh=YES;
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    [_dataArray removeAllObjects];
    NSString*urlString=[self interfaceFromString:interface_list];
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    AreaModel*citymodel=[[dataBase share]findWithCity:_currentCity];
//    [dict setObject:[NSString stringWithFormat:@"%ld",(long)citymodel.id] forKey:@"firstLocation"];
//    [dict setObject:[NSString stringWithFormat:@"%ld",(long)self.firstLocation] forKey:@"userPost"];
//    [dict setObject:[NSString stringWithFormat:@"%ld",(long)_currentPage] forKey:@"pageNo"];
//    [dict setObject:@"10" forKey:@"pageSize"];
    
    if (_townArray.count==0) {
//        [dict setObject:@"0" forKey:@"secordLocation"];
         [_parent setObject:@"0" forKey:@"secordLocation"];
    }
    else
    {
        AreaModel*tempModel=_townArray[_currentTownID];
        if (tempModel.id==400000) {
//            [dict setObject:@"0" forKey:@"secordLocation"];
            [_parent setObject:@"0" forKey:@"secordLocation"];
        }
        else
        {
//            [dict setObject:[NSString stringWithFormat:@"%ld",(long)tempModel.id] forKey:@"secordLocation"];
            [_parent setObject:[NSString stringWithFormat:@"%ld",(long)tempModel.id] forKey:@"secordLocation"];
        }
    }
    
    self.isRefersh=YES;
    [self requestInformation];
//    [dict setObject:_searchBar.text forKey:@"keyWord"];
//    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary*dict=(NSDictionary*)responseObject;
//        if (self.isRefersh) {
//            [_dataArray removeAllObjects];
//        }
//        NSDictionary*inforDict=[dict objectForKey:@"response"];
//        NSArray*array=[dict objectForKey:@"entities"];
//         _totalResults=[dict objectForKey:@"totalResults"];
//        for (NSInteger i=0; i<array.count; i++) {
//            NSDictionary*tempDict=array[i];
//            peoplr*model=[[peoplr alloc]init];
//            [model setValuesForKeysWithDictionary:[tempDict objectForKey:@"user"]];
//            [_dataArray addObject:model];
//        }
//        if (_dataArray.count==0) {
//            self.noDataView.hidden=NO;
//        }else{
//            
//            self.noDataView.hidden=YES;
//        }
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [_inforTableview reloadData];
//            [self.weakRefreshHeader endRefreshing];
//            [self.refreshFooter endRefreshing];
//            _informationRefersh=NO;
//            self.isRefersh=NO;
//            if (!_informationRefersh&&!_requestRefersh) {
//                [self flowHide];
//            }
//            
//        });
//        
//        [self referCount];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        _informationRefersh=NO;
//        if (!_informationRefersh&&!_requestRefersh) {
//            [_progressHUD hide:YES];
//        }
//        self.netIll.hidden=NO;
//        [self.weakRefreshHeader endRefreshing];
//        [self.refreshFooter endRefreshing];
//        self.isRefersh=NO;
//    }];
    
}





-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}

-(void)footerRefresh{
    if (_currentPage+1>[self.totalResults integerValue]) {
        [self.refreshFooter endRefreshing];
        [self.view makeToast:@"没有更多了" duration:1 position:@"center"];
        return;
    }
    _currentPage++;
    [self requestInformation];
    [_inforTableview reloadData];
    
}

#pragma mark-网络数据请求
//城市数据请求
-(void)request
{
    
    [self flowShow];
    _requestRefersh=YES;
    if (!_townArray) {
        _townArray=[[NSMutableArray alloc]init];
    }
    [_townArray removeAllObjects];
    AreaModel*initModel=[[AreaModel alloc]init];
    initModel.id=400000;
    initModel.name=@"全市区";
    [_townArray addObject:initModel];
    AreaModel*model=[[dataBase share]findWithCity:_currentCity];
    NSMutableArray*array=[[dataBase share]findWithPid:model.id];
    if (array.count==0) {
        NSString*urlString=[self interfaceFromString:interface_resigionList];
        NSDictionary*dict=@{@"cityId":[NSString stringWithFormat:@"%ld",(long)model.id]};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary*dict=(id)responseObject;
            NSArray*Arrar=[dict objectForKey:@"entities"];
            [[dataBase share]addCityToDataBase:Arrar Pid:model.id];
            NSArray*newArray=[[dataBase share]findWithPid:model.id];
            for (NSInteger i=0; i<newArray.count; i++) {
                AreaModel*tempModel=[[AreaModel alloc]init];
                tempModel=newArray[i];
                [_townArray addObject:tempModel];
            }
            _requestRefersh=NO;
            if (!_requestRefersh&&!_informationRefersh) {
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            _requestRefersh=NO;
            if (!_requestRefersh&&!_informationRefersh) {
                
            }
            
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
        _requestRefersh=NO;
        if (!_requestRefersh&&!_informationRefersh) {
            
        }
    }
    
}

//列表数据请求
-(void)requestInformation
{
    self.netIll.hidden=YES;
    _informationRefersh=YES;
    [self flowShow];
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    NSString*urlString=[self interfaceFromString:interface_list];
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    AreaModel*citymodel=[[dataBase share]findWithCity:_currentCity];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)citymodel.id] forKey:@"firstLocation"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)self.firstLocation] forKey:@"userPost"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)_currentPage] forKey:@"pageNo"];
    [dict setObject:@"10" forKey:@"pageSize"];
    
    //    if (_townArray.count==0) {
    //        [dict setObject:@"0" forKey:@"secordLocation"];
    //    }
    //    else
    //    {
    //         AreaModel*tempModel=_townArray[_currentTownID];
    //        if (tempModel.id==400000) {
    //            [dict setObject:@"0" forKey:@"secordLocation"];
    //        }
    //        else
    //        {
    //
    //        [dict setObject:[NSString stringWithFormat:@"%ld",(long)tempModel.id] forKey:@"secordLocation"];
    //        }
    //    }
    //
    
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)_currentRank] forKey:@"orderType"];
    [[httpManager share]POST:urlString parameters:_parent success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if (self.isRefersh) {
            [_dataArray removeAllObjects];
        }
//        _totalResults=[dict objectForKey:@"totalPage"] ;
        _totalResults=[dict objectForKey:@"totalResults"];
        UILabel*label=(id)[self.view viewWithTag:500];
        NSDictionary*inforDict=[dict objectForKey:@"response"];
        NSArray*array=[dict objectForKey:@"entities"];
        for (NSInteger i=0; i<array.count; i++) {
            NSDictionary*tempDict=array[i];
            peoplr*model=[[peoplr alloc]init];
            [model setValuesForKeysWithDictionary:[tempDict objectForKey:@"user"]];
            [_dataArray addObject:model];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_inforTableview reloadData];
            if (label) {
                label.text=[NSString stringWithFormat:@"共有%d位",[_totalResults intValue]];
            }else{
                
                [self createFooter];
                
            }
            
            [self.weakRefreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            _informationRefersh=NO;
            self.isRefersh=NO;
            [self referCount];
            [self flowHide];
            
        });
        
        if (_dataArray.count==0) {
            self.noDataView.hidden=NO;
        }else{
            self.noDataView.hidden=YES;
            
        }
        //        if (array.count==0) {
        //            [self.view makeToast:@"已没更多数据" duration:1 position:@"center"];
        //        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.netIll.hidden=NO;
        _informationRefersh=NO;
        [_progressHUD hide:YES];
        [self.weakRefreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        self.isRefersh=NO;
        
    }];
    
}

-(void)createTableview
{
    _inforTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT-108)];
    _inforTableview.delegate=self;
    _inforTableview.dataSource=self;
    [self.view addSubview:_inforTableview];
    
}

#pragma mark-选择菜单的delegate
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    
    return 2;
}


- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    //    if (column == 0) {
    //        return _townArray.count;
    //    }else
    if (column == 0){
        return _kindArray.count;
    }else {
        return 4;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    //    if (indexPath.column == 0) {
    //        if (_townArray.count!=0) {
    //            AreaModel*model=_townArray[indexPath.row];
    //            return model.name;
    //        }
    //        else
    //        {
    //            return @"全市区";
    //        }
    //    }else
    if (indexPath.column == 0){
        return _kindArray[indexPath.row];
        
        
    } else {
        return @"筛选";
    }
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    if (column == 0) {
        if (row == 0) {
            return 0;
        } else if (row == 2){
            return 0;
        } else if (row == 3){
            return 0;
        }
    }
    return 0;
}


-(void)createFooter{
    
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 10, 35)];
    label.layer.cornerRadius=3;
    label.layer.borderWidth=1;
    label.layer.borderColor=[UIColor lightGrayColor].CGColor;
    label.text=[NSString stringWithFormat:@"共有%lu位",[_totalResults integerValue]];
    label.font=[UIFont systemFontOfSize:16];
    label.textAlignment=NSTextAlignmentCenter;
    label.tag=500;
    self.inforTableview.tableFooterView=label;
    
}

-(void)referCount{

    UILabel*label=(id)[self.view viewWithTag:500];
    label.text=[NSString stringWithFormat:@"共有%lu位",[_totalResults integerValue]];

}

#pragma mark-tableview 协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    peoplr*model=_dataArray[indexPath.row];
    if ([[model.certification objectForKey:@"personal"] integerValue]==1) {
        listRootTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        if (!cell) {
            cell=[[listRootTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"Cell1"];
        }
        cell.selectionStyle=0;
        cell.typeLabel.text=self.type;
        cell.selectionStyle=0;
        cell.model=model;
        [cell reloadData];
         cell.isShow=YES;
        return cell;
        
    }
    listRootTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[listRootTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"Cell"];
    }
    cell.selectionStyle=0;
    cell.typeLabel.text=self.type;
    cell.selectionStyle=0;
    cell.model=model;
    [cell reloadData];
    cell.isShow=NO;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    peoplr*p=_dataArray[indexPath.row];
    NSArray*array=[p.service objectForKey:@"servicerSkills"];
    if (array.count%4==0) {
        return 80;
    }
    return 80;
}



@end
