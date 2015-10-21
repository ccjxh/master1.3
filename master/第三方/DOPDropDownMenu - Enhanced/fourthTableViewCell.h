//
//  fourthTableViewCell.h
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^fourthBlock)(NSString*fourthStstus);
@interface fourthTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *nolimit;
@property (weak, nonatomic) IBOutlet UIButton *eighteen;
@property (weak, nonatomic) IBOutlet UIButton *thirty;
@property (weak, nonatomic) IBOutlet UIButton *fifty;
@property(nonatomic)NSMutableDictionary*selectedDic;
@property(nonatomic,copy)fourthBlock block;
@property(nonatomic,copy)void(^faileBlock)();
-(void)reloadData;
@end
