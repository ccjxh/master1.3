//
//  firstAreaViewController.h
//  master
//
//  Created by jin on 15/9/22.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "RootViewController.h"

@interface firstAreaViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    NSMutableArray*_dataArray;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSMutableArray*selectArray;//已选择数组
-(void)request;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
