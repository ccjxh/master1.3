//
//  starCaseModel.h
//  master
//
//  Created by jin on 15/6/24.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"
/**明星工程数据模型*/
@interface starCaseModel : model
@property(nonatomic)NSInteger id;
@property(nonatomic)NSString*caseName;
@property(nonatomic)NSString*cover;//封面地址
@property(nonatomic)NSInteger totalPhoto;
@property(nonatomic)NSString*introduce;
@property(nonatomic)NSInteger type;//类型  1为明星工程
@property(nonatomic)NSString*createTime;
@end
