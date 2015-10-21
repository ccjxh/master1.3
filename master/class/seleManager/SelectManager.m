//
//  SelectManager.m
//  master
//
//  Created by jin on 15/10/10.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "SelectManager.h"
#import "MyserviceViewController.h"
#import "BasicInfoViewController.h"
#import "myServiceSelectedViewController.h"
#import "myPublicViewController.h"
#import "myPublicViewController.h"
#import "myRecommendPeopleViewController.h"
#import "SetViewController.h"
#import "myIntegralListViewController.h"
#import "myCaseViewController.h"
#import "CollectViewController.h"
#import "MyShareViewController.h"
#import "MyViewController.h"
#import "introlduceChangeViewController.h"
#import "workStatusViewController.h"
#import "recommendViewController.h"
#import "TableViewCell.h"
#import "projectCaseAddViewController.h"
#import "PayViewController.h"
#import "projectCastDetailViewController.h"
#import "myServiceSelectedViewController.h"
#import "ChangeDateViewController.h"
#import "certainViewController.h"
#import "cityViewController.h"
#import "provinceViewController.h"
#import "proviceSelectedViewController.h"
@implementation SelectManager
+(SelectManager*)share{
    static dispatch_once_t once;
    static SelectManager*manager;
    if (!manager) {
        dispatch_once(&once, ^{
            manager=[[SelectManager alloc]init];
        });
    }
    return manager;
}


-(void)tableviewDidSelectWithKindOfClass:(NSString* )classString IndexPath:(NSIndexPath *)indexPath Navigatingation:(UINavigationController *)navigationController Tableview:(UITableView *)tableview{
    if ([classString isEqualToString:@"MyViewController"]==YES) {
        AppDelegate*Delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
            switch (indexPath.section) {
                case 0:
                {
                    //个人基本信息
                    BasicInfoViewController *ctl = [[BasicInfoViewController alloc] init];
                    ctl.hidesBottomBarWhenPushed=YES;
                    ctl.block=^(NSString*realName,NSString*corve){
                        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                        PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
                        model.icon=corve;
                        [[dataBase share]addInformationWithModel:model];
                        [tableview reloadData];
                    };
                    
                    [self pushWinthAnimation:navigationController Viewcontroller:ctl];
                }
                    break;
                case 1:
                {
                    switch (indexPath.row) {
                        case 0:
                        {
                            //我的服务
                            AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                            PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
                            if (delegate.userPost==3||delegate.userPost==4||delegate.userPost==2||model.skillState==1) {
                                MyserviceViewController*mvc=[[MyserviceViewController alloc]initWithNibName:@"MyserviceViewController" bundle:nil];
                                mvc.title=@"我的服务";
                                mvc.hidesBottomBarWhenPushed=YES;
                                [self pushWinthAnimation:navigationController Viewcontroller:mvc];
                                return;
                            }
                            myServiceSelectedViewController*svc=[[myServiceSelectedViewController alloc]initWithNibName:@"myServiceSelectedViewController" bundle:nil];
                            svc.hidesBottomBarWhenPushed=YES;
                            [self pushWinthAnimation:navigationController  Viewcontroller:svc];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                    break;
                case 2:{
                    if (Delegate.userPost==1) {
                        myPublicViewController*mvc=[[myPublicViewController alloc]init];
                        mvc.hidesBottomBarWhenPushed=YES;
                        [self pushWinthAnimation:navigationController Viewcontroller:mvc];
                        return;
                    }
                   
                    myCaseViewController *ctl = [[myCaseViewController alloc] initWithNibName:@"myCaseViewController" bundle:nil];
                    ctl.hidesBottomBarWhenPushed=YES;
                    [self pushWinthAnimation:navigationController Viewcontroller:ctl];
                }
                    
                    break;
                    
                case 3:
                {
                    if (Delegate.userPost!=1) {
                       
                        myPublicViewController*mvc=[[myPublicViewController alloc]init];
                        mvc.hidesBottomBarWhenPushed=YES;
                        [self pushWinthAnimation:navigationController Viewcontroller:mvc];
                    }else{
                        
                        myIntegralListViewController*mvc=[[myIntegralListViewController alloc]init];
                        mvc.hidesBottomBarWhenPushed=YES;
                        [self pushWinthAnimation:navigationController Viewcontroller:mvc];
                    }
                    
                }
                    break;
                case 4:
                {
                    if (Delegate.userPost!=1){
                        switch (indexPath.row) {
                            case 0:
                            {
                               
                                myIntegralListViewController*mvc=[[myIntegralListViewController alloc]init];
                                mvc.hidesBottomBarWhenPushed=YES;
                                [self pushWinthAnimation:navigationController Viewcontroller:mvc];
                                
                            }
                                break;
                            default:
                                break;
                        }
                    }else{
                        CollectViewController *cVC = [[CollectViewController alloc] init];
                        cVC.hidesBottomBarWhenPushed=YES;
                        [self pushWinthAnimation:navigationController Viewcontroller:cVC];
                    }
                }
                    break;
                case 5:
                {
                    
                    if (Delegate.userPost!=1) {
                        
                        CollectViewController *cVC = [[CollectViewController alloc] init];
                        cVC.hidesBottomBarWhenPushed=YES;
                        [self pushWinthAnimation:navigationController Viewcontroller:cVC];
                        
                    }else{
                        MyShareViewController*svc=[[MyShareViewController alloc]init];
                        svc.hidesBottomBarWhenPushed=YES;
                        [self pushWinthAnimation:navigationController Viewcontroller:svc];
                    }
                    
                }
                    break;
                case 6:
                {
                    if (Delegate.userPost!=1) {
                       
                        MyShareViewController*svc=[[MyShareViewController alloc]init];
                        svc.hidesBottomBarWhenPushed=YES;
                        [navigationController pushViewController:svc animated:YES];
                        
                    }else{
                        SetViewController *ctl = [[SetViewController alloc] init];
                        ctl.hidesBottomBarWhenPushed=YES;
                        [self pushWinthAnimation:navigationController Viewcontroller:ctl];
                    }
                }
                    break;
                case 7:
                {
                    SetViewController *ctl = [[SetViewController alloc] init];
                    ctl.hidesBottomBarWhenPushed=YES;
                    [self pushWinthAnimation:navigationController Viewcontroller:ctl];
                }
                    break;
                default:
                    break;
        }
    }else if ([classString isEqualToString:@"MyserviceViewController"]==YES){
    
        
    
    }
}
@end
