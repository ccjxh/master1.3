//
//  firstAreaViewController.m
//  master
//
//  Created by jin on 15/9/22.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "firstAreaViewController.h"
#import "secondAreaViewController.h"

@interface firstAreaViewController ()

@end

@implementation firstAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"省选择";
    [self initData];
    [self CreateFlow];
    [self request];
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

}

-(void)request{

    [self flowShow];
    NSString*urlString=[self interfaceFromString:interface_provinceList];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        NSArray*entityArr=[dict objectForKey:@"entities" ];
        for (NSInteger i=0; i<entityArr.count; i++) {
            NSDictionary*inforDic=entityArr[i];
            AreaModel*model=[[AreaModel alloc]init];
            [model setValuesForKeysWithDictionary:[inforDic objectForKey:@"dataCatalog"]];
            [_dataArray addObject:model];
        }

        [_tableview reloadData];
        [self flowHide];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{


    return _dataArray.count;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!Cell) {
        Cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
    }
    AreaModel*model=_dataArray[indexPath.section];
    Cell.textLabel.text=model.name;
    Cell.textLabel.font=[UIFont systemFontOfSize:16];
    return Cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    secondAreaViewController*svc=[[secondAreaViewController alloc]initWithNibName:@"firstAreaViewController" bundle:nil];
    svc.model=_dataArray[indexPath.section];
    AreaModel*model=_dataArray[indexPath.section];
//    NSMutableArray*array=[[NSMutableArray alloc]initWithObjects:model, nil];
//    [self.selectArray addObject:array];
    svc.selectArray=self.selectArray;
    [self pushWinthAnimation:self.navigationController Viewcontroller:svc];

}
@end
