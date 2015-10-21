//
//  secondTableViewCell.m
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "secondTableViewCell.h"

@implementation secondTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self initUI];
}


-(void)initUI
{
    NSArray*array=@[@"不限",@"1-3",@"3-5",@"5-10",@"10年以上"];
    for (NSInteger i=0; i<5;i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(10+i%3*((SCREEN_WIDTH-20-40)/3+20), 40+i/3*45, 90, 30)];
        button.layer.borderColor=COLOR(225, 225, 225, 1).CGColor;
        button.layer.borderWidth=1;
        button.titleLabel.font=[UIFont systemFontOfSize:12];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:COLOR(108, 108, 108, 1) forState:UIControlStateNormal];
        button.titleLabel.lineBreakMode=UILineBreakModeCharacterWrap;
        [button addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius=4;
        button.tag=10+i;
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(10+i%3*((SCREEN_WIDTH-20-40)/3+20), 40+i/3*45, 90, 30)];
        imageview.image=[UIImage imageNamed:@"select"];
        imageview.tag=40+i;
        imageview.hidden=YES;
        [self addSubview:button];
        [self addSubview:imageview];
    }

}

-(void)onclick:(UIButton*)button
{

    UIImageView*imageview=(id)[self viewWithTag:30+button.tag];
    imageview.hidden=NO;
    for (NSInteger i=0; i<5; i++) {
        UIButton*tempButton=(id)[self viewWithTag:10+i];
        if (button.tag==tempButton.tag) {
            continue;
        }
        [tempButton setTitleColor:COLOR(108, 108, 108, 1) forState:UIControlStateNormal];
        UIImageView*imageview1=(id)[self viewWithTag:30+tempButton.tag];
        imageview1.hidden=YES;
        tempButton.backgroundColor=COLOR(249, 249, 249, 1);
    }
    if (_block) {
        if (button.tag!=10) {
            NSString*tempString;
            switch (button.tag-10) {
                case 1:
                    tempString=@"1-3";
                    break;
                    case 2:
                    tempString=@"3-5";
                    break;
                    case 3:
                    tempString=@"5-10";
                    break;
                    case 4:
                    tempString=@"10-100";
                    break;
                default:
                    break;
            }
            
        _block(tempString);
            
        }else if (button.tag==10){
        
            if (self.exBlock) {
                self.exBlock();
            }
        }
    }
}


-(void)reloadData{

    if ([self.selectedDic objectForKey:@"filterWorkYearArea"] ) {
    NSInteger status=[[self.selectedDic objectForKey:@"filterWorkYearArea"] integerValue];
        
        if (status==3) {
            status=2;
        }else if (status==5){
        
            status=3;
        }else if (status==10){
        
            status=4;
        }
        
        UIButton*button=(id)[self viewWithTag:10+status];
        UIImageView*imageview=(id)[self viewWithTag:40+status];
        imageview.hidden=NO;
                NSString*tempString;
        switch (status) {
            case 1:
                tempString=@"1-3";
                break;
            case 2:
                tempString=@"3-5";
                break;
            case 3:
                tempString=@"5-10";
                break;
            case 4:
                tempString=@"10-100";
                break;
            default:
                break;
        }
        
        _block(tempString);
        
    }else{
    
      UIButton*button=(id)[self viewWithTag:10];
     
        UIImageView*imageview=(id)[self viewWithTag:30+button.tag];
        imageview.hidden=NO;
        if (self.exBlock) {
            self.exBlock();
        }
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}



@end
