//
//  fourthTableViewCell.m
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "fourthTableViewCell.h"

@implementation fourthTableViewCell

- (void)awakeFromNib {
    [self initUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)initUI
{
    NSArray*array=@[@"不限",@"18-30",@"30-50",@"50以上"];
    for (NSInteger i=0; i<4;i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(10+i%3*((SCREEN_WIDTH-20-40)/3+20), 40+i/3*45, 90, 30)];
        button.layer.borderColor=COLOR(225, 225, 225, 1).CGColor;
        button.layer.borderWidth=1;
        button.titleLabel.font=[UIFont systemFontOfSize:12];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:COLOR(108, 108, 108, 1) forState:UIControlStateNormal];
        button.titleLabel.lineBreakMode=UILineBreakModeCharacterWrap;
        [button addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius=4;
        button.tag=40+i;
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(10+i%3*((SCREEN_WIDTH-20-40)/3+20), 40+i/3*45, 90, 30)];
        imageview.image=[UIImage imageNamed:@"select"];
        imageview.tag=30+i;
        imageview.hidden=YES;
        [self addSubview:button];
        [self addSubview:imageview];
    }
    
}

-(void)onclick:(UIButton*)button
{
    UIImageView*imageview=(id)[self viewWithTag:button.tag-10];
    imageview.hidden=NO;
    for (NSInteger i=0; i<4; i++) {
        UIButton*tempButton=(id)[self viewWithTag:40+i];
        if (button.tag==tempButton.tag) {
            continue;
        }
        
        UIImageView*imageview1=(id)[self viewWithTag:tempButton.tag-10];
        imageview1.hidden=YES;
    }
    if (button.tag==40) {
        if (_faileBlock) {
            _faileBlock();
        }
        return;
    }
    if (_block) {
        NSString*value;
        switch (button.tag-40) {
            case 1:
                value=@"20-30";
                break;
                case 2:
                value=@"30-50";
                break;
                case 3:
                value=@"50-100";
                break;
            default:
                break;
        }
        
        
        _block(value);
    }
}


-(void)reloadData{

    if ([self.selectedDic objectForKey:@"filterAgeArea"]) {
    NSString*str=[self.selectedDic objectForKey:@"filterAgeArea"];
    NSInteger temp;
    if ([str isEqualToString:@"20-30"]==YES) {
        temp=1;
    }else if ([str isEqualToString:@"30-50"]==YES){
        temp=2;
    }else if ([str isEqualToString:@"50-100"]==YES){
        temp=3;
        }
    
        UIButton*button=(id)[self viewWithTag:temp+40];
        UIImageView*imageview=(id)[self viewWithTag:temp+30];
        imageview.hidden=NO;
        if (_block) {
            NSString*value;
            switch (button.tag-40) {
                case 1:
                    value=@"20-30";
                    break;
                case 2:
                    value=@"30-50";
                    break;
                case 3:
                    value=@"50-100";
                    break;
                default:
                    break;
            }
            
            _block(value);
        }

    }else{
    
        UIImageView*imageview=(id)[self viewWithTag:30];
        imageview.hidden=NO;
        if (_faileBlock) {
            _faileBlock();
        }
    }
    
}

@end
