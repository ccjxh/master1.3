//
//  nameViewController.h
//  master
//
//  Created by jin on 15/7/31.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface nameViewController : RootViewController
@property (weak, nonatomic) IBOutlet UITextField *name;
@property(nonatomic)NSString*origin;
@property(nonatomic,copy)void(^contentChange)(NSString*content);
@property(nonatomic)NSInteger type;//0为名字修改   1为招工职位要求  2为联系电话
@end
