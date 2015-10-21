//
//  allViewController.m
//  master
//
//  Created by jin on 15/6/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "allViewController.h"
#import "MNextOrderDetailViewController.h"
@interface allViewController ()

@end

@implementation allViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage=1;
    self.isRefersh=YES;
    [self sendRequesr];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)sendRequesr{
   
       NSString*urlString=[self interfaceFromString:interface_myNextOrder];
       [self requestWithURL:urlString];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    billListModel*model;
    model=self.dataArray[indexPath.row];
    MNextOrderDetailViewController*mvc=[[MNextOrderDetailViewController alloc]initWithNibName:@"orderDetailOrderViewController" bundle:nil];
    mvc.id=model.id;
    mvc.block=^(BOOL isChange){
        if (isChange) {
            self.isRefersh=YES;
            [self sendRequesr];
        }
    
    };
    [self pushWinthAnimation:self.nc Viewcontroller:mvc];
    
}

@end
