//
//  UIToast.m
//  UIToast
//
//  Created by Francesco Perrotti-Garcia on 1/27/15.
//  Copyright (c) 2015 Francesco Perrotti-Garcia. All rights reserved.
//

#import "UIToast.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "UIApplication+AppDimensions.h"

@interface UIToast ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong, readonly) UIWindow *window;

@end

@implementation UIToast

static const CGFloat UIToastDefaultViewAlpha = 0.7;
static const NSTimeInterval UIToastDefaultDuration = 3.0;
static const NSTimeInterval UIToastDefaultFadeInOut = 0.5;
static const NSTimeInterval UIToastDefaultDelay = 0.0;
static const CGFloat UIToastDefaultSystemFontSizeIncrement = 2.0;

static const NSString *UIToastTimerKey = @"UIToastTimerKey";

- (instancetype)initWithText:(NSString *)text duration:(NSTimeInterval)duration {
    self = [super init];
    if (self) {

        [self setUpTextView];
        [self setDefaultValues];

        self.text = text;
        self.duration = duration;

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
        [self addGestureRecognizer:tapGestureRecognizer];

        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(deviceDidRotate)
                   name:UIDeviceOrientationDidChangeNotification
                 object:nil];
    }
    return self;
}

- (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.window addSubview:self];
    self.layer.zPosition = CGFLOAT_MAX;

    self.textView.text = [NSString stringWithFormat:@"  %@  ", self.text]; // Make fix for longer texts
    self.textView.font = [UIFont systemFontOfSize:self.fontSize];
    self.textView.textAlignment = NSTextAlignmentCenter;
    [self.textView sizeToFit];
    [self positionView];

    self.layer.cornerRadius = self.roundEdges ? self.bounds.size.height / 2 : 0.0;

    self.alpha = 0.0;
    [UIView animateWithDuration:self.fadeInTime
        delay:self.delay
        options:(UIViewAnimationOptionCurveEaseInOut) // | UIViewAnimationOptionAllowUserInteraction)
        animations:^{
          self.alpha = self.viewAlpha;
        }
        completion:^(BOOL finished) {
          NSTimer *timer =
              [NSTimer scheduledTimerWithTimeInterval:self.duration
                                               target:self
                                             selector:@selector(timerDidFinish:)
                                             userInfo:nil
                                              repeats:NO];
          objc_setAssociatedObject(self, &UIToastTimerKey, timer,
                                   OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }];

    NSLog(@"%@\n%@", NSStringFromCGRect(self.frame), NSStringFromCGRect(self.bounds));
    });
}

- (void)hide {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    dispatch_async(dispatch_get_main_queue(), ^{

    [UIView animateWithDuration:self.fadeOutTime
        delay:0.0
        options:(UIViewAnimationOptionCurveEaseInOut)
        animations:^{
          self.alpha = 0.0;
        }
        completion:^(BOOL finished) {
          [self removeFromSuperview];
        }];
    });
}

- (void)cancel {
    [self hide];
}

- (void)timerDidFinish:(id)sender {
    // Call delegate
    [self hide];
}

- (void)didTap {
    // Call delegate
    [self hide];
}

+ (UIToast *)makeText:(NSString *)text {
    return [[UIToast alloc] initWithText:text duration:UIToastDefaultDuration];
}

+ (UIToast *)makeText:(NSString *)text duration:(NSTimeInterval)duration {
    return [self makeText:text duration:duration];
}

#pragma mark - Helpers

- (void)setDefaultValues {
    self.viewAlpha = UIToastDefaultViewAlpha;
    self.fadeInTime = self.fadeOutTime = UIToastDefaultFadeInOut;
    self.delay = UIToastDefaultDelay;
    self.duration = UIToastDefaultDuration;
    self.layer.masksToBounds = YES;
    self.roundEdges = YES;
    self.fontSize =
        [UIFont systemFontSize] + UIToastDefaultSystemFontSizeIncrement;
    self.insets = UIEdgeInsetsMake(4.0, 5.0, 3.0, 6.0);
    NSLog(@"%f", self.fontSize);
}

- (void)setUpTextView {
    self.textView = [[UITextView alloc] init];
    self.textView.backgroundColor = [UIColor blackColor];
    // self.textView.alpha = self.viewAlpha;
    self.textView.textColor = [UIColor whiteColor];
    self.textView.userInteractionEnabled = NO;
    // self.textView.font = [UIFont systemFontOfSize:self.fontSize];
    [self addSubview:self.textView];
}

- (void)positionView {
    // check that in order for rotation to work
    CGSize actualSize = [UIApplication currentSize];

    self.frame = CGRectMake(actualSize.width / 2 - self.textView.bounds.size.width / 2,
                            actualSize.height * 0.85 - self.textView.bounds.size.height / 2,
                            self.textView.bounds.size.width,
                            self.textView.bounds.size.height);

    NSLog(@"%f x %f", actualSize.width, actualSize.height);
}

- (void)deviceDidRotate {
    NSLog(@"Rotate");
    [self positionView];
}

#pragma mark - Pseudo Window

- (UIWindow *)window {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window)
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    return window;
}

@end