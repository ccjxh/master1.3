//
//  commendTableViewCell.h
//  master
//
//  Created by jin on 15/7/9.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property(nonatomic)NSString*contentStr;//内容数组
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToSuperview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToSuperVIew1;
@property(nonatomic)NSInteger type;//0为默认类型   1为自定义高度类型
-(void)reloadData;
@end
