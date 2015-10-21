//
//  secondAreaViewController.m
//  master
//
//  Created by jin on 15/9/22.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "secondAreaViewController.h"
#import "proviceSelectedViewController.h"
#import "selelctAreaTableViewCell.h"
@interface secondAreaViewController ()

@end

@implementation secondAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigation];
    self.title=@"市区选择";
    self.automaticallyAdjustsScrollViewInsets=NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)customNavigation{
    
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 50, 20);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(postData) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AreaModel*model=_dataArray[indexPath.section];
    selelctAreaTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"selelctAreaTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.name.text=model.name;
    cell.model=model;
    cell.isShowImage=YES;
    [cell reloadData];
    cell.imageView.hidden=NO;
    return cell;
    
}


-(void)postData{

    [self flowShow];
    NSMutableArray*valueArray=[self returnArrayWithNewData];
    NSString*urlString=[self interfaceFromString:interface_updateServicerRegion];
    for (NSInteger i=0; i<self.selectArray.count; i++) {
        NSArray*array=self.selectArray[i];
        AreaModel*proviceModel=array[0];
        if (proviceModel.id==self.model.id) {
            [self.selectArray removeObject:array];
        }
    }
    
    if (valueArray.count>1) {
     [self.selectArray addObject:valueArray];
    }
    
    NSString*valueString;
    for (NSInteger i=0; i<self.selectArray.count; i++) {
        NSArray*tempArray=self.selectArray[i];
           for (NSInteger j=1; j<tempArray.count; j++) {
               AreaModel*tempModel=tempArray[j];
               if (i==0&&j==1) {
                   valueString=[NSString stringWithFormat:@"%lu",tempModel.id];
               }else{
    
                   valueString=[NSString stringWithFormat:@"%@,%lu",valueString,tempModel.id];
               }
           }
       }
    
    if (valueString==nil) {
        valueString=@"0";
    }
    
    NSDictionary*dict=@{@"regions":valueString};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        [self flowHide];
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self.view makeToast:[dict objectForKey:@"msg"] duration:1.5f position:@"center" Finish:^{
           
            if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
                
                for (UIViewController*vc in self.navigationController.viewControllers) {
                      if ([vc isKindOfClass:[proviceSelectedViewController class]]==YES) {
                          for (NSInteger i=0; i<self.selectArray.count; i++) {
                              NSMutableArray*array=self.selectArray[i];
                              for (NSInteger j=0; j<array.count; j++) {
                                  AreaModel*model=array[j];
                                  model.isselect=NO;
                                  [array replaceObjectAtIndex:j withObject:model];
                              }
                              
                              [self.selectArray replaceObjectAtIndex:i withObject:array];
                          }
                          proviceSelectedViewController*pvc=(proviceSelectedViewController*)vc;
                          pvc.selectArray=self.selectArray;
                          [pvc.tableview reloadData];
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
   
            }
            
        }];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        [self flowHide];
        
    }];

    
//    //regions
//    NSMutableArray*array=[self.selectArray lastObject];
//  
////    [array addObject:model];
//    [self.selectArray replaceObjectAtIndex:self.selectArray.count-1 withObject:array];
//    NSString*valueString;
//    if (self.selectArray.count!=1) {
//        for (NSInteger i=0; i<self.selectArray.count; i++) {
//            NSArray*tempArray=self.selectArray[i];
//            for (NSInteger j=1; j<tempArray.count; j++) {
//                AreaModel*tempModel=tempArray[j];
//                if (i==0&&j==1) {
//                    valueString=[NSString stringWithFormat:@"%lu",tempModel.id];
//                }else{
//                    
//                    valueString=[NSString stringWithFormat:@"%@,%lu",valueString,tempModel.id];
//                }
//            }
//        }
//        
//    }else{
//        
//        valueString=[NSString stringWithFormat:@"%lu",model.id];
//    }
//    NSDictionary*dict=@{@"regions":valueString};
//    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
//        NSDictionary*dict=(NSDictionary*)responseObject;
//        [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center" Finish:^{
//            
//            for (UIViewController*vc in self.navigationController.viewControllers) {
//                if ([vc isKindOfClass:[proviceSelectedViewController class]]==YES) {
//                    [self.navigationController popToViewController:vc animated:YES];
//                }
//            }
//            
//        }];
//        
//    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
//        
//    }];

}


-(NSMutableArray*)returnArrayWithNewData{

    NSMutableArray*valueArray=[[NSMutableArray alloc]init];
    [valueArray addObject:self.model];
    for (NSInteger i=0; i<_dataArray.count; i++) {
        AreaModel*tempModel=_dataArray[i];
        if (tempModel.isselect==YES) {
            [valueArray addObject:tempModel];
        }
    }
    return valueArray;


}
-(void)request{

    [self flowShow];
    NSString*urlString=[self interfaceFromString:interface_allCityList];
    NSDictionary*dict=@{@"provinceId":[NSString stringWithFormat:@"%lu",self.model.id]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        NSArray*array=[dict objectForKey:@"entities"];
        for (NSInteger i=0; i<array.count; i++) {
            NSDictionary*inforDict=array[i];
            AreaModel*model=[[AreaModel alloc]init];
            [model setValuesForKeysWithDictionary:[inforDict objectForKey:@"dataCatalog"]];
            for (NSInteger j=0; j<self.selectArray.count; j++) {
                NSArray*comArr=self.selectArray[j];
                for (NSInteger n=i; n<comArr.count; n++) {
                    AreaModel*comModel=comArr[n];
                    if (comModel.id==model.id) {
                        model.isselect=YES;
                    }
  
                }
            }

            [_dataArray addObject:model];
        }
        [self.tableview reloadData];
        [self flowHide];
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
       
        [self flowHide];

    }];

}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     AreaModel*model=_dataArray[indexPath.section];
    if (model.isselect==YES) {
        model.isselect=NO;
    }else{
    model.isselect=YES;
    }
    [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
    NSIndexPath*path=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    [self.tableview reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
//    NSMutableArray*array=[[NSMutableArray alloc]init];
//    [array addObject:self.model];
//    
}

@end
