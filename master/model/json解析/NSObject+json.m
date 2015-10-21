//
//  NSObject+json.m
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "NSObject+json.h"

@implementation NSObject (json)
-(NSMutableArray*)arrayFromJosn:(id)respobject Type:(NSString*)type Model:(NSString*)modelString
{
    NSMutableArray*mutableArray=[[NSMutableArray alloc]init];
    NSDictionary*dict=(NSDictionary*)respobject;
    NSArray*array=[dict objectForKey:@"entities"];
    for (NSInteger i=0; i<array.count; i++) {
        NSDictionary*inforDic=array[i];
        Class str=NSClassFromString(modelString);
        model*tempModel=[[str alloc]init];
        [tempModel setValuesForKeysWithDictionary:[inforDic objectForKey:type]];
        [mutableArray addObject:tempModel];
    }
    return mutableArray;

}
@end
