//
//  AddCommonAddressCtl.h
//  master
//
//  Created by xuting on 15/6/4.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
typedef void (^AddCommonAddressBlock)(NSString *status);
@interface AddCommonAddressCtl : RootViewController
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailAddress;
@property (copy, nonatomic) AddCommonAddressBlock addCommonAddressBlock;
@property(nonatomic)normalAdress*model;
@property(nonatomic)NSInteger type;//0为添加   1为修改
@end
