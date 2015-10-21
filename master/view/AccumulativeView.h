//
//  AccumulativeView.h
//  ZCPal
//
//  Created by Ky.storm on 14-8-8.
//  Copyright (c) 2014年 ky.storm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccumulativeView : UIView
@property (nonatomic, copy) NSString *accumulativeString;

/*!
 * @discussion 按钮点击响应块
 */
- (void)clickDetailWithBlock:(void(^)())block;
@end
