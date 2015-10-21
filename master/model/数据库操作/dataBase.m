//
//  dataBase.m
//  master
//
//  Created by jin on 15/5/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "dataBase.h"
#define DATANAME @"master.db"
@interface dataBase()
@property(nonatomic)FMDatabaseQueue*queue;
@end
@implementation dataBase
+(dataBase*)share
{
    static dispatch_once_t once;
    static dataBase*dataBase;
    dispatch_once(&once, ^{
        if (!dataBase) {
            dataBase=[[self alloc]init];
            
        }
    });

    return dataBase;
}

-(instancetype)init
{

    if (self=[super init]) {
        NSArray*pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString*paths=pathArray[0];
        NSString*fullPath=[paths stringByAppendingPathComponent:DATANAME];
        _queue=[[FMDatabaseQueue alloc]initWithPath:fullPath];
        
    }

    return self;
}



-(void)inDatabase:(void (^)(FMDatabase *db))block
{
    [_queue inDatabase:block];
    
}


-(void)inTransaction:(void (^)(FMDatabase *, BOOL *))block{
    [_queue inTransaction:block];
}

@end
