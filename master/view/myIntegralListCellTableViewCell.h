//
//  myIntegralListCellTableViewCell.h
//  master
//
//  Created by jin on 15/9/28.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myIntegralListCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *detailView;
@property(nonatomic,copy)NSString*content;  //积分增减详情
-(void)reloadData;
@end
