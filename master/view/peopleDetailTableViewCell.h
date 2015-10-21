//
//  peopleDetailTableViewCell.h
//  master
//
//  Created by xuting on 15/5/26.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterDetailModel.h"
#import "personDetailViewModel.h"
/*
 详情界面个人基本信息cell
 
 **/

@interface peopleDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *master_headImage;
@property (weak, nonatomic) IBOutlet UILabel *master_name;
@property (weak, nonatomic) IBOutlet UILabel *master_age;
@property (weak, nonatomic) IBOutlet UIImageView *master_star;
@property (weak, nonatomic) IBOutlet UILabel *master_workExperience;
@property (weak, nonatomic) IBOutlet UILabel *refreshLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorImage;
@property (weak, nonatomic) IBOutlet UILabel *authorWay;
@property (weak, nonatomic) IBOutlet UILabel *master_orderCount;
@property (weak, nonatomic) IBOutlet UILabel *master_userPost;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property(nonatomic,copy)void(^displayBlock)(NSString*urlString);

- (void) upDateWithModel : (personDetailViewModel *)model;
@end
