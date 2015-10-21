//
//  httpManager.h
//  master
//
//  Created by jin on 15/5/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface httpManager : AFHTTPRequestOperationManager
+(httpManager*)share;
-(instancetype)initWithBaseURL:(NSURL *)url;
-(AFHTTPRequestOperation*)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *Operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *Operation, NSError *error))failure;
-(AFHTTPRequestOperation*)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *Operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *Operation, NSError *error))failure;
@end
