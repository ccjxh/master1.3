//
//  peopleDetail3TableViewCell.m
//  master
//
//  Created by xuting on 15/5/28.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "peopleDetail3TableViewCell.h"
#import "Toast+UIView.h"

@implementation peopleDetail3TableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)callMobile:(id)sender {
    if (_master_mobile.text != nil) {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_master_mobile.text]]];
    } 
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) upDateWithModel : (MasterDetailModel *)model
{
    self.master_mobile.text = model.mobile;
    
}
@end
