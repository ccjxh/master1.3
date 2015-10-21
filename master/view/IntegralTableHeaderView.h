//
//  IntegralTableHeaderView.h
//  ZCPal
//
//  Created by Ky.storm on 14-8-11.
//  Copyright (c) 2014年 ky.storm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralTableHeaderView : UIView
@property (nonatomic, copy) NSString *title;    //标题

/*!
 * @discussion 按钮点击响应块
 */
- (void)clickDetailWithBlock:(void(^)())block;
@end
