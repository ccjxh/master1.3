//
//  UIView+jxhAimation.m
//  jxhAnimation
//
//  Created by jin on 15/3/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "UIView+jxhAimation.h"


@implementation UIView (jxhAimation)
- (void)setTransitionAnimationType:(JXHTransitionAnimationType)transtionAnimationType toward:(JXHTransitionAnimationToward)transitionAnimationToward duration:(NSTimeInterval)duration
{
    CATransition * transition = [CATransition animation];
    transition.duration = duration;
    NSArray * animations = @[@"cameraIris",
                             @"cube",
                             @"fade",
                             @"moveIn",
                             @"oglFilp",
                             @"pageCurl",
                             @"pageUnCurl",
                             @"push",
                             @"reveal",
                             @"rippleEffect",
                             @"suckEffect"];
    NSArray * subTypes = @[@"fromLeft", @"fromRight", @"fromTop", @"fromBottom"];
    transition.type = animations[transtionAnimationType];
    transition.subtype = subTypes[transitionAnimationToward];
    
    [self.layer addAnimation:transition forKey:nil];
}



@end
