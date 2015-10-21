//
//  otherMessageTableViewCell.h
//  master
//
//  Created by jin on 15/9/8.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageTextView.h"
#import "rootTableViewCell.h"

@interface otherMessageTableViewCell : rootTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *date;
//@property(nonatomic)EMMessage*model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textviewHeight;
@property (weak, nonatomic) IBOutlet XHMessageTextView *tx;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;
-(void)reloadData;
@end
