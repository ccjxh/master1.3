//
//  findWorkDetailTableViewCell.m
//  master
//
//  Created by jin on 15/8/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "findWorkDetailTableViewCell.h"

@implementation findWorkDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)reloadData{

    self.publicTime.textColor=COLOR(101, 101, 101, 1);
    self.couneName.textColor=self.publicTime.textColor;
    self.meet.textColor=self.publicTime.textColor;
    self.peopleCount.textColor=self.publicTime.textColor;
    self.wordAdress.textColor=self.publicTime.textColor;
    self.date.textColor=self.publicTime.textColor;
    self.count.textColor=self.publicTime.textColor;
}
@end
