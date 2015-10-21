//
//  custonView.m
//  master
//
//  Created by jin on 15/5/20.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "custonView.h"
@interface custonView ()
@property(nonatomic)NSArray*tempArray;
@end
@implementation custonView
UIColor *black;
UIColor *light;
UIFont *normalFont;
UIFont *lightFont;
-(instancetype)initWithFrame:(CGRect)frame Array:(NSArray *)array{
    if (self=[super initWithFrame:frame]) {
        black=[UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1];
        light=[UIColor colorWithRed:0.86 green:0.2 blue:0.22 alpha:1];
        normalFont=[UIFont boldSystemFontOfSize:15];
        lightFont=[UIFont boldSystemFontOfSize:18];
        _tempArray=[NSArray arrayWithArray:array];
        [self initButton:array];
    }
    return self;
}

-(void)initButton:(NSArray*)array{
    NSInteger Width=(SCREEN_WIDTH-(array.count-1)*20-40)/array.count;
    for (NSInteger i=0; i<array.count; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(10+i*Width, 0, Width, 40)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font=normalFont;
        button.tag=10+i;
        [button addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

-(void)onclick:(UIButton*)button
{
    button.titleLabel.font=lightFont;
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    for (NSInteger i=0; i<_tempArray.count; i++) {
        UIButton*tempButton=(id)[self viewWithTag:10+i];
        if (button.tag==tempButton.tag) {
            continue;
        }
        tempButton.titleLabel.font=normalFont;
        [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }

    if (_scrollblock) {
        _scrollblock(button.tag);
    }
}
@end
