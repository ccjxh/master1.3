//
//  selectCityViewController.m
//  master
//
//  Created by jin on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "selectCityViewController.h"
#import "selectTownViewController.h"
#import "findAddNewWorkViewController.h"
@interface selectCityViewController ()

@end

@implementation selectCityViewController

- (void)viewDidLoad {
    self.urlString=[self interfaceFromString:interface_IDCity];
//    NSLog(@"%@",self.urlString);
    self.dict=@{@"provinceId":[NSString stringWithFormat:@"%u",self.proviceModel.id]};
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AreaModel*model=self.dataArray[indexPath.row];
    selectTownViewController*tvc=[[selectTownViewController alloc]init];
    tvc.viewcontroller=self.viewcontroller;
    tvc.proviceModel=self.proviceModel;
    tvc.cityModel=model;
    tvc.type=2;
    tvc.array=self.array;
    NSMutableArray*array=[[NSMutableArray alloc]init];
    [array addObject:self.proviceModel];
    [array addObject:model];
    NSDictionary*dict=@{@"cityInformation":array};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"city" object:nil userInfo:dict];
    for (UIViewController*vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[findAddNewWorkViewController class]]==YES) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }

//    [self pushWinthAnimation:self.navigationController Viewcontroller:tvc];
}

-(void)selectCity{


}
@end
