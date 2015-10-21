//
//  UIView+jxhAimation.h
//  jxhAnimation
//
//  Created by jin on 15/3/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    JXHTransitionAnimationTypeCameraIris,
    //相机
    JXHTransitionAnimationTypeCube,
    //立方体
    JXHTransitionAnimationTypeFade,
    //淡入
    JXHTransitionAnimationTypeMoveIn,
    //移入
    JXHTransitionAnimationTypeOglFilp,
    //翻转
    JXHTransitionAnimationTypePageCurl,
    //翻去一页
    JXHTransitionAnimationTypePageUnCurl,
    //添上一页
    JXHTransitionAnimationTypePush,
    //平移
    JXHTransitionAnimationTypeReveal,
    //移走
    JXHTransitionAnimationTypeRippleEffect,
    JXHTransitionAnimationTypeSuckEffect
}JXHTransitionAnimationType;

/**动画方向*/
typedef enum
{
    JXHTransitionAnimationTowardFromLeft,
    JXHTransitionAnimationTowardFromRight,
    JXHTransitionAnimationTowardFromTop,
    JXHTransitionAnimationTowardFromBottom
}JXHTransitionAnimationToward;
@interface UIView (jxhAimation)
//为当前视图添加切换的动画效果
//参数是动画类型和方向
//如果要切换两个视图，应将动画添加到父视图
- (void)setTransitionAnimationType:(JXHTransitionAnimationType)transtionAnimationType toward:(JXHTransitionAnimationToward)transitionAnimationToward duration:(NSTimeInterval)duration;
@end
