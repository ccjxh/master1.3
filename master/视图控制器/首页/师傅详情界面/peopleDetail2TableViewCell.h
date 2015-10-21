//
//  peopleDetail2TableViewCell.h
//  master
//
//  Created by xuting on 15/5/27.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterDetailModel.h"

@interface peopleDetail2TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *master_skillView;
@property (weak, nonatomic) IBOutlet UILabel *master_payLabel;
@property (weak, nonatomic) IBOutlet UILabel *master_payDescribeLabel;

- (CGFloat) upDateWithModel1 : (MasterDetailModel *)model;
@end
