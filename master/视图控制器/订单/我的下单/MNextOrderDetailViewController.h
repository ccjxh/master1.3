//
//  MNextOrderDetailViewController.h
//  master
//
//  Created by jin on 15/6/2.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "orderDetailOrderViewController.h"
/**下单详情*/
typedef void (^statusBlock)(BOOL isChange);
@interface MNextOrderDetailViewController : orderDetailOrderViewController
@property(nonatomic,copy)statusBlock block;
@end
