//
//  custonView.h
//  master
//
//  Created by jin on 15/5/20.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface custonView : UIView
@property(nonatomic,copy)void(^scrollblock)(NSInteger tag);
-(instancetype)initWithFrame:(CGRect)frame Array:(NSArray*)array;
@end
