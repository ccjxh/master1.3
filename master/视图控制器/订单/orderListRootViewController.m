//
//  orderListRootViewController.m
//  master
//
//  Created by jin on 15/6/2.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "orderListRootViewController.h"

@interface orderListRootViewController ()<UIAlertViewDelegate>

@end

@implementation orderListRootViewController
{
    NSIndexPath*_currentIndexPath;//删除选中的行

}


-(void)sendRequesr{


}

- (void)viewDidLoad {
    _currentPage=1;
    [super viewDidLoad];
    [self receiveNotice];
    self.title=@"单据列表界面";
    __weak typeof(self) weSelf=self;
    self.RefershBlock=^{
        _currentPage=1;
        weSelf.isRefersh=YES;
        [weSelf sendRequesr];
    };
    self.tableview.separatorStyle=0;
    [self setupFooter:self.tableview];
    [self setupHeaderWithTableview:self.tableview];
    [self CreateFlow];
    [self noData];
    [self net];
}



-(void)receiveNotice{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:@"updateUI" object:nil];
    
}

-(void)update{
    [self sendRequesr];
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"update" object:nil];
}





-(void)footerRefresh{
    if (_currentPage+1>_totlaPage) {
        [self.view makeToast:@"亲，没有更多数据了" duration:1 position:@"center"];
         [self.refreshFooter endRefreshing];
    }else{
        _currentPage++;
        [self sendRequesr];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(void)requestWithURL:(NSString*)url{
    self.netIll.hidden=YES;
    [self flowShow];
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    NSDictionary*dict=@{@"pageNo":[NSString stringWithFormat:@"%lu",_currentPage],@"pageSize":@"10"};
    [[httpManager share]POST:url parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            if (self.isRefersh) {
                [_dataArray removeAllObjects];
                                }
            NSArray*array=[dict objectForKey:@"entities"];
            _totlaPage=[[dict objectForKey:@"totalPage"] integerValue];
            _totalCount=[[dict objectForKey:@"totalResults"] integerValue];
            for (NSInteger i=0; i<array.count; i++) {
                NSDictionary*inforDic=array[i];
                billListModel*model=[[billListModel alloc]init];
                [model setValuesForKeysWithDictionary:[inforDic objectForKey:@"masterOrder"]];
                
                if (model.orderStatus==5||model.orderStatus==3||model.orderStatus==4) {
                    model.isDelegate=YES;
                }
                [_dataArray addObject:model];
                }
        }
        if (_dataArray.count==0) {
            self.noDataView.hidden=NO;
        }else{
            
            self.noDataView.hidden=YES;
            
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self flowHide];
            [self.tableview reloadData];
            [self.weakRefreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            self.isRefersh=NO;
        });
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        self.netIll.hidden=NO;
        [self flowHide];
        [self.weakRefreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];

    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return _dataArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    billListTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"billListTableViewCell" owner:nil options:nil] lastObject];
    }
    billListModel*model;
    cell.selectionStyle=0;
    model =_dataArray[indexPath.row];
    cell.type=self.type;
    cell.model=model;
    [cell reloadData];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    billListModel*model=_dataArray[indexPath.row];
    if (model.isDelegate==YES) {
       
        return UITableViewCellEditingStyleDelete;
    }
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
         _currentIndexPath=indexPath;
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"删除提示" message:@"是否删除这条单据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
        
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    billListModel*model=_dataArray[_currentIndexPath.row];
    if (buttonIndex==0) {
        [self flowShow];
        NSString*urlString=[self interfaceFromString:interface_deleBill];
        NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%lu",model.id]};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            [self flowHide];
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                [self.view makeToast:@"删除成功" duration:1 position:@"center" Finish:^{
                    [_dataArray removeObjectAtIndex:_currentIndexPath.row];
                    [self.tableview reloadData];
                }];
                
            }else{
            
                NSArray*Array=@[_currentIndexPath];
                [self.tableview reloadRowsAtIndexPaths:Array withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
            }
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            [self flowHide];
            [self.view makeToast:@"当前网络不好" duration:1 position:@"center"];
            
        }];
    }
    else{
    
        NSArray*Array=@[_currentIndexPath];
        [self.tableview reloadRowsAtIndexPaths:Array withRowAnimation:UITableViewRowAnimationAutomatic];
    }


}

@end
