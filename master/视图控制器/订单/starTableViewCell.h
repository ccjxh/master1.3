//
//  starTableViewCell.h
//  master
//
//  Created by jin on 15/6/30.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface starTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *counts;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *iageview;
@property (weak, nonatomic) IBOutlet UIImageView *starFlag;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property(nonatomic)starCaseModel*model;
-(void)reloadData;
@end
