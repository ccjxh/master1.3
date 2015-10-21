//
//  TableViewCell.m
//  master
//
//  Created by jin on 15/6/16.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}




-(void)add{
    if (self.block) {
        self.block(1,nil);
    }
}

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
    NSInteger width=(SCREEN_WIDTH-30)/3;
    for (NSInteger i=0; i<self.picArray.count; i++) {
        if (i==0) {
            UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(10+i%3*(width+5), 10+i/3*(width+5), width-10, width-10)];
            imageview.image=[UIImage imageNamed:@"增加图片"];
            imageview.userInteractionEnabled=YES;
            UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(add)];
            tap.numberOfTapsRequired=1;
            [imageview addGestureRecognizer:tap];
            [view addSubview:imageview];
            continue;
        }
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(10+i%3*(width+5), 10+i/3*(width+5), width-10, width-10)];
         imageview.image=self.picArray[i];
        UIButton*deleButton=[[UIButton alloc]initWithFrame:CGRectMake(-10, -10, 30, 30)];
        [deleButton setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        [deleButton addTarget:self action:@selector(dele) forControlEvents:UIControlEventTouchUpInside];
        _currentImage=_picArray[i];
        imageview.userInteractionEnabled=YES;
        deleButton.backgroundColor=[UIColor clearColor];
        [imageview addSubview:deleButton];
        [view addSubview:imageview];
    }
    self.selectionStyle=0;
    [self.contentView addSubview:view];
}

@end
