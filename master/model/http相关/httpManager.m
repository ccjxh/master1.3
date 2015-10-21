//
//  httpManager.m
//  master
//
//  Created by jin on 15/5/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "httpManager.h"
#import "OpenUDID.h"
@implementation httpManager
+(httpManager*)share
{
    static dispatch_once_t once;
    static httpManager*manager;
    dispatch_once(&once, ^{
        if (!manager) {
            manager=[[self alloc]initWithBaseURL:[NSURL URLWithString:changeURL]];
        }
    });

    return manager;
}

-(instancetype)initWithBaseURL:(NSURL *)url
{
    if (self=[super initWithBaseURL:url]) {
        self.requestSerializer.timeoutInterval=timeout;
        
    }
    return self;

}


-(AFHTTPRequestOperation*)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *Operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *Operation, NSError *error))failure
{
    
    
    __block AFHTTPRequestOperation*finallyOperation;
    BOOL isReachable = [[AFNetworkReachabilityManager sharedManager] isReachable];
//    if (!isReachable) {
//        NSError *error = [NSError errorWithDomain:@"网络异常" code:502 userInfo:nil];
//        failure(operation,error);
//    }
//    else
//    {
        //网络通畅
        NSError *error1 = [NSError errorWithDomain:@"请求参数不正确" code:500 userInfo:nil];
    
    
    finallyOperation =[super GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation1, id responseObject) {
           NSDictionary*dict=(NSDictionary*)responseObject;
           NSInteger rspcode=[[dict objectForKey:@"rspCode"] integerValue];
        
        
           switch (rspcode) {
                   
                   
               case 500:
                   success(operation1,responseObject);
                   break;
               case 200:
                   success(operation1,responseObject);
                   break;
               case 530:
               {
               
                   [self remoLogin:^{
                       
                       
                     [super GET:URLString parameters:parameters success:success failure:failure];
                   }];
               }
                   break;
               default:
                   success(operation1,responseObject);
                   break;
           }
        
//        [self setCookieWithOperation:finallyOperation];
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          
           NSError *error2 = [NSError errorWithDomain:@"网络异常" code:502 userInfo:nil];
           failure(operation,error2);
           
       }];
    
    
//    }
    return finallyOperation;

}

-(AFHTTPRequestOperation*)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *Operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *Operation, NSError *error))failure
{
    __block AFHTTPRequestOperation*operation;
    BOOL isReachable = [[AFNetworkReachabilityManager sharedManager] isReachable];
//    if (!isReachable) {
//        NSError *error = [NSError errorWithDomain:@"网络异常" code:502 userInfo:nil];
//        failure(operation,error);
//    }
//
//    else
//    {
        //网络通畅
        NSError *error1 = [NSError errorWithDomain:@"请求参数不正确" code:500 userInfo:nil];
    
    
   
    
    
         operation=[super POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSDictionary*dict=(NSDictionary*)responseObject;
            NSDictionary*inforDict=[dict objectForKey:@"response"];
             
             
             
             
            switch ([[dict objectForKey:@"rspCode"]integerValue]) {
                case 500:
                    success(operation,responseObject);
                    break;
                case 200:
                    success(operation,responseObject);
                    break;
                    case 530:
                {
                    [self remoLogin:^{
                       [super POST:URLString parameters:parameters success:success failure:failure];
                    }];
                    
                }
                    break;
                default:
                    success(operation,responseObject);
                    break;
            }
            
//             [self setCookieWithOperation:operation];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSError *error2 = [NSError errorWithDomain:@"网络异常" code:502 userInfo:nil];
            failure(operation,error2);
            
        }];
        
        
//    }
    return operation;

}


-(void)remoLogin:(void(^)())block{
    NSUserDefaults*users=[NSUserDefaults standardUserDefaults];
    NSString*username=[users objectForKey:@"username"];
    NSString*password=[users objectForKey:username];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString* openUDID = [OpenUDID value];
    NSString*name=[[UIDevice currentDevice] model];
    NSString*phoneType;
    if ([delegate getPhoneType]) {
        phoneType=[delegate getPhoneType];
    }else{
    
        phoneType=@"unKnowIphone";
    }
 NSDictionary*dict=@{@"mobile":username,@"password":password,@"machineType":phoneType,@"machineCode":openUDID};
     NSString*urlString=[self interfaceFromString:interface_login];
    [super POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"msg"] integerValue]==200) {
            delegate.signInfo=[[NSMutableDictionary alloc]initWithDictionary:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"signInfo"]];
          [delegate.userInforDic setObject:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"inviteCode"] forKey:@"inviteCode"];
          [delegate.userInforDic setObject:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] forKey:@"integrity"];
          NSMutableDictionary*parentDic=[[NSMutableDictionary alloc]initWithDictionary:[[[dict objectForKey:@"entity"] objectForKey:@"user"]objectForKey:@"certification"]];
          [delegate.userInforDic setObject:parentDic forKey:@"certification"];
          delegate.integral=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integral"] integerValue];
        }
        block();
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
    
}


/*!
 * @discussion 设置Cookies
 */
- (void)setCookieWithOperation:(AFHTTPRequestOperation *)operation{
    /*
     JSESSIONID=3CF0D595854DA79F755BBC09D9D458B6; Path=/openapi/; HttpOnly, zbzxsessionid=b70c359c14124acf9ce18e43fc28b244; Path=/; HttpOnly, zbzxsessionid=b70c359c14124acf9ce18e43fc28b244; Path=/; HttpOnly, zbzxsessionid=b70c359c14124acf9ce18e43fc28b244; Path=/; HttpOnly, zbzxsessionid=b70c359c14124acf9ce18e43fc28b244; Path=/; HttpOnly
     */
    
    NSString *string = operation.response.allHeaderFields[@"Set-Cookie"];
    //    DDLogVerbose(@"response cookies:%@",string);
    //格式化
    string = [string stringByReplacingOccurrencesOfString:@"HttpOnly," withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"HttpOnly" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *array = [string componentsSeparatedByString:@";"];
    
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionaryWithCapacity:5];
    for (NSString *str in array) {
        NSArray *arr = [str componentsSeparatedByString:@"="];
        [cookieDic setObject:[arr lastObject] forKey:[arr firstObject]];
    }
    NSString*temp=[NSString stringWithFormat:@"%@/openapi",changeURL];
    //添加domain的值 webview发起请求会带上设置好的cookies
    [cookieDic setObject:temp forKey:NSHTTPCookieDomain];
    [cookieDic setObject:temp forKey:NSHTTPCookieOriginURL];
    [cookieDic setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieDic setObject:@"0" forKey:NSHTTPCookieVersion];
    //    DDLogVerbose(@"拼装cookie %@",cookieDic);
    //cookie同步webview
    NSHTTPCookie * userCookie = [NSHTTPCookie cookieWithProperties:cookieDic];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:userCookie];
    
}




@end
