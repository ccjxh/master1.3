//
//  dataBase.h
//  master
//
//  Created by jin on 15/5/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface dataBase : NSObject
+(dataBase*)share;
-(instancetype)init;
- (void)inDatabase:(void (^)(FMDatabase *db))block;
- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;
@end
