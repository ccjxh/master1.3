//
//  recommendViewController.h
//  master
//
//  Created by jin on 15/6/1.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"
typedef void(^netBlock)(BOOL isrefer);
@interface recommendViewController : RootViewController
@property(nonatomic)NSInteger type;//寻求类型
@property(nonatomic,copy)netBlock block;
@end
