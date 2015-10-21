//
//  PeoServeViewController.m
//  master
//
//  Created by xuting on 15/6/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "PeoServeViewController.h"

@interface PeoServeViewController ()
{
    UITableView*_serviceTableview;

}
@end

@implementation PeoServeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage=1;
    // Do any additional setup after loading the view.
    _serviceTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-104-50) ];
    _serviceTableview.delegate=self;
    _serviceTableview.dataSource=self;
    _serviceTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_serviceTableview];
    __weak typeof(self) weSelf=self;
    self.RefershBlock=^{
        _currentPage=1;
        [weSelf requestAllReconnemd];
    };
    [self setupFooter:_serviceTableview];
    self.isRefersh=YES;
    [self requestAllReconnemd];
    [self CreateFlow];
    [self noData];
    [self net];
    
}


-(void)footerRefresh{

    if (_currentPage+1>_totalPage) {
        [self.refreshFooter endRefreshing];
        [self.view makeToast:@"没有更多数据" duration:1 position:@"center"];
        return;
       
    }else{
    
        _currentPage++;
        [self requestAllReconnemd];
    }

}

#pragma mark - UITableViewDatesource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _recommendArray.count;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        starModel*model=_recommendArray[section];
        if ([model.reply objectForKey:@"createTime"]!=nil) {
            return 2;
        }else{
            
            return 1;
        }
        
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 20;
    
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        if (indexPath.row==0)
        {
            starModel*model=_recommendArray[indexPath.section];
            NSInteger contentHeight=[self accountStringHeightFromString:model.content Width:SCREEN_WIDTH-20-70];
            if (contentHeight<20) {
                contentHeight=25;
            }
            
            NSString*skillString;
            for (NSInteger i=0; i<model.acceptSkill.count; i++) {
                if (i==0) {
                    skillString=[NSString stringWithFormat:@"认可的技能:%@",[model.acceptSkill[i] objectForKey:@"name"]];
                }else{
                    
                    skillString=[NSString stringWithFormat:@"%@、%@",skillString,[model.acceptSkill[i] objectForKey:@"name"]];
                    
                }
            }
            
            CGFloat skillHeight=[self accountStringHeightFromString:skillString Width:SCREEN_WIDTH-85];
            if (skillHeight<20) {
                skillHeight=25;
            }
            
            if (model.picCase.count%4==0) {
                
                return contentHeight+(model.picCase.count/4)*50+70+skillHeight;
                
            }else{
                return contentHeight+(model.picCase.count/4+1)*50+70+skillHeight;
            }
        }
    
    
        if (indexPath.row==1)
        {
            starModel*model=_recommendArray[indexPath.section];
            return [self accountStringHeightFromString:[model.reply objectForKey:@"content"] Width:SCREEN_WIDTH-90];
        }
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.row==0) {
            recommendTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (!cell) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"recommendTableViewCell" owner:nil options:nil]lastObject];
            }
            cell.selectionStyle=0;
            starModel*model=_recommendArray[indexPath.section];
            cell.model=model;
            cell.selectionStyle=0;
            cell.vc=self;
            [cell reloadData];
            return cell;
        }
        else{
            
            replyTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"replyTableViewCell"];
            if (!cell) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"replyTableViewCell" owner:nil options:nil]lastObject];
            }
            cell.selectionStyle=0;
            starModel*model=_recommendArray[indexPath.section];
            cell.selectionStyle=0;
            cell.name.layer.cornerRadius=5;
            cell.name.text=[NSString stringWithFormat:@"%@回复:%@",[model.reply objectForKey:@"user"],[model.reply objectForKey:@"content"]];
            cell.name.backgroundColor=COLOR(228, 228, 228, 1);
            return cell;
        }
}

//师傅的全部评价
-(void)requestAllReconnemd
{
    [self flowShow];
    self.netIll.hidden=YES;
    self.noDataView.hidden=YES;
    if (!_recommendArray) {
        _recommendArray=[[NSMutableArray alloc]init];
    }
    
    NSString*urlString=[self interfaceFromString:interface_allRecomments];
    NSDictionary*dict=@{@"masterId":[NSString stringWithFormat:@"%lu",(long)self.id],@"pageNo":[NSString stringWithFormat:@"%lu",(long)_currentPage],@"pageSize":@"10"};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        
        [self flowHide];
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            _totalPage=[[dict objectForKey:@"totalPage"] integerValue];
            NSArray*array=[dict objectForKey:@"entities"];
            if (array.count==0) {
                self.noDataView.hidden=NO;
            }else{
            
                self.noDataView.hidden=YES;

            }
            for (NSInteger i=0; i<array.count; i++) {
                NSDictionary*inforDict=array[i];
                starModel*model=[[starModel alloc]init];
                [model setValuesForKeysWithDictionary:[inforDict objectForKey:@"orderComment"]];
                [_recommendArray addObject:model];
            }
        }
        [_serviceTableview reloadData];
          [self.refreshFooter endRefreshing];

    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
         [self.refreshFooter endRefreshing];
        self.netIll.hidden=NO;
        
    }];
    
    
}

@end
