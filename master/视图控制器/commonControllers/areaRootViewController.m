//
//  areaRootViewController.m
//  master
//
//  Created by jin on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "areaRootViewController.h"
#import "selelctAreaTableViewCell.h"
@interface areaRootViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation areaRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self initUI];
    [self CreateFlow];
    [self sendRequest];
   
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendRequest{
    [self initDataWithUrl:self.urlString Dictory:self.dict];
}


-(void)initDataWithUrl:(NSString*)urlString  Dictory:(NSDictionary*)dict {
    [_progressHUD show:YES];
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    [_dataArray removeAllObjects];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
       NSMutableArray*array= [self arrayFromJosn:responseObject Type:@"dataCatalog" Model:@"AreaModel"];
        
         for (NSInteger i=0; i<array.count; i++) {
            AreaModel*model=array[i];
            [_dataArray addObject:model];
        }
       
        [_tableview reloadData];
        [_progressHUD hide:YES];
        [self selectCity];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [_progressHUD hide:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    }];
}


-(void)initUI{
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [self.view addSubview:self.tableview];


}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AreaModel*model=_dataArray[indexPath.row];
    if (self.type!=2) {
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"Cell"];
    }
    AreaModel*model=_dataArray[indexPath.row];
    cell.textLabel.text=model.name;
    return cell;
    }
    selelctAreaTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"selelctAreaTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.model=model;
    [cell reloadData];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

@end
