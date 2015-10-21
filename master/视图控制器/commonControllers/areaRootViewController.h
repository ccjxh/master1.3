//
//  areaRootViewController.h
//  master
//
//  Created by jin on 15/5/25.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"
#import "AreaModel.h"
#import "selectedCityinforView.h"
#import "cityCollectionViewCell.h"
@interface areaRootViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic)AreaModel*proviceModel;//省份模型
@property(nonatomic)AreaModel*cityModel;//市模模型
@property(nonatomic)AreaModel*townModel;//地区模型
@property(nonatomic)NSInteger type;//父视图控制器  0为省   1为市  2为区
@property(nonatomic)NSMutableArray*dataArray;//tableview数据源
@property(nonatomic)NSString*urlString;
@property(nonatomic)NSDictionary*dict;//post请求字典
@property(nonatomic)UIViewController*viewcontroller;//最后要返回的viewcontorller
@property ( nonatomic)  UITableView *tableview;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)selectCity;
@end
