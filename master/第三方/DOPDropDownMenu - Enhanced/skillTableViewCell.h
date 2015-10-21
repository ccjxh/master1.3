//
//  skillTableViewCell.h
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^skillBlock)(NSMutableArray*skillArray);
@interface skillTableViewCell : UITableViewCell
@property(nonatomic,copy)skillBlock block;
@property(nonatomic)NSMutableDictionary*selectedDic;
-(void)reloadData;
@end
