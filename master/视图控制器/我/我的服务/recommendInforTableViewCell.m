//
//  recommendInforTableViewCell.m
//  master
//
//  Created by jin on 15/6/30.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "recommendInforTableViewCell.h"

@implementation recommendInforTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)reloadData
{
    NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,[self.model.referrer objectForKey:@"realName"]];
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"ic_icon_default"]];
    self.name.text=[NSString stringWithFormat:@"推荐人:%@",[self.model.referrer objectForKey:@"realName"]];
    NSString*skillString;
    for (NSInteger i=0; i<self.model.skills.count; i++) {
        if (i==0) {
            skillString=[NSString stringWithFormat:@"认可技能:%@",[self.model.skills[i] objectForKey:@"name"]];
        }else{
        
            skillString=[NSString stringWithFormat:@"%@%@、",skillString,[self.model.skills[i] objectForKey:@"name"]];
        }
    }
    
    self.skill.text=skillString;
    self.skill.frame=CGRectMake(self.skill.frame.origin.x, self.skill.frame.origin.y, self.skill.frame.size.width, [self accountStringHeightFromString:skillString Width:self.skill.frame.size.width]);
    self.skillscore.text=[NSString stringWithFormat:@"专业技能:%@",[self.model.score objectForKey:@"专业技能"]];
    self.personal.text=[NSString stringWithFormat:@"个人诚信:%@",[self.model.score objectForKey:@"个人诚信"]];
    self.serviec.text=[NSString stringWithFormat:@"服务态度:%@",[self.model.score objectForKey:@"服务态度"]];
    self.content.text=self.model.content;
}

@end
