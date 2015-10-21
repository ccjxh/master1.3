//
//  picdisplayViewController.h
//  master
//
//  Created by jin on 15/6/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface picdisplayViewController : RootViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)CGFloat currentScale;//当前比例
@end
