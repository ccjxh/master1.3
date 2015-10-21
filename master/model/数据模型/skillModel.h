//
//  skillModel.h
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"
/**技能数据模型*/

@interface skillModel : model
@property(nonatomic)NSString*name;
@property(nonatomic)NSInteger id;
@property(nonatomic)BOOL isSelect;//是否是认证技能
@property(nonatomic)BOOL isOwer;//是否选择
@end
