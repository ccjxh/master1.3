//
//  PeoCaseViewController.m
//  master
//
//  Created by xuting on 15/6/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "PeoCaseViewController.h"
#import "projectCastDetailViewController.h"

@interface PeoCaseViewController ()
{
    UITableView*_programeTableview;
//    NSMutableArray *_picArray;
//    NSMutableArray *_currentPage;
}
@end

@implementation PeoCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _currentPage=1;
    [self createTableview];
    __weak typeof(self) weSelf=self;
    self.RefershBlock=^{
        _currentPage=1;
        [weSelf requestProjectCase];
    };
    [self setupFooter:_programeTableview];
    self.isRefersh=YES;
    [self requestProjectCase];
    [self noData];
    [self netIll];
}


#pragma mark-crateTableview
-(void)createTableview
{
    
    _programeTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64-50)] ;
    _programeTableview.delegate=self;
    _programeTableview.dataSource=self;
    _programeTableview.separatorStyle=0;
    _programeTableview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_programeTableview];
    
}



-(void)footerRefresh{

    if (_currentPage+1>_totalPage) {
        [self.refreshFooter endRefreshing];
        [self.view makeToast:@"没有更多数据了" duration:1 position:@"center"];
    }else{
        _currentPage++;
        [self requestProjectCase];
    }

}

#pragma mark-uicollectionviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _picArray.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    starTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"starTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.selectionStyle=0;
    starCaseModel*model=_picArray[indexPath.row];
    cell.model=model;
    [cell reloadData];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    peojectCaseModel*model=_picArray[indexPath.row];
    projectCastDetailViewController*pvc=[[projectCastDetailViewController alloc]initWithNibName:@"projectCastDetailViewController" bundle:nil];
    pvc.id=model.id;
    pvc.model=model;
    pvc.type=1;
    pvc.name=model.caseName;
    pvc.introlduce=model.introduce;
    [self pushWinthAnimation:self.nav Viewcontroller:pvc];
}

#pragma mark - 请求工程案列
-(void)requestProjectCase
{
    
    self.netIll.hidden=YES;
    if (!_picArray) {
        _picArray=[[NSMutableArray alloc]init];
    }
    NSString* urlString=[self interfaceFromString:interface_IDAllProjectCase];
    NSDictionary* valueDict=@{@"userId":[NSString stringWithFormat:@"%lu",(long)self.id],@"pageNo":[NSString stringWithFormat:@"%lu",(long)_currentPage],@"pageSize":@"10"};
    [[httpManager share]POST:urlString parameters:valueDict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        
        [self flowHide];
        NSDictionary *objDic = (NSDictionary *)responseObject;
        if (self.isRefersh==YES) {
            [_picArray removeAllObjects];
        }
        _totalPage=[[objDic objectForKey:@"totalPage"] integerValue];
        NSArray*array=[objDic objectForKey:@"entities"];
        if (array.count==0) {
            self.noDataView.hidden=NO;
            
        }else{
            self.noDataView.hidden=YES;
        }
        for (NSInteger i=0; i<array.count; i++) {
            NSDictionary*dict=array[i];
            peojectCaseModel*model=[[peojectCaseModel alloc]init];
            [model setValuesForKeysWithDictionary:[dict objectForKey:@"masterProjectCase"]];
            [_picArray addObject:model];
        }
        
//                [self.weakRefreshHeader endRefreshing];
                [self.refreshFooter endRefreshing];
        [_programeTableview reloadData];
        //        self.isRefersh=NO;
        //        _recommendRefer=NO;
        //        if (_projectRefersh==NO&&_recommendRefer==NO&&_inforRefersh==NO) {
        //            [self flowHide];
        //        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        self.netIll.hidden=NO;
        //        [self.weakRefreshHeader endRefreshing];
                [self.refreshFooter endRefreshing];
        //        self.isRefersh=NO;
        //        _recommendRefer=NO;
        //
        //        if (_projectRefersh==NO&&_recommendRefer==NO&&_inforRefersh==NO) {
        //            [self flowHide];
        //        }
        [self flowHide];
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

@end
