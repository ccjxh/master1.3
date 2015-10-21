//
//  ModifySexViewController.h
//  master
//
//  Created by xuting on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

typedef void (^GendarValueBlock)(long gendarValue,long tag);
@interface ModifySexViewController : RootViewController

@property (nonatomic,copy) GendarValueBlock gendarValueBlock;

@end
