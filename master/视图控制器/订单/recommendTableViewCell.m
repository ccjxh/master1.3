//
//  recommendTableViewCell.m
//  master
//
//  Created by jin on 15/6/2.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "recommendTableViewCell.h"

@implementation recommendTableViewCell

- (void)awakeFromNib {
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)reloadData{
    self.stars.image=[UIImage imageNamed:[NSString stringWithFormat:@"ic_star_%lu",(long)self.model.star]];
    self.name.text=self.model.user;
    self.content.text=self.model.content;
    self.time.text=self.model.createTime;
    NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,self.model.icon];
       [self.headImage sd_setImageWithURL:[NSURL URLWithString:urlString]];
    [self setimage];
    if (self.model.acceptSkill.count!=0) {
        NSString*skillString;
        for (NSInteger i=0; i<self.model.acceptSkill.count; i++) {
            if (i==0) {
                skillString=[NSString stringWithFormat:@"认可的技能:%@",[self.model.acceptSkill[i] objectForKey:@"name"]];
            }else{
                skillString=[NSString stringWithFormat:@"%@、%@",skillString,[self.model.acceptSkill[i] objectForKey:@"name" ]];
            }
        }
        self.skill.text=skillString;
        CGFloat height=[self accountStringHeightFromString:skillString Width:SCREEN_WIDTH-70-15];
        self.skill.frame=CGRectMake(self.skill.frame.origin.x, self.skill.frame.origin.y, self.skill.frame.size.width, height);
    }
}


-(void)setimage{
    NSInteger space=(SCREEN_WIDTH-140-20)/3;
    for (NSInteger i=0; i<self.model.picCase.count; i++) {
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(10+i%4*(40+5),(i/4)*45 , 40, 40)];
        NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,self.model.picCase[i]];
        imageview.tag=1;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pictureDisplay:)];
        imageview.userInteractionEnabled=YES;
        [imageview addGestureRecognizer:tap];
        [imageview sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"ic_icon_default"]];
        [self.backView addSubview:imageview];
    }
}


-(void)pictureDisplay:(UITapGestureRecognizer*)temp{

    UITapGestureRecognizer*tap=(UITapGestureRecognizer*)temp;
    NSInteger tag=tap.view.superview.tag;
    [PhotoBroswerVC show:self.vc type:3 index:tag photoModelBlock:^NSArray *{
        NSMutableArray*Array=[[NSMutableArray alloc]init];
        
        for (NSInteger i=0; i<self.model.picCase.count; i++) {
            
            NSString*temp=[NSString stringWithFormat:@"%@%@",changeURL,self.model.picCase[i]];
            [Array addObject:temp];
        }
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:Array.count];
        for (NSUInteger i = 0; i< Array.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.title = @"简介:";
            pbModel.desc = self.model.content;
            pbModel.image_HD_U = Array[i];
            
            //源frame
            
//            projectCaseCollectionViewCell*cell=(projectCaseCollectionViewCell*)[collectionView  dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath] ;
            //            UIImageView *imageV =(UIImageView *) weakSelf.contentView.subviews[i];
            UIImageView*imageview=(UIImageView*)tap.view.superview;
            pbModel.sourceImageView = imageview;
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
    


}

@end
