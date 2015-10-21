//
//  workStatusViewController.h
//  master
//
//  Created by jin on 15/6/1.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface workStatusViewController : RootViewController
@property(nonatomic,copy)void(^workStatusBlock)(NSInteger type,NSString*str,NSString*dates);
@end
