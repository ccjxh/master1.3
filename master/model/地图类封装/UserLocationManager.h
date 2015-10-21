//
//  UserLocationManager.h
//  master
//
//  Created by jin on 15/6/11.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UserLocationManager : NSObject<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    CLLocation *cllocation;
    BMKReverseGeoCodeOption *reverseGeoCodeOption;//逆地理编码
}
@property (strong,nonatomic) BMKLocationService *locService;


//城市名
@property (strong,nonatomic) NSString *cityName;

//用户纬度
@property (nonatomic,assign) double userLatitude;

//用户经度
@property (nonatomic,assign) double userLongitude;

//用户位置
@property (strong,nonatomic) CLLocation *clloction;


//初始化单例
+ (UserLocationManager *)sharedInstance;

//初始化百度地图用户位置管理类
- (void)initBMKUserLocation;

//开始定位
-(void)startLocation;

//停止定位
-(void)stopLocation;
@end
