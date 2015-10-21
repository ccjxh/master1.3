//
//  normalAdress.h
//  master
//
//  Created by jin on 15/7/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"
/**常用地址收藏*/
@interface normalAdress : model
@property(nonatomic)NSInteger id;
@property(nonatomic)NSDictionary*region;
@property(nonatomic)NSDictionary*city;
@property(nonatomic)NSDictionary*province;
@property(nonatomic)NSString*street;
@end
