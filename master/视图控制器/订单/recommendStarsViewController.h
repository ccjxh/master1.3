//
//  recommendStarsViewController.h
//  master
//
//  Created by jin on 15/6/3.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface recommendStarsViewController : RootViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)MasterDetailModel*model;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)UITextView*tx;
@property(nonatomic)NSInteger id;
@property(nonatomic)NSString*content;//评价内容
@property(nonatomic)NSMutableArray*pictureArray;
@property(nonatomic)NSInteger skillScore;//专业技能星星
@property(nonatomic)NSInteger serviceScore;//服务态度星星
@property(nonatomic)NSInteger peopleScore;//个人诚信星星
@property(nonatomic)NSMutableArray*picDataArray;//图片二进制数组
@property(nonatomic)CGFloat imageWidth;
@property(nonatomic)NSMutableArray*skillArray;//技能数组

-(void)confirm;
-(void)initData;
-(UITableViewCell*)getStars:(UITableView*)tableview Indexpath:(NSIndexPath*)indexpath;
-(UITableViewCell*)getContent:(UITableView*)tableview;
@end
