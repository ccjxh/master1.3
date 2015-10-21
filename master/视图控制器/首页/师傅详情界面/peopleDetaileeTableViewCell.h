//
//  peopleDetaileeTableViewCell.h
//  master
//
//  Created by xuting on 15/5/30.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterDetailModel.h"

@interface peopleDetaileeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *master_mobile;
@property (weak, nonatomic) IBOutlet UILabel *master_region;
@property (weak, nonatomic) IBOutlet UILabel *master_workStatus;


- (void) upDateWithModel3 : (MasterDetailModel *)model;

-(void)reloadData;

@end
