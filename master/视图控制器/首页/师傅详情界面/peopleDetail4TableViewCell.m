//
//  peopleDetail4TableViewCell.m
//  master
//
//  Created by xuting on 15/5/28.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "peopleDetail4TableViewCell.h"

@implementation peopleDetail4TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat ) upDateWithModel : (MasterDetailModel *)model
{
    CGFloat height1 = 0;
    NSArray *serviceRegionsArr = [model.service objectForKey:@"serviceRegions"];
    NSString *region=@"";
    
    for (int i=0; i<serviceRegionsArr.count; i++)
    {
        NSString *str = serviceRegionsArr[i];
        region = [region stringByAppendingFormat:@"%@、",str];
    }
    self.master_serviceRegion.numberOfLines = 0;
    self.master_serviceRegion.text = region;
    [model setContent:region];
    height1 = model.contentHeight;
    self.master_serviceRegion.frame = CGRectMake(80, 10, 222, model.contentHeight);
    if (serviceRegionsArr.count == 0)
    {
        self.master_serviceRegion.text = @"暂未填写!";
        self.master_serviceRegion.font = [UIFont systemFontOfSize:14];
        self.master_serviceRegion.textColor = [UIColor lightGrayColor];
        return 30;
    }
    else
    {
         return height1 ;
    }
   
}

@end
