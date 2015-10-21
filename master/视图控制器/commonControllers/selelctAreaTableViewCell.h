//
//  selelctAreaTableViewCell.h
//  master
//
//  Created by jin on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selelctAreaTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property(nonatomic)NSInteger type;//0省市区  1为技能
@property(nonatomic)AreaModel*model;
@property(nonatomic)skillModel*Skilmodel;
@property(nonatomic)BOOL isShowImage;
-(void)reloadData;
@end
