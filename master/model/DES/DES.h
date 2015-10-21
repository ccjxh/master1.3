//
//  DES.h
//  master
//
//  Created by jin on 15/6/10.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES : NSObject
+ (NSData *)decryptWithText:(NSString *)sText Key:(NSString*)key;//解密
@end
