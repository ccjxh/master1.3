//
//  firstTableViewCell.m
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "firstTableViewCell.h"

@implementation firstTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.swit.on=NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)valuechange:(id)sender {
    if (_block) {
        
        if (self.swit.on==NO) {
            _block(0);
        }
        else
        {
            _block(1);
        }
    }
}

@end
