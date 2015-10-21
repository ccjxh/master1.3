//
//  billListTableViewCell.m
//  master
//
//  Created by jin on 15/6/2.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "billListTableViewCell.h"

@implementation billListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)reloadData{
    
    self.name.text=[self.model.master objectForKey:@"realName"];
    if (self.type==1) {
        self.name.text=[self.model.buyer objectForKey:@"realName"];
    }
    self.address.text=[NSString stringWithFormat:@"%@%@",self.model.region,self.model.address];
    self.time.text=[NSString stringWithFormat:@"%@到%@",self.model.startTime,self.model.finishTime];
    NSString*temp;
    NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,[self.model.master objectForKey:@"icon"]];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"ic_icon_default"]];
    self.headImage.layer.masksToBounds=YES;
    self.headImage.layer.cornerRadius=30;
    for (NSInteger i=0; i<self.model.skills.count; i++) {
        NSDictionary*dict=self.model.skills[i];
        skillModel*tempModel=[[skillModel alloc]init];
        [tempModel setValuesForKeysWithDictionary:dict];
        if (i==0) {
            temp=tempModel.name;
        }else{
        
            temp=[NSString stringWithFormat:@"%@、%@",temp,tempModel.name];
        }
    }
    if (!temp) {
        temp=@"";
    }
    self.skills.text=temp;
}
@end
