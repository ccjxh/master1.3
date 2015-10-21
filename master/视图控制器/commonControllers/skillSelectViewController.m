//
//  skillSelectViewController.m
//  master
//
//  Created by jin on 15/5/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "skillSelectViewController.h"

@interface skillSelectViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation skillSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self custonNv];
    self.title=@"技能选择";
    [self initData];
    // Do any additional setup after loading the view from its nib.
}

-(void)custonNv{
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:17];
    [button addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}

-(void)confirm{
    NSMutableArray*Array=[[NSMutableArray alloc]init];
    for (NSInteger i=0; i<_dataArray.count; i++) {
        skillModel*model=_dataArray[i];
        if (model.isOwer==YES) {
            [Array addObject:model];
        }
    }
    
       
    if (self.skillArray) {
        self.skillArray(Array);
        [self popWithnimation:self.navigationController];
    }
}

-(void)initData{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    if (self.type==0) {
    NSMutableArray*Array=[[dataBase share]findAllSkill];
    for (NSInteger i=0; i<Array.count; i++) {
        skillModel*model=Array[i];
        for (NSInteger j=0; j<self.Array.count; j++) {
            skillModel*tempModel=self.Array[j];
            if ([tempModel.name isEqualToString:model.name]==YES) {
                model.isOwer=YES;
            }
        }
        [_dataArray addObject:model];
    }
    if (!_tempArray) {
        _tempArray=[[NSMutableArray alloc]init];
        }
    }else if (self.type==1){
    
        for (NSInteger i=0; i<self.allSkills.count; i++) {
            skillModel*model=self.allSkills[i];
            for (NSInteger j=0; j<self.Array.count; j++) {
                skillModel*tempModel=self.Array[j];
                if ([tempModel.name isEqualToString:model.name]==YES) {
                    model.isOwer=YES;
                }
            }
            [self.dataArray addObject:model];
        }
        if (!self.tempArray) {
            self.tempArray=[[NSMutableArray alloc]init];
        }

    
    }
    [_tableview reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    selelctAreaTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"selelctAreaTableViewCell" owner:nil options:nil]lastObject];
    }
    skillModel*model=_dataArray[indexPath.row];
    cell.type=1;
    cell.Skilmodel=model;
    cell.isShowImage=YES;
    [cell reloadData];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    skillModel*model=_dataArray[indexPath.row];
    if (model.isOwer==YES) {
        model.isOwer=NO;
    }
    else{
        model.isOwer=YES;
    }
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:model];
    [tableView reloadData];

}

@end
