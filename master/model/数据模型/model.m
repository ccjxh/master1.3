//
//  model.m
//  master
//
//  Created by jin on 15/5/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "model.h"

@implementation model
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    


}


//-(id)requestWithGetFromURLString:(NSString *)urlString{
//    
//    __block id objc;
//    
//    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
//        
//        objc=responseObject;
//        
//    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
//        
//        if (_requestFilure) {
//            _requestFilure();
//        }
//    }];
//    
//    return objc;
//}
//
//-(id)requestWithPostFromURLString:(NSString *)urlString Parent:(NSDictionary *)parent{
//
//    __block id objc;
//    [[httpManager share]POST:urlString parameters:parent success:^(AFHTTPRequestOperation *Operation, id responseObject) {
//        objc=responseObject;
//        
//    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
//        
//        if (_requestFilure) {
//            _requestFilure();
//        }
//    }];
//    
//    return objc;
//
//}
//
@end
