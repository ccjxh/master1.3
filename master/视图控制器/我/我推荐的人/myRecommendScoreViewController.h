//
//  myRecommendScoreViewController.h
//  master
//
//  Created by jin on 15/6/9.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "recommendStarsViewController.h"
#import "MasterDetailModel.h"

@interface myRecommendScoreViewController : recommendStarsViewController
@property(nonatomic)NSInteger orderID;
@property(nonatomic)UIViewController*vc;
//@property(nonatomic)NSMutableArray*skillArray;
@property (nonatomic,strong) MasterDetailModel *dModel;
@end
