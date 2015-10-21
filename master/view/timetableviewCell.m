//
//  timetableviewCell.m
//  master
//
//  Created by jin on 15/9/25.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "timetableviewCell.h"
#import "startTimeModel.h"
#import "serviceIntrouceModel.h"
#import "compensation.h"
#import "workStatusModel.h"

@implementation timetableviewCell
{
    UILabel*_label;
    UITextView*_content;
    NSString*_reuseIdentifier;
    NSArray*_nameArray;

}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 90, 20)];
        _content=[[UITextView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-110, 5, SCREEN_WIDTH-120, 20)];
        _label.textColor=[UIColor blackColor];
        _label.font=[UIFont systemFontOfSize:16];
        _content.textColor=[UIColor blackColor];
        _content.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:_label];
        [self.contentView addSubview:_content];
        _reuseIdentifier=reuseIdentifier;
        _nameArray=[[NSArray alloc]initWithObjects:@"开始工作时间",@"服务介绍",@"期望薪资",@"工作状态", nil];
        
    }

    return self;
}

-(void)reloadDataWithModel:(model *)model{
    
    if ([_reuseIdentifier isEqualToString:@"timetableviewCell"]==YES) {
        startTimeModel*timeModel=(startTimeModel*)model;
        _content.text=timeModel.startWork;
        _label.text=_nameArray[0];
    }
    if ([_reuseIdentifier isEqualToString:@"serviceIntrouce"]==YES) {
        serviceIntrouceModel*IntrouceModel=(serviceIntrouceModel*)model;
        _label.text=_nameArray[1];
        _content.text=IntrouceModel.serviceDescribe;
        CGFloat  height=[self heightForTextView:_content WithText:IntrouceModel.serviceDescribe];
        _content.frame=CGRectMake(_content.frame.origin.x, _content.frame.origin.y, _content.frame.size.width, height+5);
    }
    if ([_reuseIdentifier isEqualToString:@"compensation"]==YES) {
        compensation*compen=(compensation*)model;
        _label.text=_nameArray[2];
        _content.text=compen.compensation;
    }
    if ([_reuseIdentifier isEqualToString:@"workStatus"]==YES) {
        
        workStatusModel*workModel=(workStatusModel*)model;
        _label.text=_nameArray[3];
        _content.text=workModel.workStatus;
    }

}


@end
