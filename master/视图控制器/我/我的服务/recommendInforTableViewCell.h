//
//  recommendInforTableViewCell.h
//  master
//
//  Created by jin on 15/6/30.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "recommendInforModel.h"
@interface recommendInforTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *skill;
//@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *skillscore;
@property (weak, nonatomic) IBOutlet UILabel *serviec;
@property (weak, nonatomic) IBOutlet UILabel *personal;
@property(nonatomic)recommendInforModel*model;
@property (weak, nonatomic) IBOutlet UILabel *content;
-(void)reloadData;
@end
