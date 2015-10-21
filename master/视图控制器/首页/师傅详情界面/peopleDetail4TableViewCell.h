//
//  peopleDetail4TableViewCell.h
//  master
//
//  Created by xuting on 15/5/28.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterDetailModel.h"

@interface peopleDetail4TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *master_serviceRegion;

- (CGFloat) upDateWithModel : (MasterDetailModel *)model;
@end
