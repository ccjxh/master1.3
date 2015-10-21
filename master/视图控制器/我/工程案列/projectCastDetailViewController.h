//
//  projectCastDetailViewController.h
//  master
//
//  Created by jin on 15/6/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface projectCastDetailViewController : RootViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property ( nonatomic) UICollectionView *collectionview;
@property(nonatomic)NSInteger id;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)NSString*introlduce;//说明
@property(nonatomic)NSString*name;
@property(nonatomic)peojectCaseModel*model;
@property(nonatomic)BOOL isShow;//控制显示选择图片
@property(nonatomic)NSIndexPath*currentIndexPath;//当前选中的indexpath
@property(nonatomic)NSMutableArray*deleArray;
@property(nonatomic)NSInteger type;//1为详情界面 
@property(nonatomic)BOOL isStars;//是否是明星工程

@end
