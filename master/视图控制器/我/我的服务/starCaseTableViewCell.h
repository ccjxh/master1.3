//
//  starCaseTableViewCell.h
//  master
//
//  Created by jin on 15/6/24.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface starCaseTableViewCell : UITableViewCell
typedef void(^addPhotos) (NSInteger type,id object);
@property(nonatomic,copy)addPhotos block;
@property(nonatomic)NSMutableArray*picArray;
@property(nonatomic)UIImage*currentImage;
@property(nonatomic)NSInteger currentIndex;
@property(nonatomic,copy)void(^openPicture)(NSInteger index);
@property(nonatomic)UINavigationController*nc;
-(void)reloadData;

@end
