//
//  commendTableViewCell.m
//  master
//
//  Created by jin on 15/7/9.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "commendTableViewCell.h"

@implementation commendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)reloadData{
    
    self.content.text=self.contentStr;
    NSInteger height=[self accountStringHeightFromString:self.contentStr Width:SCREEN_WIDTH-110];
    if (height<16) {
        self.height.constant=16;
    }
    
    self.height.constant=height+5;
    if (self.type==1) {
        self.topToSuperview.constant=15;
        self.topToSuperVIew1.constant=15;
    }
    
    
    
}

@end
