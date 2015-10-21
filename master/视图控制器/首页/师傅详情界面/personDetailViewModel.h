//
//  personDetailViewModel.h
//  master
//
//  Created by jin on 15/8/5.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

@protocol personDetailDelegate <NSObject>
@required
-(NSInteger)personID;//师傅的id
-(NSInteger)firstLocation;//城市的id

@end
#import "model.h"

/**详情页面viewmodel*/
@interface personDetailViewModel : model
@property(nonatomic)NSDictionary*service;//服务相关
@property(nonatomic)NSInteger pageView;//浏览量
@property(nonatomic)NSString*mobile;//电话号码
@property(nonatomic)NSInteger id;
@property(nonatomic)NSInteger age;//年龄
@property(nonatomic)NSString*gendar;//性别
@property(nonatomic)NSDictionary*certification;//认证相关
@property(nonatomic)NSArray*certificate;//证书
@property(nonatomic)NSDictionary*recommendInfo;//推荐的人
@property(nonatomic)NSInteger favoriteFlag;//是否喜爱的标志
@property(nonatomic) NSString *qq;
@property(nonatomic) NSString *realName;
@property(nonatomic) NSString *weChat;
@property(nonatomic) NSString *idNo;
@property(nonatomic) NSString *idNoFile;
@property(nonatomic) NSString *icon;
@property(nonatomic) NSNumber *iconId;
@property(nonatomic) NSNumber *idNoId;
@property(nonatomic) NSInteger userPost;
@property(nonatomic)NSDictionary *nativeProvince;
@property(nonatomic)NSString*rejectReason;//拒绝的理由
@property(nonatomic)NSInteger result;//推荐结果
@property(nonatomic) NSString *content;

@end
