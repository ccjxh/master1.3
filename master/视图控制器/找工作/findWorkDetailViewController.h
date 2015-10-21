//
//  findWorkDetailViewController.h
//  master
//
//  Created by jin on 15/8/26.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface findWorkDetailViewController : RootViewController
@property(nonatomic)NSInteger id;
@property(nonatomic)NSInteger type;//0为找工作push   1为我的发布push
@property(nonatomic,copy)void(^removeBlock)(NSInteger ID);
@property(nonatomic)NSString*title;
@end
