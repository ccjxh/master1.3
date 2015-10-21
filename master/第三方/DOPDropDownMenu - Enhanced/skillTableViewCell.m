//
//  skillTableViewCell.m
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "skillTableViewCell.h"
@implementation skillTableViewCell
{
    NSMutableArray*_valueArray;
}
- (void)awakeFromNib {
    // Initialization code
   
        if (!_valueArray ) {
            _valueArray =[[NSMutableArray alloc]init];
        }
        NSMutableArray*array=[[dataBase share]findAllSkill];
        
        for (NSInteger i=0; i<array.count;i++) {
            UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(10+i%3*((SCREEN_WIDTH-20-40)/3+20), 40+i/3*45, 90, 30)];
             UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(10+i%3*((SCREEN_WIDTH-20-40)/3+20), 40+i/3*45, 90, 30)];
            imageview.image=[UIImage imageNamed:@"select"];
            skillModel*model=array[i];
            button.layer.borderColor=COLOR(225, 225, 225, 1).CGColor;
            button.layer.borderWidth=1;
            button.titleLabel.font=[UIFont systemFontOfSize:12];
            [button setTitle:model.name forState:UIControlStateNormal];
            [button setTitleColor:COLOR(108, 108, 108, 1) forState:UIControlStateNormal];
            button.titleLabel.lineBreakMode=UILineBreakModeCharacterWrap;
            [button addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=30+i;
            button.layer.cornerRadius=4;
            imageview.tag=40+i;
            imageview.hidden=YES;
            [self.contentView addSubview:button];
            [self.contentView addSubview:imageview];
    }
}
    

-(void)reloadData{
    if ([self.selectedDic objectForKey:@"filterSkill"]) {
    NSString*temp=[self.selectedDic objectForKey:@"filterSkill"];
    NSArray*IDArray=[temp componentsSeparatedByString:@","];
     NSMutableArray*array=[[dataBase share]findAllSkill];
    for (NSInteger i=0; i<array.count; i++) {
        skillModel*model=array[i];
        for (NSInteger j=0; j<IDArray.count; j++) {
            NSInteger ID=[IDArray[j] integerValue];
            if (model.id==ID) {
                UIButton*button=(id)[self viewWithTag:30+i];
//                button.backgroundColor=COLOR(67, 172, 219, 1);
//                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                UIImageView*imageview=(id)[self viewWithTag:30+i+10];
                imageview.hidden=NO;
                button.selected=YES;
            }
        }
        
    }

    [_valueArray removeAllObjects];
    for (NSInteger i=0; i<array.count; i++) {
        skillModel*model=array[i];
        UIButton*valueButton=(id)[self viewWithTag:30+i];
        NSString*ID;
        if (valueButton.selected==YES) {
            ID=[NSString stringWithFormat:@"%u",model.id];
            [_valueArray addObject:ID];
        }
    }
    if (_block) {
        _block(_valueArray);
        }
    }
    
}

-(void)onclick:(UIButton*)button
{
    NSMutableArray*array=[[dataBase share]findAllSkill];
    if (button.selected==NO) {
        UIImageView*imageview=(id)[self viewWithTag:button.tag+10];
        imageview.hidden=NO;
//        button.backgroundColor=COLOR(67, 172, 219, 1);
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.selected=YES;
    }
    else
    {
        UIImageView*imageview=(id)[self viewWithTag:button.tag+10];
        imageview.hidden=YES;
//        button.backgroundColor=COLOR(249, 249, 249, 1);
//        [button setTitleColor:COLOR(108, 108, 108, 1) forState:UIControlStateNormal];
        button.selected=NO;
        
    }
    [_valueArray removeAllObjects];
    for (NSInteger i=0; i<array.count; i++) {
        skillModel*model=array[i];
        UIButton*valueButton=(id)[self viewWithTag:30+i];
        NSString*ID;
        if (valueButton.selected==YES) {
            ID=[NSString stringWithFormat:@"%u",model.id];
            [_valueArray addObject:ID];
        }
    }
    if (_block) {
        _block(_valueArray);
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
