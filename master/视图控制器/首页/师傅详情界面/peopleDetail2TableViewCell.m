//
//  peopleDetail2TableViewCell.m
//  master
//
//  Created by xuting on 15/5/27.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "peopleDetail2TableViewCell.h"


@implementation peopleDetail2TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (CGFloat ) upDateWithModel1 : (MasterDetailModel *)model
{
    NSArray *skillArr = [model.service objectForKey:@"servicerSkills"];
    if (skillArr.count != 0)
    {
        
        if (skillArr.count >= 4)
        {
            self.master_skillView.frame =  CGRectMake(45, 5, SCREEN_WIDTH-45, 80);
        }
        else
        {
            self.master_skillView.frame =  CGRectMake(45, 5, SCREEN_WIDTH-45, 40);
        }
        NSLog(@"frame = %f", self.master_skillView.frame.size.height);
        
//        self.master_payLabel.frame = CGRectMake(13, self.master_skillView.frame.size.height+100, 56, 21);
        self.master_payDescribeLabel.frame = CGRectMake(13+56, self.master_skillView.frame.size.height, SCREEN_WIDTH-70, 21);
        self.master_payDescribeLabel.text = @"暂未填写";
        self.master_payDescribeLabel.font = [UIFont systemFontOfSize:14];
        for (int i=0; i<skillArr.count; i++)
        {
            NSDictionary *dic=skillArr[i];
            UIButton *btn= [UIButton buttonWithType:UIButtonTypeSystem];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor orangeColor];
            [btn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 8;
            if (i >= 4)
            {
                btn.frame = CGRectMake((i-4)*64+12, 40, 60, 25);
            }
            else
            {
                btn.frame = CGRectMake(i*64+12, 5, 60, 25);
            }
            [self.master_skillView addSubview:btn];
        }
    }
    else
    {
       return 60;
    }
    self.master_payLabel.frame = CGRectMake(13, self.master_skillView.frame.size.height+100, 56, 21);
    
    return self.master_skillView.frame.size.height + 60;
}
@end
