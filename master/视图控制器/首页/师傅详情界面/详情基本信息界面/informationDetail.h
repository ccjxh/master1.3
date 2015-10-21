//
//  informationDetail.h
//  master
//
//  Created by jin on 15/8/5.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "personDetailViewModel.h"
/*
 详情界面个人信息view
 **/
@interface informationDetail : UIView<UITableViewDataSource,UITableViewDelegate>
//@property (weak, nonatomic) IBOutlet UITableView *tableview;
//@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property(nonatomic)UITableView*tableview;
@property(nonatomic)UIButton*orderButton;//预定button
@property(nonatomic)NSMutableArray*dataArray;//数据源
@property(nonatomic)personDetailViewModel*model;
@property(nonatomic,copy)void(^checkBlock)();//举报按钮点击触发
@property(nonatomic,copy)void(^tableDisSelected)(NSIndexPath*indexPath,personDetailViewModel*model);
@property(nonatomic,copy)void(^imageDisplay)(NSInteger index,UIImageView*imageview,personDetailViewModel*model);
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property(nonatomic,copy)void(^headImageBlock)(NSString*urlString,peopleDetailTableViewCell*cell);
@end
