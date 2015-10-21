//
//  TableViewCell.h
//  master
//
//  Created by jin on 15/6/16.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
//type 表示类型   1是新增  2删除  
typedef void(^addPhotos) (NSInteger type,id object);
@interface TableViewCell : UITableViewCell
@property(nonatomic,copy)addPhotos block;
@property(nonatomic)NSMutableArray*picArray;
@property(nonatomic)UIImage*currentImage;
-(void)reloadData;
@end
