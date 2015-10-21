//
//  hotRankCollectionViewCell.m
//  master
//
//  Created by jin on 15/10/5.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "hotRankCollectionViewCell.h"

@implementation hotRankCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.headImage.layer.cornerRadius=self.headImage.layer.bounds.size.width/2;
    self.headImage.layer.masksToBounds=YES;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    if (self=[super initWithCoder:aDecoder]) {
        
        self.headImage=[[UIImageView alloc]initWithFrame:CGRectMake(22, 15.5, 45, 45)];
        [self.contentView addSubview:self.headImage];
    }
    return self;

}

-(void)reloadData{

    self.lineView.backgroundColor=COLOR(224, 224, 224, 1);
    self.vHine.backgroundColor=self.lineView.backgroundColor;
    self.bottomLine.backgroundColor=self.lineView.backgroundColor;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",changeURL,self.model.icon]] placeholderImage:[UIImage imageNamed:@"头像.png"]];
    self.name.text=self.model.realName;
    NSString*str;
    for (NSInteger i=0; i<[[self.model.service objectForKey:@"servicerSkills"] count]; i++) {
        if (i==0) {
            str=[[self.model.service objectForKey:@"servicerSkills"][0] objectForKey:@"name"];
        }else{
        
            str=[NSString stringWithFormat:@"%@、%@",str,[[self.model.service objectForKey:@"servicerSkills"][0] objectForKey:@"name"]];
        }
    }
    self.skills.text=str;
    self.perience.text=[NSString stringWithFormat:@"%@年",[self.model.service objectForKey:@"workExperience"]];
    NSString*userPost;
    switch (self.model.userPost) {
        case 1:
            userPost=@"雇主";
            break;
            case 2:
            userPost=@"师傅";
            break;
            case 3:
            userPost=@"工长";
            break;
        default:
            break;
    }
    self.userport.text=userPost;
//    if ([[self.model.certification objectForKey:@"skill"] integerValue]==1) {
//        self.skillpicture.hidden=NO;
//    }else{
//    
//        self.skillpicture.hidden=YES;
//    }
    if (self.model.realName.length<=4) {
        self.nameWidth.constant=self.model.realName.length*12+3;
    }else{
    
        self.nameWidth.constant=30;
    }
    self.userportWidth.constant=userPost.length*12+3;
}

@end
