//
//  selectedCityinforView.m
//  master
//
//  Created by jin on 15/8/17.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "selectedCityinforView.h"

@implementation selectedCityinforView


-(instancetype)initWithFrame:(CGRect)frame{


    if (self=[super initWithFrame:frame]) {
        
        [_collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
    }
    
    return self;

}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 2;

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (_dataArray.count!=0) {
        if (section==0) {
            return 1;
        }
        if (section==1) {
            return _dataArray.count;
        }
    }

    return 0;


}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        UICollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.backgroundColor=[UIColor redColor];
        return cell;
    }

        UICollectionViewCell*Cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        Cell.backgroundColor=[UIColor blackColor];
        return Cell;

}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.cityCellOnclick) {
        self.cityCellOnclick(indexPath);
    }

}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return CGSizeMake(80, 25);
    }
    if (indexPath.section==1) {
        return CGSizeMake((SCREEN_WIDTH-40)/3, 25);
    }
    return CGSizeZero;
}


@end
