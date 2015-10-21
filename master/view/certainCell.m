//
//  certainCell.m
//  master
//
//  Created by jin on 15/9/25.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "certainCell.h"
#import "serviceCertainModel.h"

@implementation certainCell


-(void)reloadDataWithModel:(model *)model{

    serviceCertainModel*serviceModel=(serviceCertainModel*)model;
    for (NSInteger i=0; i<serviceModel.pictureArray.count; i++) {
        CGFloat height;
        NSInteger width=(SCREEN_WIDTH-40)/4;
        if (i==0) {
            UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(10+i%4*(width+5), 10+i/4*(width+5), width, width)];
            [button setImage:[UIImage imageNamed:@"增加图片"] forState:UIControlStateNormal];
            [button addTarget: self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            continue;
        }
        
        certificateModel*model=serviceModel.pictureArray[i];
        NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,model.resource];
        if (serviceModel.pictureArray.count%4==0) {
            height=serviceModel.pictureArray.count/4*40;
        }
        else{
            height=(serviceModel.pictureArray.count/4+1)*40;
            
        }
        
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(10+i%4*(width+5), 10+i/4*(width+5), width, width)];
        imageview.tag=20+i;
        [imageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageview.contentMode =  UIViewContentModeScaleAspectFill;
        imageview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageview.clipsToBounds=YES;
        [imageview sd_setImageWithURL:[NSURL URLWithString:urlString]];
        [self.contentView addSubview:imageview];
    }
    self.userInteractionEnabled=YES;
    self.selectionStyle=0;

}

-(void)add{

    if (self.addPhotos) {
        self.addPhotos();
    }

}


@end
