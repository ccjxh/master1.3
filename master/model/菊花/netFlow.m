//
//  netFlow.m
//  master
//
//  Created by jin on 15/5/24.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "netFlow.h"

@implementation netFlow

-(instancetype)initWithView:(UIView *)view{

    if (self=[super initWithView:view withBlur:YES]) {
        self.titleLabelText=@"加载中";
    }
   
    return self;
}

@end
