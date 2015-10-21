//
//  selelctAreaTableViewCell.m
//  master
//
//  Created by jin on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "selelctAreaTableViewCell.h"

@implementation selelctAreaTableViewCell

-(void)setIsShowImage:(BOOL)isShowImage{

    _isShowImage=isShowImage;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)reloadData{
    if (self.type==0) {
    self.name.text=self.model.name;
    if (self.model.isselect==YES) {
        self.imageview.image=[UIImage imageNamed:@"已选中"];
    }
    else{
        self.imageview.image=[UIImage imageNamed:@"未选中"];
        }
    }
    else if (self.type==1){
        self.name.text=self.Skilmodel.name;
        
        if (self.Skilmodel.isOwer==YES) {
            self.imageview.image=[UIImage imageNamed:@"已选中"];
        }
        else{
            self.imageview.image=[UIImage imageNamed:@"未选中"];
        }
    }
    if (_isShowImage==NO) {
        self.imageview.hidden=YES;
    }else{
    
        self.imageview.hidden=NO;
    }
}

@end
