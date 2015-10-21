//
//  MasterDetailModel.h
//  master
//
//  Created by xuting on 15/5/27.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"

@interface MasterDetailModel : model

@property(nonatomic,strong) NSDictionary *service;
@property(nonatomic,copy) NSString *qq;
@property(nonatomic,copy) NSString *realName;
@property(nonatomic,copy) NSString *gendar;
@property(nonatomic,copy) NSString *weChat;
@property(nonatomic,copy) NSString *mobile;
@property(nonatomic,copy) NSString *idNo;
@property(nonatomic,copy) NSNumber *id;
@property(nonatomic,copy) NSNumber *age;
@property(nonatomic,copy) NSString *idNoFile;
@property(nonatomic,copy) NSString *icon;
@property(nonatomic,copy) NSNumber *iconId;
@property(nonatomic,copy) NSNumber *idNoId;
@property(nonatomic,strong) NSDictionary *certification;
@property(nonatomic,assign) NSInteger userPost;
@property(nonatomic,strong)NSDictionary *nativeProvince;
@property(nonatomic)NSString*rejectReason;//拒绝的理由
//@property(nonatomic,copy) NSString *workStatus;
//@property(nonatomic,copy) NSNumber *workExperience;
//@property(nonatomic,copy) NSString *star;
@property(nonatomic)NSInteger result;//推荐结果
@property(nonatomic) NSString *content;
@property(nonatomic)NSInteger pageView;
@property (nonatomic,assign) CGFloat contentHeight;

@end
