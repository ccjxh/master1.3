//
//  thirdResignViewController.m
//  master
//
//  Created by jin on 15/10/16.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "thirdResignViewController.h"
#import "findAddNewWorkViewController.h"
@interface thirdResignViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation thirdResignViewController
{

    NSMutableArray*_dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self request];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)request{

    [self flowShow];
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    NSString*urlString=[self interfaceFromString:interface_resigionList];
    NSDictionary*dict=@{@"cityId":[NSString stringWithFormat:@"%lu",self.model.id]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            NSArray*array=[dict objectForKey:@"entities"];
            for (NSInteger i=0; i<array.count; i++) {
                NSDictionary*inforDict=array[i];
                AreaModel*model=[[AreaModel alloc]init];
                [model setValuesForKeysWithDictionary:[inforDict objectForKey:@"dataCatalog"]];
                [_dataArray addObject:model];
            }
            
            [_tableview reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];

    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return _dataArray.count;

}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!Cell) {
        Cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    
    AreaModel*model=_dataArray[indexPath.row];
    Cell.textLabel.text=model.name;
    Cell.textLabel.font=[UIFont systemFontOfSize:15];
    return Cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    AreaModel*model=_dataArray[indexPath.row];
    NSDictionary*dict=@{@"model":model};
    NSNotification*notication=[[NSNotification alloc]initWithName:@"workPlace" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter]postNotification:notication];
    for (UIViewController*viewcontroller in self.navigationController.viewControllers) {
        if ([viewcontroller isKindOfClass:[findAddNewWorkViewController class]]==YES) {
            
            [self.navigationController popToViewController:viewcontroller animated:YES];
            
            
            
        }
    }
}

@end
