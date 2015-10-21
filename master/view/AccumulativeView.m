//
//  AccumulativeView.m
//  ZCPal
//
//  Created by Ky.storm on 14-8-8.
//  Copyright (c) 2014年 ky.storm. All rights reserved.
//

#import "AccumulativeView.h"
#import <QuartzCore/QuartzCore.h>

@interface AccumulativeView ()
@property (nonatomic, strong) UILabel *accumulativeLabel;
@property (nonatomic, copy) void(^clickBlock)();
@end

@implementation AccumulativeView
- (void)dealloc
{
    _accumulativeString = nil;
    _accumulativeLabel = nil;
    _clickBlock = nil;
}

- (id)init{
    self = [super init];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.borderColor = kBORDERCOLOR.CGColor;
        self.layer.borderWidth = .5f;
        
        //详情按钮
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailButton setBackgroundImage:[UIImage imageNamed:@"tipButton_blue"] forState:UIControlStateNormal];
        detailButton.hidden = YES;
        [detailButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:detailButton];
        
        //提示标签
        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.numberOfLines = 1;
        tipLabel.font = [UIFont systemFontOfSize:14];
//        tipLabel.textColor = kDARKGRAYCOLOR;
        tipLabel.text = @"累计积分";
        tipLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:tipLabel];
        
        //内容标签
        _accumulativeLabel = [[UILabel alloc]init];
        _accumulativeLabel.numberOfLines = 1;
        _accumulativeLabel.adjustsFontSizeToFitWidth = YES;
        _accumulativeLabel.font = [UIFont boldSystemFontOfSize:30];
//        _accumulativeLabel.textColor = kBLUECOLOR;
        _accumulativeLabel.textAlignment = NSTextAlignmentLeft;
        _accumulativeLabel.text = @"0";
        [self addSubview:_accumulativeLabel];
        
        
        //约束
        NSMutableArray *constraints = [NSMutableArray array];
        
        NSArray *buttonHContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[detailButton(==20)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(detailButton)];
        NSArray *buttonVContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[detailButton(==20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(detailButton)];
        [constraints addObjectsFromArray:buttonHContraint];
        [constraints addObjectsFromArray:buttonVContraint];
        
        NSArray *tipLabelHContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[tipLabel(==80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tipLabel)];
        NSArray *tipLabelVContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[tipLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tipLabel)];
        [constraints addObjectsFromArray:tipLabelHContraint];
        [constraints addObjectsFromArray:tipLabelVContraint];
        
        NSArray *countLabelHContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_accumulativeLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tipLabel, _accumulativeLabel)];
        NSArray *countLabelVContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[tipLabel]-(>=2@1000,<=8)-[_accumulativeLabel]-(>=3@1000,<=5)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tipLabel, _accumulativeLabel)];
        [constraints addObjectsFromArray:countLabelHContraint];
        [constraints addObjectsFromArray:countLabelVContraint];
    
        
        
        [detailButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [tipLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_accumulativeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:constraints];
    }
    return self;
}

/*!
 * @discussion 参数tipString的set方法
 */
- (void)setAccumulativeString:(NSString *)accumulativeString{
    _accumulativeString = accumulativeString;
    _accumulativeLabel.text = accumulativeString;
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
