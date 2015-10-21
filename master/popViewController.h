//
//  popViewController.h
//  master
//
//  Created by jin on 15/6/1.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface popViewController : RootViewController
@property(nonatomic,copy)void(^introlduceBlock)(NSString*str);
@end
