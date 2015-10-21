//
//  myIntegralInforModel.h
//  master
//
//  Created by jin on 15/9/28.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "model.h"
/*我的积分信息模型**/
@interface myIntegralInforModel : model
@property(nonatomic)NSInteger renewDay;//连续签到时间
@property(nonatomic)NSInteger totalIntegral;//总积分
@property(nonatomic)NSInteger nextDayIntegral;//下一次签到可获得的积分
@end
