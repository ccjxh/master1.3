//
//  myRecommendPeopleViewController.m
//  master
//
//  Created by jin on 15/6/8.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "myRecommendPeopleViewController.h"
#import "listRootTableViewCell.h"
#import "opinionViewController.h"
#import "dealRecommendViewController.h"
#import "PeoDetailViewController.h"
@interface myRecommendPeopleViewController ()
@property(nonatomic)NSInteger currentPage;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)NSMutableArray*recommendStatusArray;//推荐结果数组
@property(nonatomic)NSMutableArray*orderArray;//推荐记录数组
@end

@implementation myRecommendPeopleViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.isRefersh=YES;
    [self initData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage=1;
    self.title=@"我推荐的人";
    self.isRefersh=YES;
    [self initData];
    __weak typeof(self) weSelf=self;
    self.RefershBlock=^{
        _currentPage=1;
        [weSelf initData];
    };
    [self setupFooter:self.tableview];
    [self setupHeaderWithTableview:self.tableview];
    [self CreateFlow];
    [self net];
    [self noData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)initData{
    self.netIll.hidden=YES;
    [self flowShow];
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    if (!_recommendStatusArray) {
        _recommendStatusArray=[[NSMutableArray alloc]init];
    }
    if (!_orderArray) {
        _orderArray=[[NSMutableArray alloc]init];
    }
    NSString*urlString=[self interfaceFromString:interface_myrecommendList];
    NSDictionary*dict=@{@"pageNo":[NSString stringWithFormat:@"%lu",_currentPage],@"pageSize":@"10"};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if (self.isRefersh) {
            [_dataArray removeAllObjects];
            [_recommendStatusArray removeAllObjects];
            [_orderArray removeAllObjects];
        }
        NSArray*Array=[dict objectForKey:@"entities"];
        if (Array.count==0) {
            self.noDataView.hidden=NO;
        }else{
        
            self.noDataView.hidden=YES;

        }
        
         _totlaPage=[[dict objectForKey:@"totalPage"] integerValue];
        
        for (NSInteger i=0; i<Array.count; i++) {
            NSDictionary*inforDic=Array[i];
            NSInteger orderID;
            orderID =[[[inforDic objectForKey:@"requestRecommend"] objectForKey:@"id"] integerValue];
            [_orderArray addObject:[NSString stringWithFormat:@"%lu",orderID]];
            MasterDetailModel*model=[[MasterDetailModel alloc]init];
            [model setValuesForKeysWithDictionary:[[inforDic objectForKey:@"requestRecommend"] objectForKey:@"master"]];
            self.p=[[peoplr alloc]init];
            [self.p setValuesForKeysWithDictionary:[[inforDic objectForKey:@"requestRecommend"] objectForKey:@"master"]];
            _recommentType=[[[inforDic objectForKey:@"requestRecommend"] objectForKey:@"result"] integerValue];
            [_recommendStatusArray addObject:[NSString stringWithFormat:@"%lu",_recommentType]];
            [_dataArray addObject:model];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
            [self.weakRefreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            self.isRefersh=NO;
            [self flowHide];
        });
            } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
                self.netIll.hidden=NO;
            [self flowHide];
            [self.weakRefreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
    }];
}


/*
 _recommentType=[[[inforDic objectForKey:@"requestRecommend"] objectForKey:@"result"] integerValue];
 [_recommendStatusArray addObject:[NSString stringWithFormat:@"%lu",_recommentType]];

*/

-(void)footerRefresh{
    if (_currentPage+1>_totlaPage) {
        [self.refreshFooter endRefreshing];
        [self.view makeToast:@"没有更多数据了" duration:1 position:@"center"];
        return;
    }
    _currentPage++;
    [self initData];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    listRootTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"listRootTableViewCell" owner:nil options:nil]lastObject];
    }
    peoplr*p=_dataArray[indexPath.row];
    cell.type=1;
    cell.model=p;
    NSString*temp;
    peoplr*model=_dataArray[indexPath.row];
    switch (model.userPost) {
        case 1:
        {
            temp=@"雇主";
            
        }
            break;
        case 2:{
            temp=@"师傅";
            
        }
            break;
        case 3:
        {
            temp=@"包工头";
        }
            break;
        case 4:
        {
            
            temp=@"项目经理";
        }
            break;
        default:
            break;
    }
    cell.typeLabel.text=temp;
    cell.selectionStyle=0;
    [cell reloadData];
    cell.dealStatus=[_recommendStatusArray[indexPath.row] integerValue];
        if (cell.dealStatus==0) {
            cell.flag.hidden=NO;
        }else{
    
            cell.flag.hidden=YES;
        }
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MasterDetailModel*p=_dataArray[indexPath.row];
    PeoDetailViewController*pvc=[[PeoDetailViewController alloc]init];
    pvc.id=[p.id integerValue];
    pvc.type=1;
    pvc.model = p;
    NSInteger temp;
    if ([_recommendStatusArray[indexPath.row] integerValue]==0) {
        temp=1;
    }else{
        temp=0;
    }
    pvc.dealResult= temp;
    pvc.userPost = p.userPost;
    pvc.vc=self;
    NSInteger order=[_orderArray[indexPath.row] integerValue];
    pvc.orderID=order;
    [self pushWinthAnimation:self.navigationController Viewcontroller:pvc];
    
}




@end
