//
//  findWorkDetailTableViewCell.h
//  master
//
//  Created by jin on 15/8/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface findWorkDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *peopleCount;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *pay;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *publicTime;
@property (weak, nonatomic) IBOutlet UILabel *meet;
@property (weak, nonatomic) IBOutlet UILabel *couneName;
@property (weak, nonatomic) IBOutlet UILabel *wordAdress;
@property (weak, nonatomic) IBOutlet UILabel *unit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHeight;
-(void)reloadData;
@end
