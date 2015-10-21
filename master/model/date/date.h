//
//  date.h
//  master
//
//  Created by jin on 15/5/22.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface date : UIView
+(date*)share;
@property(nonatomic,copy)void(^dateBlock)(NSString*ValueDate);
-(void) initPickerView;
@end
