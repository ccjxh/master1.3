//
//  myServiceSelectedViewController.m
//  master
//
//  Created by jin on 15/7/17.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "myServiceSelectedViewController.h"
#import "MyserviceViewController.h"
@interface myServiceSelectedViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)NSMutableArray*dataArray;
@end

@implementation myServiceSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    [_dataArray addObject:@"师傅"];
    [_dataArray addObject:@"工长"];
    [self.tableview reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;

}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!Cell) {
        Cell=[[UITableViewCell alloc]initWithStyle:1  reuseIdentifier:@"Cell"];
    }

    Cell.textLabel.text=_dataArray[indexPath.row];
    Cell.textLabel.font=[UIFont systemFontOfSize:18];
    return Cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyserviceViewController*mvc=[[MyserviceViewController alloc]initWithNibName:@"MyserviceViewController" bundle:nil];
    mvc.type=indexPath.row;
    mvc.title=@"成为宝师傅";
    [self pushWinthAnimation:self.navigationController Viewcontroller:mvc
     ];

}



@end
