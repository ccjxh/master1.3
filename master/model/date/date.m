//
//  date.m
//  master
//
//  Created by jin on 15/5/22.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "date.h"

@implementation date
{
    

}
+(date*)share{
    static date *time;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!time) {
            time=[[self alloc]init];
        }
    });
    return time;
}


@end
