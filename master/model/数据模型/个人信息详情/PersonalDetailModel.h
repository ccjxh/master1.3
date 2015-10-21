//
//  PersonalDetailModel.h
//  master
//
//  Created by xuting on 15/5/26.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"

@interface PersonalDetailModel : model

@property (nonatomic,copy) NSNumber *id; //个人信息id
@property (nonatomic,copy) NSString *gendar; //性别
@property (nonatomic,copy) NSString *qq;  //qq
@property (nonatomic,copy) NSString *weChat; //微信号
@property (nonatomic,copy) NSString *realName; //姓名
@property (nonatomic,copy) NSString *mobile; //电话号码
@property (nonatomic,copy) NSString *idNo;  //身份证号码
@property (nonatomic,copy) NSString *iconId;  //头像id
@property (nonatomic,copy) NSString *idNoId;  //身份证正面图片id
@property(nonatomic,copy)NSString*idNoBackFileId;//身份证背面图片网址
@property(nonatomic,copy)NSString*idNoBackFile;//身份证背面站片id
@property (nonatomic,strong) NSDictionary *certification;
@property (nonatomic,copy) NSString *icon; //图片地址
@property (nonatomic,copy) NSString *idNoFile;
@property (nonatomic,assign) NSInteger regionId;
@property(nonatomic)NSString*birthday;//生日
@property (nonatomic,copy) NSString *region;
@property (nonatomic,strong) NSMutableDictionary *nativeProvince;
@property (nonatomic,strong) NSMutableDictionary *nativeCity;
@property (nonatomic,strong) NSMutableDictionary *nativeRegion;
@property(nonatomic)NSInteger personal;
@property(nonatomic)NSInteger company;
@property(nonatomic)NSInteger skill;
@property(nonatomic)NSInteger certifyType;//认证类型
@property(nonatomic)NSInteger skillState;//技能认证状态
@property(nonatomic)NSInteger companyState;//公司认证转台
@property(nonatomic)NSInteger personalState;//个人认证状态
@property(nonatomic)NSString*adress;//籍贯

@end
