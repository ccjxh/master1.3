//
//  personDetailViewModel.m
//  master
//
//  Created by jin on 15/8/5.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "personDetailViewModel.h"

@implementation personDetailViewModel

//-(instancetype)init{
//
//    if (self=[super init]) {
//        [self request];
//    }
//    return self;
//    
//}
//
//-(void)request{
//
//
//    NSString*urlString=[self interfaceFromString:interface_masterDetail];
//    NSDictionary*dict=@{@"userId":[NSString stringWithFormat:@"%lu",[self.delegate personID]],@"firstLocation":[NSString stringWithFormat:@"%lu",[self.delegate  firstLocation]]};
//   id objc= [self requestWithPostFromURLString:urlString Parent:dict];
//    if (self.requestSuccess) {
//    if (objc) {
//        
//        NSDictionary*dict=(NSDictionary*)objc;
//        NSDictionary*inforDic=[[dict objectForKey:@"entity"] objectForKey:@"user"];
//        _id=[[inforDic objectForKey:@"id"] integerValue];
//        _serviec=[inforDic objectForKey:@"serviec"];
//        _pageView=[[inforDic objectForKey:@"pageView"] integerValue];
//        _mobile=[inforDic objectForKey:@"mobile"];
//        _age=[[inforDic objectForKey:@"age"] integerValue];
//        _gendar=[inforDic objectForKey:@"gendar"];
//        _certificate=[inforDic objectForKey:@"certificate"];
//        _certification=[inforDic objectForKey:@"certification"];
//        _recommendInfo=[inforDic objectForKey:@"recommendInfo"];
//        _favoriteFlag=[[inforDic objectForKey:@"favoriteFlag"] integerValue];
//        if (self.dataRefersh) {
//            self.dataRefersh();
//            return;
//            }
//        }
//    }
//    if (self.requestFilure) {
//        self.requestFilure();
//    }
//    
//}


@end
