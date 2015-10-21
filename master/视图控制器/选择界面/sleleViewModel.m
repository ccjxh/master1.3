//
//  sleleViewModel.m
//  master
//
//  Created by jin on 15/7/27.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "sleleViewModel.h"

@implementation sleleViewModel

-(void)request
{
   
    AreaModel*model3=[[dataBase share]findWithCity:_currentCityName];
    NSArray*array=[[dataBase share]findWithPid:model3.id];
    if (array.count==0) {
        NSString*urlString=[self interfaceFromString:interface_resigionList];
        [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            NSArray*tempArray=[dict objectForKey:@"entities"];
            NSMutableArray*valueArray=[[NSMutableArray alloc]init];
            for (NSInteger i=0; i>tempArray.count; i++) {
                NSDictionary*inforDict=tempArray[i];
                AreaModel*cityModel=[[AreaModel alloc]init];
                [cityModel setValuesForKeysWithDictionary:[inforDict objectForKey:@"dataCatalog"]];
                [valueArray addObject:cityModel];
                }
               [[dataBase  share]addCityToDataBase:valueArray Pid:model3.id];
           
            } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
        }];
    }
}



-(void)requestAdImage{
    if (!_ADArray) {
        _ADArray=[[NSMutableArray alloc]init];
    }
    [_ADArray removeAllObjects];
    NSString*urlString=[self interfaceFromString:interface_banners];
    [[httpManager manager]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            NSArray*Array=[dict objectForKey:@"entities"];
            for (NSInteger i=0; i<Array.count; i++) {
                NSDictionary*inforDic=Array[i];
                NSString*url=[[inforDic objectForKey:@"advertising"] objectForKey:@"resource"];
                NSString*temp=[NSString stringWithFormat:@"%@%@",changeURL,url];
                adModel*model=[[adModel alloc]init];
                [model setValuesForKeysWithDictionary:[inforDic objectForKey:@"advertising"]];
                [_ADArray addObject:model];
            }
            
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUI" object:nil userInfo:nil];
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        
        
    }];
}



//缓存支付
-(void)requestPay{
    
    NSString*urlString=[self interfaceFromString:interface_moneyType];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        
        if ([[dict objectForKey:@"rspCode"] intValue]==200) {
            NSArray*Array=[dict objectForKey:@"entities"];
            for (NSInteger i=0; i<Array.count; i++) {
                NSDictionary*inforDict=Array[i];
                payModel*model=[[payModel alloc]init];
                [model setValuesForKeysWithDictionary:[inforDict objectForKey:@"dataItem"]];
                [[dataBase share]addPay:model];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
    
}



//#pragma mark - CoreLocation 代理
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
//    CLLocation *location=[locations firstObject];//取出第一个位置
//    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
//    //    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
//    //    //如果不需要实时定位，使用完即使关闭定位服务
//    [_mapManager stopUpdatingLocation];
//    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
//}
//
//#pragma mark 根据坐标取得地名
//-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
//    //反地理编码
//    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
//    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        CLPlacemark *placemark=[placemarks firstObject];
//        _currentCityName=[placemark.addressDictionary objectForKey:@"City"];
//        UIButton*view=(id)[self.view viewWithTag:21];
//        [view removeFromSuperview];
//        [self initUI];
//        //SubLocality  区
//    }];
//}
//



@end
