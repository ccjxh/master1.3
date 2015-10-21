//
//  customTableViewCell.m
//  master
//
//  Created by jin on 15/7/27.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "customTableViewCell.h"

@implementation customTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    if (self=[super initWithCoder:aDecoder]) {
        self.headImage=[[UIImageView alloc]initWithFrame: CGRectMake(5, 5, 60, 60)];
        self.name=[[UILabel alloc]initWithFrame:CGRectMake(65, 5, 40, 20)];
        self.workType=[[UILabel alloc]initWithFrame: CGRectMake(self.name.frame.origin.x+self.name.frame.size.width+100,5 ,65, 20)];
        self.peopleSkill=[[UIImageView alloc]initWithFrame:CGRectMake(self.workType.frame.origin.x+self.workType.frame.size.width+5,5 , 40, 20)];
        self.company=[[UIImageView alloc]initWithFrame: CGRectMake(self.peopleSkill.frame.origin.x+self.peopleSkill.frame.size.width+5,5 , 40, 20)];
        self.expence=[[UILabel alloc]initWithFrame: CGRectMake(self.company.frame.origin.x+self.company.frame.size.width+5,5 , 40, 20)];
        self.rankImage=[[UIImageView alloc]initWithFrame: CGRectMake(65, 30, 45, 25)];
        self.order=[[UILabel alloc]initWithFrame: CGRectMake(self.rankImage.frame.origin.x+self.rankImage.frame.size.width+5,5 , 40, 20)];
        self.order.font=[UIFont systemFontOfSize:13];
        [self addSubview:self.headImage];
        [self addSubview:self.name];
        [self addSubview:self.workType];
        [self addSubview:self.peopleSkill];
        [self addSubview:self.company];
        [self addSubview:self.expence];
        [self addSubview:self.rankImage];
        [self addSubview:self.order];
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)reloadData{

    [self setupColor];
    [self setupSkill];
    if (self.model.icon!=nil) {
        NSString*urlString=[changeURL stringByAppendingString:self.model.icon];
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:urlString]];
        
    }else{
        
        self.headImage.image=[UIImage imageNamed:@"ic_icon_default"];
    }
    self.name.text=self.model.realName;
    NSString *str = self.model.realName;
    CGSize size = [str sizeWithFont:self.name.font constrainedToSize:CGSizeMake(MAXFLOAT, self.name.frame.size.height)];
   
    //根据计算结果重新设置UILabel的尺寸
//    [label setFrame:CGRectMake(0, 10, size.width, 20)];
//    label.text = str;
   
    NSInteger exAge=[[self.model.service objectForKey:@"workExperience"] integerValue];
    self.expence.text=[NSString stringWithFormat:@"%ld年",(long)exAge];
    if (self.type==1) {
        self.expence.textColor=[UIColor clearColor];
    }
    if ([[self.model.certification objectForKey:@"personal"] integerValue]==1) {
        
        self.peopleSkill.image=[UIImage imageNamed:@"ic_personal"];
    }
    if ([[self.model.certification objectForKey:@"company"] integerValue]==1) {
        self.peopleSkill.image=[UIImage imageNamed:@"ic_compay"];
    }
    if ([[self.model.certification objectForKey:@"personal"] integerValue]==0&&[[self.model.certification objectForKey:@"company"] integerValue]==0) {
        self.peopleSkill.frame=CGRectMake(self.peopleSkill.frame.origin.x, self.peopleSkill.frame.origin.y, 0, 0);
    }
    if ([[self.model.certification objectForKey:@"skill"] integerValue]==1) {
        self.company.image=[UIImage imageNamed:@"ic_skill"];
    }else{
        self.company.frame=CGRectMake(self.company.frame.origin.x, self.company.frame.origin.y, 0, 0);
    }
    
    NSInteger starCount=[[self.model.service objectForKey:@"star"] integerValue];
    NSString*imagename=[NSString stringWithFormat:@"ic_star_%ld",(long)starCount];
    self.rankImage.image=[UIImage imageNamed:imagename];
    self.order.text=[NSString stringWithFormat:@"%ld人预定",(long)[[self.model.service objectForKey:@"orderCount"] integerValue]];
    if (self.type==1) {
        self.phone.hidden=YES;
//        self.Backimageview.hidden=YES;
    }
//     self.name.frame=CGRectMake(self.name.frame.origin.x, self.name.frame.origin.y, self.model.realName.length*18, 20);
//    
    self.workType.frame= CGRectMake(self.name.frame.origin.x+self.model.realName.length*18,5 ,65, 20);
//    self.peopleSkill.frame=CGRectMake(self.workType.frame.origin.x+self.workType.frame.size.width+5,5 , 40, 20);
//    self.company.frame= CGRectMake(self.peopleSkill.frame.origin.x+self.peopleSkill.frame.size.width+5,5 , 40, 20);
//    self.expence.frame=CGRectMake(self.company.frame.origin.x+self.company.frame.size.width+5,5 , 40, 20);
//    self.rankImage.frame= CGRectMake(65, 30, 45, 25);
//    self.order.frame=CGRectMake(self.rankImage.frame.origin.x+self.rankImage.frame.size.width+5,5 , 40, 20);
}



-(void)setupColor
{
    self.name.font=[UIFont boldSystemFontOfSize:15];
    self.workType.font=[UIFont systemFontOfSize:15];
    self.workType.textColor=COLOR(153, 153, 153, 1);
    self.name.textColor=COLOR(51, 51, 51, 1);
    self.expence.textColor=COLOR(153, 153, 153, 1);
    self.order.textColor=COLOR(51, 51, 51, 1);
    self.phone.backgroundColor=COLOR(245, 245, 245, 1);
    self.headImage.layer.masksToBounds=YES;
    self.headImage.layer.cornerRadius=self.headImage.frame.size.width/2;
}

-(void)setupSkill
{
    NSInteger width=(SCREEN_WIDTH-60-self.phone.frame.size.width-25-20)/4;
    NSArray*Array=[self.model.service objectForKey:@"servicerSkills"];
    for (NSInteger i=0; i<Array.count; i++) {
        if (i<4) {
            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(75+i%4*(width+5), 55+i/4*25, width, 20)];
            label.text=[[self.model.service objectForKey:@"servicerSkills"][i] objectForKey:@"name"];
            label.textColor=[UIColor orangeColor];
            label.font=[UIFont systemFontOfSize:12];
            label.layer.borderColor=[[UIColor orangeColor]CGColor];
            label.textAlignment=NSTextAlignmentCenter;
            label.lineBreakMode=NSLineBreakByTruncatingTail;
            label.layer.cornerRadius=10;
            label.layer.borderWidth=1;
            [self addSubview:label];
        }
    }
    
}


@end
