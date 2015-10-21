//
//  mynextBillAllViewController.m
//  master
//
//  Created by jin on 15/6/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "mynextBillAllViewController.h"
#import "MNextOrderDetailViewController.h"
#import "myorderDetailViewController.h"
@interface mynextBillAllViewController ()

@end

@implementation mynextBillAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sendRequesr];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)sendRequesr{
    NSString*urlString=[self interfaceFromString:interface_myOrder];
    [self requestWithURL:urlString];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    billListModel*model;
    model=self.dataArray[indexPath.row];
    myorderDetailViewController*mvc=[[myorderDetailViewController alloc]initWithNibName:@"orderDetailOrderViewController" bundle:nil];
    mvc.id=model.id;
    mvc.block=^(BOOL isNetRefersh){
        if (isNetRefersh) {
            self.isRefersh=YES;
            [self sendRequesr];
        }
    
    
    };
    [self pushWinthAnimation:self.nc Viewcontroller:mvc];
}


@end
