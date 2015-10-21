//
//  ListRootViewController.h
//  master
//
//  Created by jin on 15/5/19.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface ListRootViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)NSString*cityName;
@property(nonatomic)NSString*type;//名字后面的类型
@property(nonatomic)NSInteger firstLocation;//用户岗位
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)UISearchBar*searchBar;
@property(nonatomic)NSString*totalResults;
//@property(nonatomic)UISearchDisplayController*searchdisplay;
/**
 * 用户岗位(1--雇主,2--师傅，3--包工头，4--项目经理)
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
