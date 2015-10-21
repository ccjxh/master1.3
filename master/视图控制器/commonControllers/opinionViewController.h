//
//  opinionViewController.h
//  master
//
//  Created by jin on 15/7/31.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
typedef void (^opinionBlock)(BOOL isRefersh);
typedef void (^content)(NSString*content);
@interface opinionViewController : RootViewController

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextView *tx;
@property(nonatomic)NSString*origin;//原始数据
@property(nonatomic)NSString*title;//标题
@property(nonatomic)NSInteger type;//0为服务描述  1为举报   2为需求人数
@property(nonatomic)NSInteger limitCount;//限制的字数
@property(nonatomic)NSInteger id;//当为举报按钮推出本页时需传入举报人id
@property(nonatomic,copy)opinionBlock block;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property(nonatomic,copy)content contentBlock;
@end
