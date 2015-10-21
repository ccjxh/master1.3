//
//  starModel.h
//  master
//
//  Created by jin on 15/6/2.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"
/**评论模型*/
@interface starModel : model
@property(nonatomic)NSInteger id;
@property(nonatomic)NSString*user;
@property(nonatomic)NSString*icon;
@property(nonatomic)NSString*createTime;
@property(nonatomic)NSInteger star;
@property(nonatomic)NSString*content;
@property(nonatomic)NSArray*picCase;//图片数组
@property(nonatomic)NSDictionary*reply;
@property(nonatomic)NSArray*acceptSkill;//认可的技能数组
@end
