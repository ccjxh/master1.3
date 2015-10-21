//
//  selectedCityinforView.h
//  master
//
//  Created by jin on 15/8/17.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selectedCityinforView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic,copy)void(^cityCellOnclick)(NSIndexPath*indexpath);
@end
