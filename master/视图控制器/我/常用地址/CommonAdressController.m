//
//  CommonAdressController.m
//  master
//
//  Created by xuting on 15/5/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "CommonAdressController.h"
#import "CommonAdressModel.h"
#import "AddCommonAddressCtl.h" //新增常用地址界面

@interface CommonAdressController ()
{
    CommonAdressModel *commonAdressModel;
    NSMutableArray *commonAdressArr;
}
@end

@implementation CommonAdressController



- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage=1;
    self.isRefersh=YES;
    self.commonAdressTbView.separatorStyle=0;
    self.navigationItem.title = @"常用地址";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    commonAdressModel = [[CommonAdressModel alloc]init];
    commonAdressArr=[NSMutableArray array];
    self.commonAdressTbView.delegate = self;
    self.commonAdressTbView.dataSource = self;
//    self.commonAdressTbView.scrollEnabled = NO; //设置tableview不被滑动
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addAddress)];
    
     [self CreateFlow];
    [self requestCommonAdress];
    __weak typeof(self) weSelf=self;
    self.RefershBlock=^{
        _currentPage=1;
        [weSelf requestCommonAdress];
    };
    [self setupHeaderWithTableview:self.commonAdressTbView];
    [self setupFooter:self.commonAdressTbView];
   
    [self noData];
    [self net];
}

#pragma mark - 新增常用地址
-(void) addAddress
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"3" forKey:@"type"];
    [defaults synchronize];
    AddCommonAddressCtl *ctl = [[AddCommonAddressCtl alloc] init];
    ctl.addCommonAddressBlock = ^(NSString *address){
        
        [commonAdressArr removeAllObjects];
        [self requestCommonAdress];
    };
    [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
}

#pragma mark - UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return commonAdressArr.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    normalAdress*model=commonAdressArr[indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    if (commonAdressArr.count == 0)
    {
        self.commonAdressTbView.backgroundColor = [UIColor grayColor];
        [self.view makeToast:@"暂无常用地址！" duration:2.0f position:@"center" title:@"温馨提示"];
    }
    else
    {
        commonAdressModel = commonAdressArr[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@-%@-%@",[model.province objectForKey:@"name"],[model.city objectForKey:@"name"],[model.region objectForKey:@"name"]];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.text = model.street;
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self flowShow];
    commonAdressModel = commonAdressArr[indexPath.row];
    [self requestDeleteCommonAdress:commonAdressModel.id:indexPath.row];
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark - 请求常用地址
-(void) requestCommonAdress
{
    [self flowShow];
    self.netIll.hidden=YES;
    self.noDataView.hidden=YES;
    NSString *urlString = [self interfaceFromString:interface_commonAdress];
    NSDictionary *dict = @{@"pageNo":[NSNumber numberWithInt:1],@"pageSize":[NSNumber numberWithInt:10]};
      [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        [self flowHide];
        NSDictionary *objDic = (NSDictionary*)responseObject;
        NSArray *entityArr = objDic[@"entities"];
          if (self.isRefersh==YES) {
              [commonAdressArr removeAllObjects];
          }
        for (int i=0; i<entityArr.count; i++)
        {
            commonAdressModel = [[CommonAdressModel alloc]init];
            NSDictionary *dic = entityArr[i];
            NSDictionary *addressDTO = dic[@"address"];
            normalAdress*model=[[normalAdress alloc]init];
            [model setValuesForKeysWithDictionary:addressDTO];
            [commonAdressArr addObject:model];
        }
          if (commonAdressArr.count==0) {
              self.noDataView.hidden=NO;
          }else{
              self.noDataView.hidden=YES;

          }
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [self.commonAdressTbView reloadData];
              [self.weakRefreshHeader endRefreshing];
              [self.refreshFooter endRefreshing];
              self.isRefersh=NO;
              [self flowHide];
          });
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        self.isRefersh=NO;
        [self.weakRefreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        [self flowHide];
        self.netIll.hidden=NO;
    }];
}


#pragma mark - 删除常用地址
-(void) requestDeleteCommonAdress : (NSInteger) addressId :(NSInteger)row
{
    NSString *urlString = [self interfaceFromString:interface_deleteCommonAdress];
    NSDictionary *dict = @{@"id":[NSNumber numberWithInteger:addressId]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        
        [self flowHide];
        NSDictionary *objDic = (NSDictionary*)responseObject;
        if ([[objDic objectForKey:@"rspCode"] integerValue] == 200)
        {
            [commonAdressArr removeObjectAtIndex:row];
            [self.commonAdressTbView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
//        NSLog(@"error = %@",error);
        [self flowHide];
    }];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    normalAdress*model=commonAdressArr[indexPath.row];
    if (self.type==0) {
    AddCommonAddressCtl *ctl = [[AddCommonAddressCtl alloc] init];
    ctl.model=model;
    ctl.type=1;
    ctl.addCommonAddressBlock=^(NSString*temp){
    
        if ([temp isEqualToString:@"yes"]==YES) {
            self.isRefersh=YES;
            [self requestCommonAdress];
        }
    };
    
    [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
    }else if (self.type==1){
        if (self.addressBlock) {
            self.addressBlock(model);
            [self popWithnimation:self.navigationController];
        }

    }
    
}



@end
