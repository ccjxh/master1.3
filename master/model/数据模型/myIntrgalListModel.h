//
//  myIntrgalListModel.h
//  master
//
//  Created by jin on 15/10/5.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "model.h"
/*我的积分列表数据莫ing**/
@interface myIntrgalListModel : model
@property(nonatomic)NSInteger id;
@property(nonatomic)NSString *type;//类型
@property(nonatomic)NSInteger value;//获得积分
@property(nonatomic)NSString* readme;//方式
@property(nonatomic)NSString*createTime;//创建时间
@end
