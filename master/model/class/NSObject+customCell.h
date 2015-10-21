//
//  NSObject+customCell.h
//  master
//
//  Created by jin on 15/5/29.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (customCell)
//服务介绍
-(UITableViewCell*)getserviceIntrolduceCellWithTableview:(UITableView*)tableView;
//证书
-(UITableViewCell*)getCertainCellWithTableview:(UITableView*)tableView;
//从业时间
-(UITableViewCell*)getStartTimeWithTableview:(UITableView*)tableView;
//服务区域
-(UITableViewCell*)getServiceCellWithTableview:(UITableView*)tableView;
//技能
-(UITableViewCell*)getSkillCellWithTableview:(UITableView*)tableView;
@end
