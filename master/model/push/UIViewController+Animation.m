
//版权所有：ky-storm.cn
//系统名称：UIViewController动画扩展
//作　　者：ky.storm
//完成日期：2014-8-7
//功能说明：UIViewController动画扩展
//-----------------------------------------

#import "UIViewController+Animation.h"

#define kAnimationDuration 0.6f        //过渡动画时间

@implementation UIViewController (Animation)

/**
 @discussion:获取动画方法
 */
+ (CAAnimation *)animationWithType:(KYNaviAnimationType)animationType direction:(KYNaviAnimationDirection)direction{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kAnimationDuration];
    switch (animationType) {
        case KYNaviAnimationTypeFade:
            animation.type = kCATransitionFade; //淡化
            break;
        case KYNaviAnimationTypePush:
            animation.type = kCATransitionPush; //推挤
            break;
        case KYNaviAnimationTypeReveal:
            animation.type = kCATransitionReveal; //揭开
            break;
        case KYNaviAnimationTypeMoveIn:
            animation.type = kCATransitionMoveIn;//覆盖
            break;
        case KYNaviAnimationTypeCube:
            animation.type = @"cube";   //立方体
            break;
        case KYNaviAnimationTypeSuck:
            animation.type = @"suckEffect"; //吸收
            break;
        case KYNaviAnimationTypeSpin:
            animation.type = @"oglFlip";    //旋转
            break;
        case KYNaviAnimationTypeRipple:
            animation.type = @"rippleEffect";   //波纹
            break;
        case KYNaviAnimationTypePageCurl:
            animation.type = @"pageCurl";   //翻页
            break;
        case KYNaviAnimationTypePageUnCurl:
            animation.type = @"pageUnCurl"; //反翻页
            break;
        case KYNaviAnimationTypeCameraOpen:
            animation.type = @"cameraIrisHollowOpen";   //镜头开
            break;
        case KYNaviAnimationTypeCameraClose:
            animation.type = @"cameraIrisHollowClose";  //镜头关
            break;
        default:
            animation.type = kCATransitionPush; //推挤
            break;
    }
    
    switch (direction) {
        case KYNaviAnimationDirectionFromLeft:
            animation.subtype = kCATransitionFromLeft;
            break;
        case KYNaviAnimationDirectionFromRight:
            animation.subtype = kCATransitionFromRight;
            break;
        case KYNaviAnimationDirectionFromTop:
            animation.subtype = kCATransitionFromTop;
            break;
        case KYNaviAnimationDirectionFromBottom:
            animation.subtype = kCATransitionFromBottom;
            break;
        default:
            animation.subtype = kCATransitionFromRight;
            break;
    }
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    return animation;
    
}


/**
 @discussion:获取动画方法
 */
- (CAAnimation *)animationWithType:(KYNaviAnimationType)animationType direction:(KYNaviAnimationDirection)direction{
    return [UIViewController animationWithType:animationType direction:direction];
}
@end
