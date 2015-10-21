//
//  peopleDetail3TableViewCell.h
//  master
//
//  Created by xuting on 15/5/28.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterDetailModel.h"

@interface peopleDetail3TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *master_mobile;

- (void) upDateWithModel : (MasterDetailModel *)model;
@end
