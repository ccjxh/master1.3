//
//  serviceSkillSCell.m
//  master
//
//  Created by jin on 15/9/25.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "serviceSkillSCell.h"
#import "serviceSkillModel.h"
//#import "skillModel.h"
@implementation serviceSkillSCell
{

    UIView*_view;
    UILabel*_label;
    NSString*_reuseIdentifier;

}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _reuseIdentifier=reuseIdentifier;
        _label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 90, 20)];
        _label.text=@"专业技能";
        _label.font=[UIFont systemFontOfSize:16];
        _label.textColor=[UIColor blackColor];
        [self.contentView addSubview:_label];
        _view=[[UIView alloc]initWithFrame:CGRectMake(110, 5, SCREEN_WIDTH-120, 30)];
        [self.contentView addSubview:_view];
        
    }
    
    return self;
}

-(void)reloadDataWithModel:(model *)model{

    serviceSkillModel*dataArrayModel=(serviceSkillModel*)model;
    for (UIView*view in _view.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger orginX = 0;
    for (NSInteger i=0; i<dataArrayModel.skillArray.count; i++) {
        skillModel*model=dataArrayModel.skillArray[i];
        NSInteger width=(SCREEN_WIDTH-110-30)/3;
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-orginX-30-model.name.length*12-5, 5+i/3*40,model.name.length*12+5, 25)];
        orginX+=model.name.length*12+10;
        if (i!=0&&i%3==0) {
            orginX=0;
        }
        width=label.frame.origin.x+label.frame.size.width+5;
        label.text=model.name;
        label.tag=12;
        label.font=[UIFont systemFontOfSize:12];
        label.layer.borderWidth=1;
        label.numberOfLines=0;
        label.layer.cornerRadius=5;
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor lightGrayColor];
        label.layer.backgroundColor=[UIColor whiteColor].CGColor;
        label.layer.borderColor=[UIColor lightGrayColor].CGColor;
        label.layer.borderWidth=1;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        label.enabled=YES;
        label.userInteractionEnabled=NO;
        [_view addSubview:label];
        
    }

}

@end
