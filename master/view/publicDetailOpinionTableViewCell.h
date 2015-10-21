//
//  publicDetailOpinionTableViewCell.h
//  master
//
//  Created by jin on 15/8/28.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface publicDetailOpinionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;

@end
