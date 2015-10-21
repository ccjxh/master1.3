//
//  sleleViewModel.h
//  master
//
//  Created by jin on 15/7/27.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sleleViewModel : NSObject
@property(nonatomic,copy)void(^requestDealBlock)(BOOL isSuccess,id responseObject);
@property(nonatomic)NSString*currentCityName;
@property(nonatomic)NSMutableArray*ADArray;
@property(nonatomic)CLGeocoder*geocoder;
-(void)request;//请求当前城市
-(void)requestAdImage;//广告栏图片请求
@end
