//
//  CommitOrderModel.h
//  master
//
//  Created by xuting on 15/6/3.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"

@interface CommitOrderModel : model

@property (nonatomic,copy) NSString *serviceRegionId;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *skillIds;
@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *finishTime;
@property (nonatomic,copy) NSString *contract;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *masterId;

@end
