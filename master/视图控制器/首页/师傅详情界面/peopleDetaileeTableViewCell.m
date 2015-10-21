//
//  peopleDetaileeTableViewCell.m
//  master
//
//  Created by xuting on 15/5/30.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "peopleDetaileeTableViewCell.h"

@implementation peopleDetaileeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)callMobile:(id)sender {
    
    if (self.master_mobile.titleLabel.text.length != 0)
    {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.master_mobile.titleLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

- (void) upDateWithModel3 : (MasterDetailModel *)model
{
    
    NSString*str=model.mobile;
    [self.master_mobile setTitle:str forState:UIControlStateNormal];
    self.master_workStatus.text = [model.service objectForKey:@"workStatus"];
    if (model.nativeProvince!=nil) {
        self.master_region.text = [model.nativeProvince objectForKey:@"name"];
    }
}

@end
