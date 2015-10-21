//
//  CityTableViewController.m
//  master
//
//  Created by xuting on 15/5/28.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "CityTableViewController.h"
#import "AreaModel.h"
#import "TownTableViewController.h"
#import "RootViewController.h"
#import "BasicInfoViewController.h"
#import "OrderDetailViewController.h"
#import "AddCommonAddressCtl.h"
#import "findMasterViewController.h"
@interface CityTableViewController ()

@property(nonatomic,copy) NSMutableArray *cityArr;
@property(nonatomic,copy) AreaModel *cityModel;
@property (nonatomic,strong) RootViewController *rVC;

@end

@implementation CityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"城市选择";
    self.cityTableView.delegate = self;
    self.cityTableView.dataSource = self;
    
    _cityArr = [NSMutableArray array];
    [_rVC CreateFlow];
    [self requestCityInfo:self.provinceId];
}


#pragma mark - Table view data source
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cityArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityTableViewController"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:1 reuseIdentifier:@"CityTableViewController"];
    }
    _cityModel = _cityArr[indexPath.row];
    cell.textLabel.text = _cityModel.name;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    TownTableViewController *ctl = [[TownTableViewController alloc] init];
    _cityModel = _cityArr[indexPath.row];
//    ctl.cityId = _cityModel.id;
//    ctl.flag = self.flag;
//    ctl.content = ;
//    [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
    self.content = [NSString stringWithFormat:@"%@-%@",_content,_cityModel.name];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [defaults objectForKey:@"type"];
    UIViewController *viewController = [[UIViewController alloc] init];
    // 判断pop到哪一个控制器
    if ([type isEqualToString:@"1"])
    {
        viewController = [[BasicInfoViewController alloc] init];
    }
    else if([type isEqualToString:@"2"])
    {
        viewController = [[OrderDetailViewController alloc] init];
    }else if ([type isEqualToString:@"5"]){
    
        viewController=[[findMasterViewController alloc]init];
    
    }
    else
    {
        viewController = [[AddCommonAddressCtl alloc] init];
    }
    for (UIViewController *controller in self.navigationController.
         viewControllers)
    {
        if ([controller isKindOfClass:[viewController class]])
        {
//            if (self.blockRegion)
//            {
//                self.blockRegion(self.content,_townModel.id);
//            }
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:self.content forKey:@"region"];
            [dict setObject:[NSNumber numberWithInteger:_cityModel.id]  forKey:@"regionId"];
            
            if ([type isEqualToString:@"1"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"basic" object:dict];
            }
            else if ([type isEqualToString:@"2"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"order" object:dict];
            }else if ([type isEqualToString:@"5"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"home" object:dict];
                
            }else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"address" object:dict];
            }
            
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

#pragma mark - 请求城市信息
-(void) requestCityInfo : (NSInteger) Id
{
    [_rVC flowShow];
    NSString *urlString = [self interfaceFromString:interface_allCityList];
    NSDictionary *dict = @{@"provinceId":[NSNumber numberWithInteger:Id]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        [_rVC flowHide];
        
        NSDictionary *objDic = (NSDictionary*)responseObject;
        NSArray *entityArr = objDic[@"entities"];
        for (int i=0; i<entityArr.count; i++)
        {
            _cityModel = [[AreaModel alloc] init];
            NSDictionary *dict = entityArr[i];
            NSDictionary *dataCatalogDic = dict[@"dataCatalog"];
            [_cityModel setValuesForKeysWithDictionary:dataCatalogDic];
            [_cityArr addObject:_cityModel];
        }
        [self.cityTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}
@end
