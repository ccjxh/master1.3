//
//  SelectManager.h
//  master
//
//  Created by jin on 15/10/10.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>
/*tableview didselected管理器**/
@interface SelectManager : NSObject
+(SelectManager*)share;
-(void)tableviewDidSelectWithKindOfClass:(NSString*)classString IndexPath:(NSIndexPath*)indexPath Navigatingation:(UINavigationController*)navigationController Tableview:(UITableView*)tableview;
@end
