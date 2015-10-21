//
//  selectTownViewController.m
//  master
//
//  Created by jin on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "selectTownViewController.h"
#import "MyserviceViewController.h"
@interface selectTownViewController ()
@property(nonatomic)NSMutableArray*valueArray;
@property(nonatomic)NSInteger count;//是否属于该省份
@end

@implementation selectTownViewController

- (void)viewDidLoad {
    self.urlString=[self interfaceFromString:interface_IDTown];
    self.dict=@{@"cityId":[NSString stringWithFormat:@"%lu",self.cityModel.id]};
    [super viewDidLoad];
    [self customNv];
    // Do any additional setup after loading the view.
}
-(void)selectCity{
    if (!_valueArray) {
        _valueArray=[[NSMutableArray alloc]init];
    }
    [_valueArray removeAllObjects];
    if (self.array.count>0) {
        for (NSInteger i=0; i<self.array.count; i++) {
            NSArray*temp=self.array[i];
            AreaModel*model=temp[0];
            if (model.id==self.cityModel.id) {
                for (NSInteger j=0; j<self.dataArray.count; j++) {
                    AreaModel*townModel=self.dataArray[j];
                    for (NSInteger n=1; n<temp.count; n++) {
                        AreaModel*orginModel=temp[n];
                        if (townModel.id==orginModel.id) {
                            townModel.isselect=YES;
                            [self.dataArray replaceObjectAtIndex:j withObject:townModel];
                        }
                    }
                }
            }
        }
    }
       [self.tableview reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)customNv{
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:17];
    [button addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}

//-(void)confirm{
//    [self sendNotice];
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AreaModel*model=self.dataArray[indexPath.row];
    if (model.isselect==YES) {
        model.isselect=NO;
    }
    else{
    model.isselect=YES;
    }
    
    [self sendNotice:model];
//    [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
//    [self.tableview reloadData];
    
}


-(void)sendNotice:(AreaModel*)model{
    
//    NSMutableArray*tempArray=[[NSMutableArray alloc]init];
//    [tempArray addObject:self.cityModel];
//    for (NSInteger i=0; i<self.dataArray.count; i++) {
//        AreaModel*model=self.dataArray[i];
//        if (model.isselect==YES) {
//            [tempArray addObject:model];
//        }
//    }
//    
//    if (tempArray.count>1) {
//        if (self.array.count>0) {
//        for (NSInteger j=0; j<self.array.count; j++) {
//            NSArray*array=self.array[j];
//            AreaModel*cityModel=array[0];
//            if (cityModel.id==self.cityModel.id) {
//                    [self.array replaceObjectAtIndex:j withObject:tempArray];
//                _count++;
//                }
//            }
//            if (_count==0) {
//                [self.array addObject:tempArray];
//            }
//        }else{
//            [self.array addObject:tempArray];
//        }
//    }else{
//        for (NSInteger j=0; j<self.array.count; j++) {
//            NSArray*array=self.array[j];
//            AreaModel*cityModel=array[0];
//            if (cityModel.id==self.cityModel.id) {
//                [self.array removeObjectAtIndex:j];
//                }
//            }
//        }
//    
//    for (NSInteger i=0; i<self.array.count; i++) {
//        NSArray*temp=self.array[i];
//        [_valueArray addObject:temp];
//    }
    [_valueArray addObject:self.proviceModel];
    [_valueArray addObject:self.cityModel];
//    [_valueArray addObject:<#(id)#>]
     NSDictionary*dict=@{@"cityInformation":_valueArray};
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"city" object:nil userInfo:dict];
   }
@end
