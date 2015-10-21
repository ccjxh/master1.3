
//
//  UIView+jxhAimation.h
//  jxhAnimation
//
//  Created by jin on 15/3/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

//动画类型
typedef enum{
    //CAAnimation类型
    KYNaviAnimationTypeFade = 0,  //淡化
    KYNaviAnimationTypePush,      //推挤
    KYNaviAnimationTypeReveal,    //揭开
    KYNaviAnimationTypeMoveIn,    //覆盖
    KYNaviAnimationTypeCube,      //立方体
    KYNaviAnimationTypeSuck,      //吸收
    KYNaviAnimationTypeSpin,      //旋转
    KYNaviAnimationTypeRipple,    //波纹
    KYNaviAnimationTypePageCurl,  //翻页
    KYNaviAnimationTypePageUnCurl,    //反翻页
    KYNaviAnimationTypeCameraOpen,    //镜头开
    KYNaviAnimationTypeCameraClose,    //镜头关
}KYNaviAnimationType;

//动画方向
typedef enum{
    KYNaviAnimationDirectionFromLeft,     //从左到右
    KYNaviAnimationDirectionFromRight,    //从右到左
    KYNaviAnimationDirectionFromTop,      //从上到下
    KYNaviAnimationDirectionFromBottom    //从下到上
}KYNaviAnimationDirection;

@interface UIViewController (Animation)
//获取动画

/**
 @discussion:获取动画方法
 */
+ (CAAnimation *)animationWithType:(KYNaviAnimationType)animationType direction:(KYNaviAnimationDirection)direction;

/**
 @discussion:获取动画方法
 */
- (CAAnimation *)animationWithType:(KYNaviAnimationType)animationType direction:(KYNaviAnimationDirection)direction;



@end
