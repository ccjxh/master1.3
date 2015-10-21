//
//  CommonAdressModel.h
//  master
//
//  Created by xuting on 15/5/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"

@interface CommonAdressModel : model

@property(nonatomic) NSInteger id;
@property(nonatomic) NSString *city;
@property(nonatomic) NSString *province;
@property(nonatomic) NSString *region;
@property(nonatomic) NSString *street;

@end
