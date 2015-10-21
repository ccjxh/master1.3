//
//  billListTableViewCell.h
//  master
//
//  Created by jin on 15/6/2.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface billListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *skills;
@property(nonatomic)billListModel*model;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property(nonatomic)NSInteger type;//类型  0为我的下单  1为我的接单
-(void)reloadData;
@end
