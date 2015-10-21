//
//  secondTableViewCell.h
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^secondBlock)(NSString*secondStatus);
@interface secondTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *nolimit;
@property (weak, nonatomic) IBOutlet UIButton *oneToThree;
@property (weak, nonatomic) IBOutlet UIButton *threeToFive;
@property (weak, nonatomic) IBOutlet UIButton *fiveToTen;
@property (weak, nonatomic) IBOutlet UIButton *afterTen;
@property(nonatomic)NSMutableDictionary*selectedDic;
@property(nonatomic,copy)secondBlock block;
@property(nonatomic,copy)void(^exBlock)();
-(void)reloadData;
@end
