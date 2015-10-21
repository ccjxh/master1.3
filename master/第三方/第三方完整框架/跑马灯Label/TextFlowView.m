//
//  TextFlowView.m
//  Paoma
//
//  Created by wu wxj on 11-9-7.
//  Copyright 2011年 tt. All rights reserved.
//

#import "TextFlowView.h"


@implementation TextFlowView

#pragma mark -
#pragma mark 内部调用

#define     SPACE_WIDTH     20
#define     LABEL_NUM       5

//改变一个TRect的起始点位置，但是其终止点的位置不变，因此会导致整个框架大小的变化
- (CGRect)moveNewPoint:(CGPoint)point rect:(CGRect)rect
{
    CGSize tmpSize;
    tmpSize.height = rect.size.height + (rect.origin.y - point.y);
    tmpSize.width = rect.size.width + (rect.origin.x - point.x);
    return CGRectMake(point.x, point.y, tmpSize.width, tmpSize.height);
}

- (BOOL)isNeedFlow
{
    return  _needFlow;
}

//开启定时器
- (void)startRun
{
    [self cancelRun];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                              target:self
                                            selector:@selector(timerAction)
                                            userInfo:nil
                                             repeats:YES];
}

//关闭定时器
- (void)cancelRun
{
    if (_timer) 
    {
        [_timer invalidate];
        _timer = nil;
    }
    _XOffset = 0;
    _bTurnLeft = YES;
    [self setNeedsDisplay];
}

//定时器执行的操作
- (void)timerAction
{
    if (_bTurnLeft)
    {
        // 向左跑马
        _XOffset--;
    }
    else
    {
        // 向右跑马
        _XOffset++;
    }
    
    if (_bTurnLeft && _XOffset+_textSize.width+SPACE_WIDTH <= self.frame.size.width)
    {
        _bTurnLeft = NO;
    }
    
    if (!_bTurnLeft && _XOffset >= SPACE_WIDTH/2)
    {
        _bTurnLeft = YES;
    }
    
    if (_XOffset +  _textSize.width <= 0)
    {
        _XOffset += _textSize.width;
        _XOffset += SPACE_WIDTH;
    }
    [self setNeedsDisplay];
}

//计算在给定字体下，文本仅显示一行需要的框架大小
- (CGSize)computeTextSize:(NSString *)in_text
{
    if (in_text == nil) 
    {
        return CGSizeMake(0, 0);
    }
    CGSize boundSize = CGSizeMake(10000, 100);
    CGSize stringSize = [in_text sizeWithFont:_font constrainedToSize:boundSize lineBreakMode:UILineBreakModeWordWrap];
    return stringSize;
}


- (id)initWithFrame:(CGRect)frame Text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        _text = [text retain];
        _frame = frame;
        _XOffset = 0;
        //默认的字体大小
        _font = [UIFont systemFontOfSize:16.0F];
        self.backgroundColor = [UIColor clearColor];
        //初始化标签
        //判断是否需要滚动效果
        _textSize = [self computeTextSize:text];
        //需要滚动效果
        if (_textSize.width > frame.size.width) 
        {
            _needFlow = YES;
        }
        else
        {
            _needFlow = NO;
        }
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context= UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, _color.CGColor);
    // Drawing code
    CGFloat startYOffset = (rect.size.height - _textSize.height)/2;
    CGPoint origin = rect.origin;
    if (_needFlow == YES)
    {
        if (_timer)
        {
            rect = [self moveNewPoint:CGPointMake(_XOffset, startYOffset) rect:rect];
            while (rect.origin.x <= rect.size.width+rect.origin.x)
            {
                [_text drawInRect:rect withFont:_font];
                rect = [self moveNewPoint:CGPointMake(rect.origin.x+_textSize.width+SPACE_WIDTH, rect.origin.y) rect:rect];
            }
        }
        else
        {
            // 显示“文本+...”
            NSInteger lenOfString = [_text length];
            NSString *tempString = nil;
            CGSize tmpTextSize = [self computeTextSize:_text];
            while (tmpTextSize.width > self.frame.size.width)
            {
                lenOfString--;
                tempString = [[_text substringToIndex:lenOfString-1] stringByAppendingString:@"..."];
                tmpTextSize = [self computeTextSize:tempString];
            }
            if (tempString)
            {
                [tempString drawInRect:rect withFont:_font];
            }
            else
            {
                [_text drawInRect:rect withFont:_font];
            }
        }
    }
    else
    {
        //在控件的左边绘制文本
        origin.x = 0;
        origin.y = (rect.size.height - _textSize.height)/2;
        rect.origin = origin;
        [_text drawInRect:rect withFont:_font];
    }
}


- (void)dealloc
{
    [_text release];
    [super dealloc];
}


#pragma mark -
#pragma mark 外部调用
- (void)setFont:(UIFont *)font
{
    _font = font;
}

- (void)setText:(NSString *)text
{
    [_text release];
    _text = [text retain];
    
    //判断是否需要滚动效果
    _textSize = [self computeTextSize:text];
    //需要滚动效果
    if (_textSize.width > self.frame.size.width)
    {
        _needFlow = YES;
    }
    else
    {
        _needFlow = NO;
    }
}

- (void)setColor:(UIColor *)color
{
    _color = color;
}



@end





