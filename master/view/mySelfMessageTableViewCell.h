//
//  mySelfMessageTableViewCell.h
//  master
//
//  Created by jin on 15/9/9.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageTextView.h"
#import "rootTableViewCell.h"


@interface mySelfMessageTableViewCell :rootTableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backHeight;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIImageView *backImahe;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
//@property(nonatomic)EMMessage*model;
-(void)reloadData;
@end
