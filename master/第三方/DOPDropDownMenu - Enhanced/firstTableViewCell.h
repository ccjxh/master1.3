//
//  firstTableViewCell.h
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^switStatus)(NSInteger ststus);
@interface firstTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *swit;
@property(nonatomic,copy)switStatus block;
@end
