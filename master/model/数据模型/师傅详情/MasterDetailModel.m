//
//  MasterDetailModel.m
//  master
//
//  Created by xuting on 15/5/27.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "MasterDetailModel.h"

@implementation MasterDetailModel


- (void) setContent:(NSString *)content
{
    _content = content;
    
    if (self.content) {
        
        self.contentHeight = [self.content  boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/2-40, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil].size.height;
    }
}

@end
