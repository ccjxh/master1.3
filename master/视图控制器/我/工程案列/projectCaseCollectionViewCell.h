//
//  projectCaseCollectionViewCell.h
//  master
//
//  Created by jin on 15/6/15.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pictureModel.h"
typedef void(^deleteBlock) ();
@interface projectCaseCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *photos;
@property (weak, nonatomic) IBOutlet UIImageView *backimage;
@property(nonatomic)peojectCaseModel*model;
@property(nonatomic)BOOL isExitImageBack;//是否显示背景相框
@property(nonatomic)pictureModel*picModel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property(nonatomic)BOOL isShow;//是否显示左上角状态
@property(nonatomic)BOOL isSel;//选中按钮状态
@property (weak, nonatomic) IBOutlet UIButton *selectButton;//选中button
@property(nonatomic,copy)deleteBlock block;
@property(nonatomic)NSInteger type;//0为工程案例列表界面  1为工程案例详情界面
-(void)reloadData;
-(void)reloadPic;
@end
