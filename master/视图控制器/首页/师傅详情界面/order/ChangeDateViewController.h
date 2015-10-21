//
//  ChangeDateViewController.h
//  ZBCloud
//
//  Created by Ky.storm on 14-9-23.
//  Copyright (c) 2014年 ky.storm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BlockDateValue)(NSString *textField);

@interface ChangeDateViewController : UIViewController
@property (nonatomic, copy) NSString *oldDate;    //日期, 格式 yyyy-MM-dd

@property (nonatomic,copy) BlockDateValue blockDateValue;
@property (nonatomic,copy) NSString *navTitle;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) long tag;
@property(nonatomic)BOOL isEndTime;//是否是结束时间
@property(nonatomic)NSString*begainTime;//开始时间
@property(nonatomic)BOOL isPass;//是否可以选择过去的时间
@property(nonatomic)BOOL isfuture;//是否可以选择未来的时间
@property(nonatomic)BOOL isShowMessage;//是否显示提示
/*!
 * @discussion 日期更改响应块
 */
- (void)changeDateWithBlock:(void(^)(NSString *newDate, BOOL succeed))block;
@end
