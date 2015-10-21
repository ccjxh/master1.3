//
//  NSObject+json.h
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (json)
-(NSMutableArray*)arrayFromJosn:(id)respobject Type:(NSString*)type Model:(NSString*)modelString;
@end
