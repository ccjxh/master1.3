//
//  customTableViewCell.h
//  master
//
//  Created by jin on 15/7/27.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customTableViewCell : UITableViewCell
@property ( nonatomic)  UIImageView *headImage;
@property ( nonatomic)  UILabel *name;
@property ( nonatomic)  UILabel *workType;
@property ( nonatomic)  UILabel *expence;
@property ( nonatomic)  UIImageView *rankImage;
@property ( nonatomic)  UIImageView *company;
@property ( nonatomic)  UIButton *phone;
@property ( nonatomic)  UIImageView *peopleSkill;
@property ( nonatomic)  UILabel *order;
@property(nonatomic)NSInteger type;//0为首页列表  1为推荐的人
@property(nonatomic)peoplr*model;
@property(nonatomic)NSInteger dealStatus;//是否处理
-(void)reloadData;

@end
