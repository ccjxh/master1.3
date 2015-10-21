//
//  ReferrerCommentsCell.h
//  master
//
//  Created by xuting on 15/6/2.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterDetailModel.h"

@interface ReferrerCommentsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *master_comments;
-(CGFloat) updataWithModel : (MasterDetailModel *)model;
@end
