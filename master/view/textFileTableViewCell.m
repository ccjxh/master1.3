//
//  textFileTableViewCell.m
//  master
//
//  Created by jin on 15/9/1.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "textFileTableViewCell.h"

@implementation textFileTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)reloadData{

    self.height.constant=20;
    if ([self accountStringHeightFromString:self.content Width:SCREEN_WIDTH-80]<17) {
        
        self.height.constant=[self accountStringHeightFromString:self.content Width:SCREEN_WIDTH-80];
    }
    

}
@end
