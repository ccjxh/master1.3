//
//  BalanceView.m
//  ZCPal
//
//  Created by Ky.storm on 14-8-8.
//  Copyright (c) 2014年 ky.storm. All rights reserved.
//

#import "BalanceView.h"
#import <QuartzCore/QuartzCore.h>


@interface BalanceView ()
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, copy) void(^clickBlock)();
@end

@implementation BalanceView
- (void)dealloc
{
    _balanceString = nil;
    _balanceLabel = nil;
    _clickBlock = nil;
}

- (id)init{
    self = [super init];
    if (self) {
        // Initialization code
        self.backgroundColor = COLOR(47, 97, 175, 1);
        
        //详情按钮
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailButton setBackgroundImage:[UIImage imageNamed:@"tipButton_white"] forState:UIControlStateNormal];
        [detailButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:detailButton];
        
        //提示标签
        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.numberOfLines = 1;
        tipLabel.font = [UIFont systemFontOfSize:16];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.text = @"积分余额";
        tipLabel.textAlignment = NSTextAlignmentLeft;
        tipLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tipLabel];
        
        //内容标签
        _balanceLabel = [[UILabel alloc]init];
        _balanceLabel.numberOfLines = 1;
        _balanceLabel.adjustsFontSizeToFitWidth = YES;
        _balanceLabel.font = [UIFont boldSystemFontOfSize:35];
        _balanceLabel.textColor = [UIColor whiteColor];
        _balanceLabel.textAlignment = NSTextAlignmentLeft;
        _balanceLabel.backgroundColor = [UIColor clearColor];
        _balanceLabel.text = @"0";
        [self addSubview:_balanceLabel];
        
        
        //约束
        NSMutableArray *constraints = [NSMutableArray array];
        
        NSArray *buttonHContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[detailButton(==40)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(detailButton)];
        NSArray *buttonVContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[detailButton(==40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(detailButton)];
        [constraints addObjectsFromArray:buttonHContraint];
        [constraints addObjectsFromArray:buttonVContraint];
        
        NSArray *tipLabelHContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[tipLabel(==80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tipLabel)];
        NSArray *tipLabelVContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=10)-[tipLabel(==20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tipLabel)];
        [constraints addObjectsFromArray:tipLabelHContraint];
        [constraints addObjectsFromArray:tipLabelVContraint];
        
        NSArray *countLabelHContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_balanceLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tipLabel, _balanceLabel)];
        NSArray *countLabelVContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[tipLabel]-(>=5@1000,<=10@500)-[_balanceLabel]-(>=5@1000,<=20@500)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tipLabel, _balanceLabel)];
        [constraints addObjectsFromArray:countLabelHContraint];
        [constraints addObjectsFromArray:countLabelVContraint];
        
        [detailButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [tipLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_balanceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:constraints];
    }
    return self;
}

/*!
 * @discussion 参数tipString的set方法
 */
- (void)setBalanceString:(NSString *)countString{
    _balanceString = countString;
    _balanceLabel.text = _balanceString;
}


/*!
 * @discussion 详情按钮响应事件
 */
- (void)buttonAction:(id)sender{
    if (_clickBlock) {
        _clickBlock();
    }
}

/*!
 * @discussion 按钮点击响应块
 */
- (void)clickDetailWithBlock:(void(^)())block{
    _clickBlock = block;
}
@end
