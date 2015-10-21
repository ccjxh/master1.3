//
//  provinceViewController.m
//  master
//
//  Created by jin on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "provinceViewController.h"
#import "selectCityViewController.h"
@interface provinceViewController ()

@end

@implementation provinceViewController

- (void)viewDidLoad {
    self.urlString=[self interfaceFromString:interface_getOpenCityList];
    self.dict=[[NSMutableDictionary alloc]init];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AreaModel*model=self.dataArray[indexPath.row];
    selectCityViewController*cvc=[[selectCityViewController alloc]init];
    cvc.proviceModel=model;
    cvc.type=1;
    cvc.array=self.array;
    cvc.viewcontroller=self.viewcontroller;
    [self pushWinthAnimation:self.navigationController  Viewcontroller:cvc];
}

-(void)selectCity{


}
@end
