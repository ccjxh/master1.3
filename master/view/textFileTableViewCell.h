//
//  textFileTableViewCell.h
//  master
//
//  Created by jin on 15/9/1.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface textFileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextField *tx;
@property(nonatomic,copy)NSString*content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property(nonatomic)NSInteger type;
-(void)reloadData;
@end
