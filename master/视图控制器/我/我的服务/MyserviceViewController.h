//
//  MyserviceViewController.h
//  master
//
//  Created by jin on 15/5/21.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface MyserviceViewController : RootViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property(nonatomic)NSInteger type ;//0为项目经理  1为包工头
@end
