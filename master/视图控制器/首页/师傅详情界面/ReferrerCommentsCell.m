//
//  ReferrerCommentsCell.m
//  master
//
//  Created by xuting on 15/6/2.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "ReferrerCommentsCell.h"

@implementation ReferrerCommentsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(CGFloat) updataWithModel:(MasterDetailModel *)model
{
    self.master_comments.text = @"111";
    [model setContent:self.master_comments.text];
    return model.contentHeight;
    
}
@end
