//
//  datePcikView.h
//  master
//
//  Created by jin on 15/8/21.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 
    时间控件
 **/

@interface datePcikView : UIView
@property (weak, nonatomic) IBOutlet UIDatePicker *datepick;
@property (weak, nonatomic) IBOutlet UIButton *certainButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property(nonatomic,copy)void(^certainBlock)(NSString*dateString);
@property(nonatomic,copy)void(^cancelBlock)();
@property (nonatomic, copy) NSString *oldDate;    //日期, 格式 yyyy-MM-dd
@property (nonatomic,assign) long tag;
@property(nonatomic)BOOL isEndTime;//是否是结束时间
@property(nonatomic)NSString*begainTime;//开始时间
@property(nonatomic)BOOL isPass;//是否可以选择过去的时间
@property(nonatomic)BOOL isfuture;//是否可以选择未来的时间
@end
