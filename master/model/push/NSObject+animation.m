//
//  NSObject+animation.m
//  master
//
//  Created by jin on 15/5/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "NSObject+animation.h"
#import "UIView+jxhAimation.h"
@implementation NSObject (animation)
-(void)pushWinthAnimation:(UINavigationController *)navigation Viewcontroller:(UIViewController *)viewcontroller
{
    
//    POPSpringAnimation*animation=[POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    animation.toValue=[NSValue valueWithCGPoint:CGPointMake(1, 1)];
//    animation.springBounciness=16.0;
//    animation.springSpeed=1.0;
//    
//    [navigation.view.layer pop_addAnimation:animation forKey:kPOPLayerScaleXY];
//    animation.completionBlock=^(POPAnimation*anim,BOOL Finish){
//    
//        if (Finish) {
//            [navigation pushViewController:viewcontroller animated:YES];
//        }
//    
//    };
//    
    
//    POPBasicAnimation *anim = [POPBasicAnimation animation];
//    anim.duration = 10.0;
//    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) { prop.readBlock = ^(id obj, CGFloat values[]) {
//        values[0] = [[obj description] floatValue];};
//        prop.writeBlock = ^(id obj, const CGFloat values[]) {
//            [obj setText:[NSString stringWithFormat:@"%.2f",values[0]]];};
//        prop.threshold = 0.01;}];
//    anim.property = prop;
//    anim.fromValue = @(0.0);
//    anim.toValue = @(100.0);
//    navigation.view.layer pop_addAnimation:anim forKey:@""
    
//    POPDecayAnimation* decay = [POPDecayAnimation animationWithPropertyNamed:kPOPViewFrame];
//    
//    //    decay.toValue = [NSValue valueWithCGRect:CGRectMake(200, 400, 100, 100)];
//    
//    decay.velocity = [NSValue valueWithCGRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [navigation.view pop_addAnimation:decay forKey:@"go"];
//                [navigation pushViewController:viewcontroller animated:YES];

  //弹性动画
//    POPBasicAnimation*anim=[POPBasicAnimation animation];
//    anim.duration=10.0f;
//    anim.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    POPAnimatableProperty*pro=[POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
//       
//        
//        
//        
//        };
    //5是前翻页    6是后翻页
    
   
    [navigation pushViewController:viewcontroller animated:YES];

    
}
-(void)popWithnimation:(UINavigationController *)navigation
{
//    [navigation.view setTransitionAnimationType:6 toward:JXHTransitionAnimationTowardFromRight duration:0.5f];
    [navigation popViewControllerAnimated:YES];
}

-(CGFloat)getScreenHeight
{
    CGFloat Height;
    if (IOS_VERSION<8.0) {
        Height=SCREEN_HEIGHT;
    }
    else if (IOS_VERSION>=8.0)
    {
        Height=SCREEN_WIDTH-64;
    }
    return Height;
}

-(CGFloat)getOrigin
{
    CGFloat YPoint;
    if (IOS_VERSION>=8.0) {
        YPoint=0;
    }
    else if (IOS_VERSION<8.0)
    {
        YPoint=64;
    }
    return YPoint;
}

-(CGFloat)accountStringHeightFromString:(NSString *)str Width:(CGFloat)width{
    CGFloat height;
   height = [str  boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName] context:nil].size.height;
    return height;
 }


- (BOOL)isAllNum:(NSString *)string{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}
@end
