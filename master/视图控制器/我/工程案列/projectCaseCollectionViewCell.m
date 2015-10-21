//
//  projectCaseCollectionViewCell.m
//  master
//
//  Created by jin on 15/6/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "projectCaseCollectionViewCell.h"

@implementation projectCaseCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)reloadData{
    self.name.text=self.model.caseName;
    self.time.text=self.model.createTime;
    NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,self.model.cover ];
    self.time.textColor=COLOR(167, 167, 167, 1);
    self.name.textColor=COLOR(50, 50, 50, 1);
    if (self.isShow==YES) {
        self.selectButton.hidden=NO;
        self.selectImage.hidden=NO;
        if (self.model.isSelected==NO) {
            self.selectImage.image=[UIImage imageNamed:@"未选中.png"];
            
        }else{
            self.selectImage.image=[UIImage imageNamed:@"已选中.png"];
            
        }
    }else{
    self.selectButton.hidden=YES;
        self.selectImage.hidden=YES;
    }
     [self.photos sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"ic_logo.png"]];
    if (!self.isExitImageBack) {
        [self.backimage removeFromSuperview];
    }
}


- (void)onclick {
    
    if (self.type==0) {
      
        if (self.model.isSelected==YES) {
            self.model.isSelected=NO;
        }else{
            self.model.isSelected=YES;
            
            if (self.block) {
                
            }
            self.block();
        }

    }
    if (self.type==1) {
    if (self.picModel.isSelect==YES) {
        self.picModel.isSelect=NO;
    }else{
        self.picModel.isSelect=YES;

    if (self.block) {
        
        }
        self.block();
        }
    }
    
}

-(void)reloadPic{
    
    [self.backimage removeFromSuperview];
    NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,self.picModel.resource];
    [self.name removeFromSuperview];
    [self.time removeFromSuperview];
    self.photos.userInteractionEnabled=YES;
    [self.photos sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"ic_logo.png"]];
    self.selectButton.userInteractionEnabled=YES;
       if (self.isShow) {
           self.selectButton.hidden=NO;
           if (self.picModel.isSelect==NO) {
            self.selectImage.image=[UIImage imageNamed:@"未选中.png"];
        
           }else{
               self.selectImage.image=[UIImage imageNamed:@"已选中.png"];
               
           }
        self.selectImage.hidden=NO;
       }else{
           self.selectButton.hidden=YES;
        self.selectImage.hidden=YES;
    }

}
- (IBAction)onclick:(id)sender {
    if (_block) {
        _block();
    }
}
@end
