//
//  ProvinceTableViewController.m
//  master
//
//  Created by xuting on 15/5/28.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "ProvinceTableViewController.h"
#import "AreaModel.h"
#import "CityTableViewController.h" //显示城市
#import "RootViewController.h" //

@interface ProvinceTableViewController ()

@property (nonatomic,copy) NSMutableArray *provinceArr;
@property (nonatomic,copy) AreaModel *areaModel;
@property (nonatomic,strong) RootViewController *rVC;

@end

@implementation ProvinceTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _areaModel = [[AreaModel alloc] init];
    self.navigationItem.title = @"省份选择";
    self.provinceTableView.delegate = self;
    self.provinceTableView.dataSource = self;
    
    _provinceArr = [NSMutableArray array];
    [_rVC CreateFlow];
    [self requestProvinceInfo];
    

}

#pragma mark - Table view data source
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _provinceArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProvinceTableViewController"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:1 reuseIdentifier:@"ProvinceTableViewController"];
    }
    _areaModel=_provinceArr[indexPath.row];
    cell.textLabel.text=_areaModel.name;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityTableViewController *ctl = [[CityTableViewController alloc] init];
    _areaModel = _provinceArr[indexPath.row];
    ctl.provinceId= _areaModel.id;
    ctl.content =  _areaModel.name;
    ctl.flag = 1;
    [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
}
#pragma mark - 请求省份信息
-(void) requestProvinceInfo
{
    [_rVC flowShow];
    NSString*urlString=[self interfaceFromString:interface_provinceList];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        [_rVC flowHide];
        NSDictionary*objDic=(NSDictionary*)responseObject;
        NSArray*entityArr=objDic[@"entities"];
        for (int i=0; i<entityArr.count; i++)
        {
            _areaModel = [[AreaModel alloc] init];
            NSDictionary *dict=entityArr[i];
            NSDictionary*dataCatalogDic=dict[@"dataCatalog"];
            [_areaModel setValuesForKeysWithDictionary:dataCatalogDic];
            [_provinceArr addObject:_areaModel];
        }
        [self.provinceTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}



@end
