//
//  loginManager.h
//  master
//
//  Created by jin on 15/9/30.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>
/*登陆管理器**/
typedef void (^loginComplite)(id object);
@interface loginManager : NSObject
+(loginManager*)share;
-(void)loginWithUsername:(NSString*)username Password:(NSString *)password LoginComplite:(loginComplite)loginComPlite;

@end
