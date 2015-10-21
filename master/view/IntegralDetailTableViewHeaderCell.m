//
//  IntegralDetailTableViewHeaderCell.m
//  ZCPal
//
//  Created by Ky.storm on 14-8-27.
//  Copyright (c) 2014年 ky.storm. All rights reserved.
//

#import "IntegralDetailTableViewHeaderCell.h"

@interface IntegralDetailTableViewHeaderCell ()
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@end

@implementation IntegralDetailTableViewHeaderCell

- (void)dealloc{
    _count = nil;
    _date = nil;
    _countLabel = nil;
    _dateLabel = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    UITableViewCellStyle myStyle = UITableViewCellStyleValue1;
    if (self = [super initWithStyle:myStyle reuseIdentifier:reuseIdentifier]) {
        self.backgroundView = [[UIView alloc]init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        
        _countLabel = [[UILabel alloc]init];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.font = [UIFont boldSystemFontOfSize:15];
        _countLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_countLabel];
        
        
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont systemFontOfSize:14];
//        _dateLabel.textColor = kDARKGRAYCOLOR;
        [self.contentView addSubview:_dateLabel];
        
        //约束
        NSMutableArray *constraints = [NSMutableArray array];
        
        NSArray *hContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_countLabel(<=70)]-10-[_dateLabel]-(>=50@1000)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_countLabel, _dateLabel)];
        NSArray *dateHContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=70@750)-[_dateLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_dateLabel)];
        NSArray *countVContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_countLabel]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_countLabel)];
        NSArray *dateVContraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_dateLabel]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_dateLabel)];
        [constraints addObjectsFromArray:hContraint];
        [constraints addObjectsFromArray:dateHContraint];
        [constraints addObjectsFromArray:countVContraint];
        [constraints addObjectsFromArray:dateVContraint];
        
        [_countLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self.contentView addConstraints:constraints];
        
        //分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, self.frame.size.height - 1, self.frame.size.width - 15, 1)];
        lineView.backgroundColor = COLOR(237, 238, 240, 1);
        lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:lineView];

    }
    return self;
}

- (NSString *)accessibilityLabel
{
    return self.textLabel.text;
}

- (void)setDate:(NSString *)date{
    _date = date;
    _dateLabel.text = [NSString stringWithFormat:@"(%@)", _date];
}

- (void)setCount:(NSString *)count{
    _count = count;
    //颜色
    NSMutableAttributedString *colorCountString = [[NSMutableAttributedString alloc] initWithString:_count];
    NSRange range = [_count rangeOfString:_count];
    [colorCountString addAttribute:NSForegroundColorAttributeName value:[count integerValue] > 0? COLOR(80, 145, 29, 1): COLOR(228, 121, 25, 1) range:range];
    _countLabel.attributedText = colorCountString;
}

- (void)setLoading:(BOOL)loading
{
    if (loading != _loading) {
        _loading = loading;
        [self _updateImage];
    }
}

- (void)setExpandable:(BOOL)expandable{
    _expandable = expandable;
    
    if (expandable) {
        if (!self.accessoryView) {
            [self setAccessoryView:[self expandableView]];
        }
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

- (void)setExpanded:(BOOL)expanded{
    _expanded = expanded;
    _expansionStyle = UIExpansionStyleExpanded;
    [self _updateImage];
}

- (void)setExpansionStyle:(UIExpansionStyle)expansionStyle animated:(BOOL)animated
{
    if (expansionStyle != _expansionStyle) {
        _expansionStyle = expansionStyle;
        [self _updateImage];
    }
}



- (void)_updateImage
{
    if (self.isLoading) {
        
    } else {
        switch (self.expansionStyle) {
            case UIExpansionStyleExpanded:
                self.accessoryView.transform = CGAffineTransformMakeRotation(M_PI);
                break;
            case UIExpansionStyleCollapsed:
                self.accessoryView.transform = CGAffineTransformMakeRotation(0);
                break;
        }
    }
}

static UIImage *_image = nil;
- (UIView *)expandableView
{
    if (!_image) {
        _image = [UIImage imageNamed:@"expandable_Image"];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, _image.size.width, _image.size.height);
    button.frame = frame;
    
    [button setBackgroundImage:_image forState:UIControlStateNormal];
    
    return button;
}

@end
