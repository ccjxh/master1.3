//
//  openCityManagerViewController.m
//  master
//
//  Created by jin on 15/10/12.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "openCityManagerViewController.h"
#import "selelctAreaTableViewCell.h"

@interface openCityManagerViewController ()

@end

@implementation openCityManagerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self customNavigation];
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customNavigation{

    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 50, 20);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];

}

-(void)confirm{
    
    NSString*valueString;
    NSString*urlString=[self interfaceFromString:interface_updateServicerRegion];
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        NSArray*tempArray=self.dataArray[i];
        for (NSInteger j=1; j<tempArray.count; j++) {
            AreaModel*tempModel=tempArray[j];
            if (tempModel.isselect==YES) {
            if (i==0&&j==1) {
                valueString=[NSString stringWithFormat:@"%lu",tempModel.id];
            }else{
                
                valueString=[NSString stringWithFormat:@"%@,%lu",valueString,tempModel.id];
                }
            }
        }
    }
    
    if (valueString==nil) {
        valueString=@"0";
    }
    
    NSDictionary*dict=@{@"regions":valueString};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        [self flowHide];
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self.view makeToast:[dict objectForKey:@"msg"] duration:1.5f position:@"center" Finish:^{
            
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                
                [self popWithnimation:self.navigationController];
            }
        }];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        [self flowHide];
        
        
    }];

    

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataArray.count;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSMutableArray*array=self.dataArray[section];
    return array.count-1;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AreaModel*model=_dataArray[indexPath.section][indexPath.row+1];
    selelctAreaTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"selelctAreaTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.model=model;
    [cell reloadData];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AreaModel*model=_dataArray[indexPath.section][indexPath.row+1];
    if (model.isselect==YES) {
        model.isselect=NO;
    }else{
    
        model.isselect=YES;
    }
    NSMutableArray*array=_dataArray[indexPath.section];
    [array replaceObjectAtIndex:indexPath.row+1 withObject:model];
    [_dataArray replaceObjectAtIndex:indexPath.section withObject:array];
    [self.tableview reloadData];

}


@end
