//
//  starCaseTableViewCell.m
//  master
//
//  Created by jin on 15/6/24.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "starCaseTableViewCell.h"
#import "projectCastDetailViewController.h"

@implementation starCaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

//-(void)add{
//    
//    
//    
//    if (self.block) {
//        
//        self.block(1,nil);
//    }
//}

-(void)dele{
    
    if (self.block) {
        self.block(2,_currentImage);
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



-(void)reloadData{
    UIView*view=(id)[self viewWithTag:21];
    if (view) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:self.bounds];
    view.tag=21;
    view.userInteractionEnabled=YES;
    NSInteger width=(SCREEN_WIDTH-40)/4;
    for (NSInteger i=0; i<self.picArray.count; i++) {
        starCaseModel*model=_picArray[i];
        UIImageView*imageviewButton=[[UIImageView alloc]initWithFrame:CGRectMake(10+i%4*(width+5), 10+i/4*(width+5), width, width)];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(open:)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [imageviewButton addGestureRecognizer:tap];
        imageviewButton.tag=i;
        UIButton*deleButton=[[UIButton alloc]initWithFrame:CGRectMake(-10, -10, 17, 17)];
        [deleButton setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        deleButton.hidden=YES;
        [deleButton addTarget:self action:@selector(dele) forControlEvents:UIControlEventTouchUpInside];
        NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,model.cover];
        [imageviewButton sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"ic_icon_default"]];
        imageviewButton.userInteractionEnabled=YES;
        deleButton.backgroundColor=[UIColor clearColor];
        [imageviewButton addSubview:deleButton];
        [view addSubview:imageviewButton];
    }
        self.selectionStyle=0;
    [self.contentView addSubview:view];
}


-(void)onclick{




}





-(void)open:(UITapGestureRecognizer*)tap{
    
    if (_openPicture) {
        _openPicture(tap.view.tag);
    }
   
    
}


@end
