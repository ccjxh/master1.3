//
//  selectTownViewController.h
//  master
//
//  Created by jin on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "areaRootViewController.h"

@interface selectTownViewController : areaRootViewController
@property(nonatomic,copy)void(^selectTownBlock1)(AreaModel*model);
@property(nonatomic)NSMutableArray*array;//已选中的城市
@end
