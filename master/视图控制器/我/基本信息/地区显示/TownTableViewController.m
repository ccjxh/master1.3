//
//  TownTableViewController.m
//  master
//
//  Created by xuting on 15/5/28.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "TownTableViewController.h"
#import "AreaModel.h"
#import "BasicInfoViewController.h"
#import "OrderDetailViewController.h"  //提交预约界面
#import "AddCommonAddressCtl.h" //添加常用地址界面
#import "RootViewController.h"

@interface TownTableViewController ()

@property(nonatomic) AreaModel *townModel;
@property(nonatomic) NSMutableArray *townArr;
@property (nonatomic,strong) RootViewController *rVC;

@end

@implementation TownTableViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"地区选择";
    self.townTableView.delegate = self;
    self.townTableView.dataSource = self;
    _townArr = [NSMutableArray array];
    [_rVC CreateFlow];
    [self requestCityInfo:self.cityId];
    
}
#pragma mark - Table view data source
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _townArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TownTableViewController"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:1 reuseIdentifier:@"TownTableViewController"];
    }
    _townModel = _townArr[indexPath.row];
    cell.textLabel.text = _townModel.name;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _townModel = _townArr[indexPath.row];
    self.content = [NSString stringWithFormat:@"%@-%@",self.content,_townModel.name];
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
            if (self.blockRegion)
            {
                self.blockRegion(self.content,_townModel.id);
            }
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:self.content forKey:@"region"];
            [dict setObject:[NSNumber numberWithInteger:_townModel.id] forKey:@"regionId"];
            
            if ([type isEqualToString:@"1"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"basic" object:dict];
            }
            else if ([type isEqualToString:@"2"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"order" object:dict];
            }
            else
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
    NSString *urlString = [self interfaceFromString:interface_resigionList];
    NSDictionary *dict = @{@"cityId":[NSNumber numberWithInteger:Id]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        [_rVC flowHide];
        
        NSDictionary *objDic = (NSDictionary*)responseObject;
        NSArray *entityArr = objDic[@"entities"];
        
        for (int i=0; i<entityArr.count; i++)
        {
            _townModel = [[AreaModel alloc] init];
            NSDictionary *dict = entityArr[i];
            NSDictionary *dataCatalogDic = dict[@"dataCatalog"];
            [_townModel setValuesForKeysWithDictionary:dataCatalogDic];
            [_townArr addObject:_townModel];
        }
        [self.townTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}

@end
