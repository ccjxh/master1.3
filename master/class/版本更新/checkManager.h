//
//  checkManager.h
//  master
//
//  Created by jin on 15/9/16.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface checkManager : NSObject<FDAlertViewDelegate>
+(checkManager*)share;
-(void)checkVersion;

@end
