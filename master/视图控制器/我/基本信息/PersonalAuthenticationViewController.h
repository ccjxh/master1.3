//
//  PersonalAuthenticationViewController.h
//  master
//
//  Created by xuting on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"
#import "PersonalDetailModel.h"
typedef void (^AuthorTypeBlcok) (BOOL authorType);

@interface PersonalAuthenticationViewController : RootViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITableView *personalAuthorTableView;
@property (nonatomic,copy) AuthorTypeBlcok authorTypeBlock;
@property (nonatomic,strong) PersonalDetailModel *model;

@end
