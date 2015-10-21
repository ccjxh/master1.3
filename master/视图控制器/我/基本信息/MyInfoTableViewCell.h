//
//  MyInfoTableViewCell.h
//  master
//
//  Created by xuting on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalDetailModel.h"

@interface MyInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *listLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *normalButton;
@property (nonatomic,copy) PersonalDetailModel *model;
@property(nonatomic)NSInteger type;//1为个人认证的时候
@property(nonatomic,copy)void(^normalBlock)();
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toRihgt;

-(void) upDateWithModel:(long)section :(long)row :(PersonalDetailModel *)model : (NSString *)urlString :(BOOL)type;

@end
