//
//  myOrderViewController.m
//  master
//
//  Created by jin on 15/6/2.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "myOrderViewController.h"
#import "myorderDetailViewController.h"
@interface myOrderViewController ()

@end

@implementation myOrderViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    if (self.seg.selectedSegmentIndex==0) {
        [self sendRequesr];
    }else if (self.seg.selectedSegmentIndex==1){
        [self requestWithURL:self.waitConfirmUrlString];
        [self.scrollview setContentOffset:CGPointMake(SCREEN_WIDTH, self.tableview.frame.origin.y) animated:YES];
    }else if (self.seg.selectedSegmentIndex==2){
        
        [self requestWithURL:self.waitCommentUrlString];
        [self.scrollview setContentOffset:CGPointMake(SCREEN_WIDTH*2, self.tableview.frame.origin.y) animated:YES];
    }
}


- (void)viewDidLoad {
    self.waitCommentUrlString=[self interfaceFromString:interface_myorderCommend];
    self.waitConfirmUrlString=[self interfaceFromString:interface_myorderConfirm];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    NSInteger width=self.scrollview.contentOffset.x;
    if (width/SCREEN_WIDTH==0) {
        
        
        model=self.dataArray[indexPath.row];
    }
    else if (width/SCREEN_WIDTH==1){
        model=self.waitConfirArray[indexPath.row];
    }
    else if (width/SCREEN_WIDTH){
        model=self.waitCommentArray[indexPath.row];
        
    }
    
    myorderDetailViewController*mvc=[[myorderDetailViewController alloc]initWithNibName:@"orderDetailOrderViewController" bundle:nil];
    mvc.id=model.id;
    [self pushWinthAnimation:self.navigationController Viewcontroller:mvc];

}

@end
