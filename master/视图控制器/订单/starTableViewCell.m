//
//  starTableViewCell.m
//  master
//
//  Created by jin on 15/6/30.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "starTableViewCell.h"

@implementation starTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)reloadData{
    self.name.text=self.model.caseName;
    if (self.model.type!=1) {
        self.starFlag.hidden=YES;
    }else{
        self.starFlag.hidden=NO;

    }
    NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,self.model.cover];
    [self.iageview sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""]];
    self.date.text=self.model.createTime;
    self.counts.text=[NSString stringWithFormat:@"(%lu)张",self.model.totalPhoto];
    
}

@end
