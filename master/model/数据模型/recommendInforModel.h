//
//  recommendInforModel.h
//  master
//
//  Created by jin on 15/6/30.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"

/**推荐人信息*/
@interface recommendInforModel : model
@property(nonatomic)NSString*icon;
@property(nonatomic)NSString*realName;
@property(nonatomic)NSArray*skills;
@property(nonatomic)NSMutableDictionary*score;
@property(nonatomic)NSString*content;
@property(nonatomic)NSMutableDictionary*referrer;
@end
