//
//  myIntegralListViewController.m
//  master
//
//  Created by jin on 15/9/28.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "myIntegralListViewController.h"
#import "myIntegralListView.h"
#import "myIntrgalListModel.h"
#import "webDetailViewController.h"

@interface myIntegralListViewController ()

@end

@implementation myIntegralListViewController
{

    myIntegralListView*_listView;
    NSMutableDictionary*_dict;
    NSInteger _currentPage;//当前页数
    NSMutableArray*_dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage=1;
    self.title=@"我的积分";
    [self customNavigation];//定制导航栏
    [self createUI];        //创建UI
    [self CreateFlow];
    [self request];         //积分数据请求
        // Do any additional setup after loading the view.
}

-(void)createUI{

    _listView=[[myIntegralListView alloc]initWithFrame:self.view.bounds];
    __weak typeof (myIntegralListView*)weakListview=_listView;
    _listView.changeDictValue=^(NSInteger index){
    
        if ([[weakListview.showDict objectForKey:[NSString stringWithFormat:@"%lu",index]]integerValue]==0) {
            [weakListview.showDict setObject:@"1" forKey:[NSString stringWithFormat:@"%lu",index]];
        }else{
        
            [weakListview.showDict setObject:@"0" forKey:[NSString stringWithFormat:@"%lu",index]];
        }
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
        [weakListview.tableview reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
        
    };
    self.view=_listView;
}


-(void)customNavigation{


    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    [button setTitle:@"积分规则" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(webviewShow) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];

}

-(void)webviewShow{

    webDetailViewController*wvc=[[webDetailViewController alloc]initWithNibName:@"webDetailViewController" bundle:[NSBundle mainBundle]];
    NSString *str=[NSString stringWithFormat:@"%@/%@",changeURL,@"admin/help/queryIntegralRule"];
    NSLog(@"%@",str);
    wvc.urlString=str;
    [self pushWinthAnimation:self.navigationController Viewcontroller:wvc];

}

//网络请求
-(void)request{

//    NSMutableArray*Array=[[NSMutableArray alloc]initWithObjects:@"fdsf",@"ffsdf", nil];
    
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    [self flowShow];
    NSString*urlString=[self interfaceFromString:interface_myIntegral];
    NSDictionary*dict=@{@"pageNo":[NSString stringWithFormat:@"%lu",_currentPage],@"pageSize":@"10"};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            NSArray*array=[dict objectForKey:@"entities"];
            for (NSInteger i=0; i<array.count; i++) {
                NSDictionary*inforDic=array[i];
                myIntrgalListModel*model=[[myIntrgalListModel alloc]init];
                [model setValuesForKeysWithDictionary:[inforDic objectForKey:@"userIntegral"]];
                [_dataArray addObject:model];
            }
            _listView.dataArray=_dataArray;
            _dict=[[NSMutableDictionary alloc]init];
            for ( NSInteger i=0; i<_dataArray.count; i++) {
                    [_dict setObject:@"0" forKey:[NSString stringWithFormat:@"%lu",i]];
                }
            _listView.showDict=_dict;
            [_listView reloadData];
            
        }else{
        
            [self.view makeToast:[dict objectForKey:@"msg"] duration:1.5f position:@"center"];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        [self flowHide];
        [self.view makeToast:@"当前网络不好,请稍后重试" duration:1.5f position:@"center"];

    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
