//
//  ModifyInfoViewController.h
//  master
//
//  Created by xuting on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

typedef void (^ModifyBasicInfoBlock)(NSString *modifyBasicInfo,long tag);
@interface ModifyInfoViewController : RootViewController

@property (weak, nonatomic) IBOutlet UITextField *modifyInfoTextField;
@property (assign,nonatomic) long index;
@property (assign,nonatomic) long flag;
@property (copy,nonatomic) NSString *content;
@property(nonatomic)NSString*oldName;//本身带出的名字
@property(nonatomic)NSString*oldMobile;//本身带出的电话
@property (nonatomic,copy) ModifyBasicInfoBlock modifyBasicInfoBlock;
@end
