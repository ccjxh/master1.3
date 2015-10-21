//
//  hotRankCollectionViewCell.h
//  master
//
//  Created by jin on 15/10/5.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import ""
@interface hotRankCollectionViewCell : UICollectionViewCell
@property ( nonatomic) UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *skills;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidth;
@property (weak, nonatomic) IBOutlet UILabel *userport;
@property (weak, nonatomic) IBOutlet UILabel *perience;
@property (weak, nonatomic) IBOutlet UIImageView *skillpicture;
@property (weak, nonatomic) IBOutlet UIImageView *rankImage;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageLeading;
@property (weak, nonatomic) IBOutlet UIView *vHine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mutableHeight;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property(nonatomic)MasterDetailModel*model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userportWidth;
-(void)reloadData;
@end
