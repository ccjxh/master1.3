//
//  IntegralTableHeaderView.m
//  ZCPal
//
//  Created by Ky.storm on 14-8-11.
//  Copyright (c) 2014年 ky.storm. All rights reserved.
//

#import "IntegralTableHeaderView.h"

@interface IntegralTableHeaderView ()
@property (nonatomic, copy) void(^clickBolck)();
@property (nonatomic, strong) UILabel *label;
@end

@implementation IntegralTableHeaderView

- (void)dealloc
{
    _clickBolck = nil;
    _title = nil;
    _label = nil;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        _label = [[UILabel alloc]init];
        _label.font = [UIFont systemFontOfSize:15];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = COLOR(109, 109, 109, 1);
        [self addSubview:_label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"更多" forState:UIControlStateNormal];
        [button setTitleColor:COLOR(109, 109, 109, 1) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.showsTouchWhenHighlighted = YES;
//        [button setBackgroundImage:[UIImage imageNamed:@"tipButton_blue"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        
        //约束
        NSMutableArray *constraints = [NSMutableArray array];
        
        NSArray *hContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_label(>=100)]-(>=100)-[button]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label, button)];
        NSArray *vContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_label(20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)];
        NSArray *buttonVContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[button]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)];
        [constraints addObjectsFromArray:hContraint];
        [constraints addObjectsFromArray:vContraint];
        [constraints addObjectsFromArray:buttonVContraint];
        
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        button.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:constraints];
        
        
    }
    return self;
}

/*!
 * @discussion 按钮点击响应块
 */
- (void)clickDetailWithBlock:(void(^)())block{
    _clickBolck = block;
}


/*!
 * @discussion 按钮点击事件
 */
- (void)buttonAction:(id)sender{
    if (_clickBolck) {
        _clickBolck();
    }
}

/*!
 * @discussion 设置标题
 */
- (void)setTitle:(NSString *)title{
    _title = title;
    _label.text = _title;
}
@end
