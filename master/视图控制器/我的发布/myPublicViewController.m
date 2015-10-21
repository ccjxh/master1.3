//
//  myPublicViewController.m
//  master
//
//  Created by jin on 15/8/27.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "myPublicViewController.h"
#import "mypublicListView.h"
#import "findWorkDetailViewController.h"
#import "findAddNewWorkViewController.h"
@interface myPublicViewController ()

@end

@implementation myPublicViewController
{
    
    mypublicListView*view;
    NSInteger _currentPage;
    NSInteger _totalPage;
    NSMutableArray*_dataArray;
}

-(void)dealloc{


    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"public" object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self initUI];
    [self CreateFlow];
    [self request];
    [self noData];
    [self netIll];
    [self customRightavigation];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUI) name:@"public" object:nil];
    // Do any additional setup after loading the view.
}


-(void)updateUI{

    self.isRefersh=YES;
    [self request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)initUI{
    
    self.title=@"我的发布";
    _currentPage=1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    view=[[mypublicListView alloc]init];
    __weak typeof(NSMutableArray*)WeArray=_dataArray;
    __weak typeof(self)WeSelf=self;
    __weak typeof(mypublicListView*)WeView=view;
    view.deleBlock=^(NSIndexPath*indexPath){
        
        findWorkListModel*model= WeArray[indexPath.section];
        [WeSelf requestTokenWithPublic:model.id IndexPath:indexPath];
        
    };
    view.RefershBlock=^{
        
        _currentPage=1;
        WeSelf.isRefersh=YES;
        [WeSelf request];
        
    };
    
    view.pullUpBlock=^{
        
        [WeSelf pullUp];
        
    };
    
    self.view=view;
    
}


-(void)pullUp{
    
    if (_currentPage+1<=_totalPage) {
        _currentPage++;
        [self request];
    }else{
        
        [view.refreshFooter endRefreshing];
        [self.view makeToast:@"没有更多了" duration:1 position:@"center"];
    }
    
}

-(void)deletePublic:(NSInteger)ID IndexPath:(NSIndexPath*)indexPath{
    
    NSString*urlString=[self interfaceFromString:interface_delePublic];
    NSDictionary*dict=@{@"token":self.token,@"id":[NSString stringWithFormat:@"%lu",ID]};
    __weak typeof(NSMutableArray*)WeArray=_dataArray;
    __weak typeof(mypublicListView*)WeView=view;
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        [self flowHide];
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [WeArray removeObjectAtIndex:indexPath.section];
            //            [WeView.dataArray removeObjectAtIndex:indexPath.section];
            [WeView.tableview reloadData];
            if (_dataArray.count==0) {
                self.noDataView.hidden=NO;
            }
        }else{
            
            NSString*str=[[dict objectForKey:@"msg"] componentsSeparatedByString:@" "][0];
            [self.view makeToast:[NSString stringWithFormat:@"网络异常%@",str] duration:1 position:@"center"];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        [self flowHide];
        [self.view makeToast:@"网络异常" duration:1 position:@"center"];
        
    }];
    
}

-(void)request{
    
    self.noDataView.hidden=YES;
    self.netIll.hidden=YES;
    [self flowShow];
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    
    NSString*urlString=[self interfaceFromString:interface_myPublicList];
    NSDictionary*dict=@{@"pageNo":[NSString stringWithFormat:@"%lu",_currentPage],@"pageSize":@"10"};
    
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            
            
            [view.weakRefreshHeader endRefreshing];
            [view.refreshFooter endRefreshing];
            if (self.isRefersh==YES) {
                [_dataArray removeAllObjects];
            }
            self.isRefersh=NO;
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
            }else{
                
                self.noDataView.hidden=YES;
            }
            
            __weak typeof(NSMutableArray*)WeArray=_dataArray;
            __weak typeof(self)WeSelf=self;
            __weak typeof(mypublicListView*)WeView=view;
            view.listDidSelect=^(NSIndexPath*indexPath){
                
                findWorkListModel*model=WeArray[indexPath.section];
                findWorkDetailViewController*fvc=[[findWorkDetailViewController alloc]init];
                fvc.title=@"审核详情";
                fvc.removeBlock=^(NSInteger ID){
                    for (NSInteger i=0; i<WeArray.count; i++) {
                        findWorkListModel*model=WeArray[i];
                        if (model.id==ID) {
                            [WeArray  removeObject:model];
                            [WeView.tableview reloadData];
                        }
                    }
                };
                fvc.id=model.id;
                fvc.type=1;
                [WeSelf pushWinthAnimation:WeSelf.navigationController Viewcontroller:fvc];
                
            };

            
        }else{
            NSLog(@"%@",[dict objectForKey:@"msg"]);
            
            
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
        }
        
       
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        [self flowHide];
        [view.weakRefreshHeader endRefreshing];
        [view.refreshFooter endRefreshing];
        [self.view makeToast:@"网络异常" duration:1 position:@"center"];
        self.netIll.hidden=NO;
        
    }];
    
}


-(void)requestTokenWithPublic:(NSInteger)ID IndexPath:(NSIndexPath*)indexPath{
    __weak typeof(self)Weself=self;
    [self flowShow];
    
    NSString*urlString=[self interfaceFromString:interface_token];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        self.token= [[dict objectForKey:@"properties"] objectForKey:@"token"];
        [Weself deletePublic:ID IndexPath:indexPath];
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
        [self.view makeToast:@"网络异常" duration:1 position:@"center"];
    }];
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

@end
