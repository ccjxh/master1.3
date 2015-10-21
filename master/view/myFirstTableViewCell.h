//
//  myFirstTableViewCell.h
//  master
//
//  Created by jin on 15/8/16.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myFirstTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImahe;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *integrity;

@end
