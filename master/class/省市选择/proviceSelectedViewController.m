//
//  proviceSelectedViewController.m
//  master
//
//  Created by jin on 15/9/22.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "proviceSelectedViewController.h"
#import "selectedCityinforView.h"
#import "firstAreaViewController.h"
#import "openCityManagerViewController.h"
#import "selelctAreaTableViewCell.h"
#define BUTTON_TAG 200
@interface proviceSelectedViewController ()<UIActionSheetDelegate>

@end

@implementation proviceSelectedViewController
{
    
    NSMutableArray*_dataArray;
    BOOL _isShow;  //是否删除状态

}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self reloadData];
    [_tableview reloadData];

}


-(void)reloadData{

    UIButton*button=(id)[self.view viewWithTag:BUTTON_TAG];
    if (button) {
        if (self.selectArray.count==0) {
            button.hidden=NO;
            self.tableview.separatorStyle=0;
        }else{
            self.tableview.separatorStyle=1;
            button.hidden=YES;
        }
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    for (NSInteger i=0; i<self.selectArray.count; i++) {
        NSMutableArray*array=self.selectArray[i];
        for (NSInteger j=0; j<array.count; j++) {
            AreaModel*model=array[j];
            model.isselect=NO;
            [array replaceObjectAtIndex:j withObject:model];
        }
        
        [self.selectArray replaceObjectAtIndex:i withObject:array];
        
    }
    
    self.title=@"城市管理";
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self customNavigation];
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-70, 200, 90)];
      [button setImage:[UIImage imageNamed:@"城市添加"] forState:UIControlStateNormal];
      [button addTarget:self action:@selector(addNewPlace) forControlEvents:UIControlEventTouchUpInside];
    button.tag=BUTTON_TAG;
    [self.view addSubview:button];
    if (self.selectArray.count==0) {
        button.hidden=NO;
    }else{
    
        button.hidden=YES;
    }
    
          // Do any additional setup after loading the view from its nib.
}




-(void)customNavigation{


        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 6)];
        [button setImage:[UIImage imageNamed:@"点点点"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:button];
    NSMutableArray*array=[[NSMutableArray alloc]init];
    [array addObject:item];
     self.navigationItem.rightBarButtonItems=array;
}


//删除服务区域
-(void)cerfirmDelete{
    
        NSString*cityString;
        for (NSInteger i=0; i<self.selectArray.count; i++) {
            NSArray*array=self.selectArray[i];
            for (NSInteger j=0; j<array.count;j++) {
                if (j==0) {
                    continue;
                }
                AreaModel*model=array[j];
                if (model.isselect==NO) {
                    if (cityString==nil) {
                        cityString=[NSString stringWithFormat:@"%lu",model.id];
                        
                    }else{
                        cityString=[NSString stringWithFormat:@"%@,%lu",cityString,model.id];
                        
                    }
                }
            }
        }
        
        if (cityString==nil) {
            cityString=@"0";
        }
        NSDictionary*dict=@{@"regions":cityString};
        NSString*urlString=[self interfaceFromString:interface_updateServicerRegion];
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1.5f position:@"center" Finish:^{
                if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                    _isShow=NO;
                    [self customNavigation];
                    for (NSInteger i=0; i<self.selectArray.count;i++) {
                        NSMutableArray*cityArray=self.selectArray[i];
                        for (NSInteger j=0; j<cityArray.count; j++) {
                            AreaModel*model=cityArray[j];
                            if (j==0) {
                                continue;
                            }
                            if (model.isselect==YES) {
                                [cityArray removeObjectAtIndex:j];
                                j--;
                            }
                        }
                        if (cityArray.count==1) {
                            [self.selectArray removeObjectAtIndex:i];
                            i--;
                        }else{
                            
                            [self.selectArray replaceObjectAtIndex:i withObject:cityArray];
                        }
                    }
                    
                    [_tableview reloadData];
                    [self reloadData];
                }
            }];
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
    }];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex==0) {
       
        [self addNewPlace];

    }else if (buttonIndex==1){
        //删除
        [self cerfirmDelete];
    }
}


-(void)addNewPlace{

    //新增
    firstAreaViewController*fvc=[[firstAreaViewController alloc]initWithNibName:@"firstAreaViewController" bundle:nil];
    fvc.selectArray=self.selectArray;
    [self pushWinthAnimation:self.navigationController Viewcontroller:fvc];

}

-(void)onClick:(UIButton*)button{
    
    UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"编辑选项" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"新增" otherButtonTitles:@"删除", nil];
    [sheet showInView:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (self.selectArray.count!=0) {
        _isShow=YES;
    }
    return self.selectArray.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray*Array=self.selectArray[section];
    return Array.count-1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;

}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray*Array=self.selectArray[section];
    AreaModel*model=Array[0];
    if (Array.count==1) {
        return nil;
    }
    
    return model.name;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    selelctAreaTableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!Cell) {
        Cell=[[[NSBundle mainBundle]loadNibNamed:@"selelctAreaTableViewCell" owner:nil options:nil]lastObject];
    }
    NSArray*array=self.selectArray[indexPath.section];
    AreaModel*model=array[indexPath.row+1];
    Cell.name.text=model.name;
    Cell.model=model;
    Cell.isShowImage=_isShow;
    [Cell reloadData];
    return Cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray*Array=self.selectArray[indexPath.section];
    AreaModel*model=Array[indexPath.row+1];
    if (_isShow) {
        if (model.isselect==YES) {
            model.isselect=NO;
        }else{
            model.isselect=YES;
        }
        NSInteger row=indexPath.row+1;
        [Array replaceObjectAtIndex:row withObject:model];
        [self.selectArray replaceObjectAtIndex:indexPath.section withObject:Array];
        [_tableview reloadData];
    }
}


@end
