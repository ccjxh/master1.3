//
//  peojectCaseModel.h
//  master
//
//  Created by jin on 15/6/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"
/**工程案例数据模型*/
@interface peojectCaseModel : model
@property(nonatomic)NSInteger id;
@property(nonatomic)NSString* caseName;
@property(nonatomic)NSString*cover;
@property(nonatomic)NSInteger totalPhoto;
@property(nonatomic)NSString*createTime;
@property(nonatomic)NSString*introduce;
@property(nonatomic)NSInteger type;  //1为明星成功   2为普通工程
@property(nonatomic)BOOL isSelected;//删除状态
@end
