//
//  peopleDetailTableViewCell.m
//  master
//
//  Created by xuting on 15/5/26.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "peopleDetailTableViewCell.h"

@implementation peopleDetailTableViewCell
{

    NSString*_urlString;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) upDateWithModel:(personDetailViewModel *)model
{
    
    //显示头像
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",changeURL,model.icon]];
    [self.master_headImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:headImageName]];
    [self.master_headImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.master_headImage.contentMode =  UIViewContentModeScaleAspectFill;
    self.master_headImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.master_headImage.clipsToBounds=YES;
    self.master_headImage.layer.masksToBounds=YES;
    self.master_headImage.layer.cornerRadius=self.master_headImage.frame.size.width/2;
    if (model.icon) {
        
        _urlString=model.icon;
        
    }
    self.master_headImage.userInteractionEnabled=YES;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayPhoto)];
    tap.numberOfTapsRequired=1;
    [self.master_headImage addGestureRecognizer:tap];
    //姓名
    self.master_name.text = model.realName;
    self.master_name.textColor=COLOR(64, 64, 64, 1);
    self.authorWay.textColor=COLOR(100, 100, 100, 1);
//    self.master_workExperience.textColor=COLOR(42, 42, 42, 1);
    CGFloat width;
    width=model.realName.length*16;
    if (model.realName.length<1) {
        width=1*16;
    }
    if (model.realName.length>4) {
        width=4*16;
    }
    self.width.constant=width;
    
    
    //年龄
    self.master_age.text = [NSString stringWithFormat:@"%lu岁",model.age];
    //工作经验
    if ([model.service objectForKey:@"workExperience"] == 0)
    {
        self.master_workExperience.text = @"";
    }
    else
    {
        self.master_workExperience.text = [NSString stringWithFormat:@"%@年",[model.service objectForKey:@"workExperience"]];
    }
    //更新时间
    self.refreshLabel.text = model.service[@"refreshed"];
    //浏览量
    self.master_orderCount.text = [NSString stringWithFormat:@"%ld",model.pageView];
    
    //认证方式
    if ([[model.certification objectForKey:@"personal"] integerValue] == 1){
        self.authorImage.image = [UIImage imageNamed:@"skill.png"];
        self.authorWay.text = @"个人认证";
    }
    else if([[model.certification objectForKey:@"company"] integerValue] == 1)
    {
        self.authorImage.image = [UIImage imageNamed:@"ic_compay.png"];
        self.authorWay.text = @"公司认证";
    }else{
        self.authorImage.image=[UIImage imageNamed:@"个"];
    }
    if([[model.certification objectForKey:@"skill"] integerValue] == 1)
    {
        self.authorImage.image = [UIImage imageNamed:@"ic_skill.png"];
        self.authorWay.text = @"技能认证";
    }
    
    if ([[model.certification objectForKey:@"personal"] integerValue] == 0) {
        self.authorImage.hidden=YES;
        self.authorWay.hidden=YES;
    }
    //星级评价
    switch ([[model.service objectForKey:@"star"] intValue])
    {
        case 0:
            [self.master_star setImage:[UIImage imageNamed:@"ic_star_0.png"]];
            break;
        case 1:
            [self.master_star setImage:[UIImage imageNamed:@"ic_star_1.png"]];
            break;
        case 2:
            [self.master_star setImage:[UIImage imageNamed:@"ic_star_2.png"]];
            break;
        case 3:
            [self.master_star setImage:[UIImage imageNamed:@"ic_star_3.png"]];
            break;
        case 4:
            [self.master_star setImage:[UIImage imageNamed:@"ic_star_4.png"]];
            break;
        case 5:
            [self.master_star setImage:[UIImage imageNamed:@"ic_star_5.png"]];
            break;
        default:
            break;
    }
    //用户类型
    switch (model.userPost)
    {
            
        case 1:
            self.master_userPost.text = @"项目经理";
            break;
        case 2:
            self.master_userPost.text = @"师傅";
            break;
        case 3:
            self.master_userPost.text = @"工长";
            break;
        case 4:
            break;
        default:
            break;
    }
    
    if (model.gendar) {
        if ([model.gendar isEqualToString:@"男"]==YES) {
            self.sexImage.image=[UIImage imageNamed:@"男"];
        }else{
        self.sexImage.image=[UIImage imageNamed:@"女"];
        
        }
    }else{
    self.sexImage.image=[UIImage imageNamed:@"男"];
    
    }
    
    //    self.typeWidth.constant=self.master_userPost.text.length*15;
}


-(void)displayPhoto{

    if (_urlString) {
        
        NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,_urlString];
    if (self.displayBlock) {
        self.displayBlock(urlString);
        }
    }

}

@end
