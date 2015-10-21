//
//  peoplr.h
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"
/**列表界面个人信息数据模型*/
@interface peoplr : model
@property(nonatomic)NSInteger id;
@property(nonatomic)NSString*icon;
@property(nonatomic)NSString*realName;
@property(nonatomic)NSDictionary*service;
@property(nonatomic)NSString*qq;
@property(nonatomic)NSString*weChat;
@property(nonatomic)NSString*mobile;
@property(nonatomic)NSString*gendar;
@property(nonatomic)NSInteger userPost;
@property(nonatomic)NSDictionary*certification;//包含是否认证的字典
@property(nonatomic)NSInteger firstLocation;
@property(nonatomic)NSDictionary*nativeProvince;
@property (nonatomic,assign) NSInteger favoriteFlag; //判断收藏状态
@property(nonatomic)NSInteger pageView;
//@property (nonatomic,assign) NSInteger userPost; //判断是项目经理还是师傅
@end
