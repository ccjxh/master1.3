//
//  findAddNewWork.m
//  master
//
//  Created by jin on 15/8/24.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "findAddNewWork.h"
#import "commendTableViewCell.h"

@implementation findAddNewWork


-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        [self initData];
        [self initUI];
    }

    return self;
}

-(void)initData{

    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
       _firstArrayPlacea=[[NSMutableArray alloc]initWithObjects:@"一句话描述您的需求",@"请填写需要的人数",@"请选择待遇的范围",@"请选择工作的地点",@"请填写详细的地址",@"请输入职位的要求",nil];
    _secondArrayPlace=[[NSMutableArray alloc]initWithObjects:@"请填写您的姓名",@"请输入电话号码",nil];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    if (model.realName) {
        [_secondArrayPlace replaceObjectAtIndex:0 withObject:model.realName];
        
    }
    [_secondArrayPlace replaceObjectAtIndex:1 withObject:model.mobile];
    [self.tableview reloadData];
}


-(void)initUI{

    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.tableview.backgroundColor=COLOR(240, 241, 242, 1);
    self.backgroundColor=self.tableview.backgroundColor;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [self addSubview:self.tableview];
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(13, SCREEN_HEIGHT-64+10, SCREEN_WIDTH-26, 44)];
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(issue) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor=COLOR(22, 168, 233, 1);
    button.layer.cornerRadius=3;
    [self addSubview:button];
    
}


//发布
-(void)issue{

    if (self.issiueBlok) {
        self.issiueBlok();
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section==0) {
        return 6;
    }
    
    if (section==1) {
        
        return 2;
    }
    
    return 0;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        CGFloat height=[self accountStringHeightFromString:_firstArrayPlacea[indexPath.row]  Width:110];
        if (height<47) {
            height=47;
        }
        return height;
    }else{
    
        return 47;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 0;
    }
    return 40;


}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NSArray*array=@[@"",@"    发布人信息"];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
    label.text=array[section];
    label.font=[UIFont boldSystemFontOfSize:16];
    label.textColor=COLOR(114, 114, 114, 1);
    label.textColor=[UIColor blackColor];
    return label;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray*firstArray=@[@"标       题",@"人       数",@"待       遇",@"工作地点",@"详细地址",@"职位要求"];
    NSArray*secondArray=@[@"联 系 人",@"联系电话"];
    commendTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"commendTableViewCell" owner:nil options:nil]lastObject];
        cell.name.textColor=COLOR(42, 183, 236, 1);
        cell.content.textAlignment=NSTextAlignmentLeft;
        cell.content.textColor=COLOR(207, 207, 207, 1);
        if ([self.colorArray[indexPath.row] integerValue]==1) {
            
            cell.content.textColor=[UIColor blackColor];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.type=1;
    if (indexPath.section==0) {
        cell.name.text=firstArray[indexPath.row];
        
        cell.content.text=_firstArrayPlacea[indexPath.row];
        cell.contentStr=_firstArrayPlacea[indexPath.row];
        [cell reloadData];
    }else{
        cell.content.textColor=[UIColor blackColor];
        cell.name.text=secondArray[indexPath.row];
        cell.content.text=secondArray[indexPath.row];
        cell.contentStr=_secondArrayPlace[indexPath.row];
        [cell reloadData];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.didSelect) {
        self.didSelect(indexPath);
    }
    
}

@end
